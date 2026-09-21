import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../attractions/domain/entities/attraction.dart';
import '../../../attractions/domain/entities/attraction_category.dart';
import '../../../attractions/presentation/bloc/attractions_bloc.dart';
import '../../domain/entities/thematic_route.dart';
import '../widgets/places_sheet.dart';
import '../widgets/route_selector.dart';

/// Mapa con los atractivos (`docs/MOCKS.html`, pantalla 5).
///
/// **No tiene capas domain ni data.** Igual que `home`, no tiene datos
/// propios: consume el `AttractionsBloc` que ya provee la raiz. Crear una
/// entidad y un repositorio para releer el mismo JSON seria duplicarlo.
///
/// **El filtro de ruta es estado local y no del bloc** a proposito: el
/// bloc lo comparten este tab y Explorar, asi que mover su `activeFilter`
/// desde aqui cambiaria en silencio lo que ve el otro tab.
///
/// ---
/// **Hace falta una Google Maps API key** (ver `docs/MAPS_SETUP.md`). Sin
/// ella el area del mapa sale en blanco. La pantalla esta montada para
/// que eso no la inutilice: el sheet de "Explorar lugares" lee datos
/// locales y sigue funcionando, que es justo lo que pide el diseño para
/// el caso "sin red" (`docs/CONCEPTO.md` §4.5, Estados).
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  ThematicRoute _route = ThematicRoute.all;
  GoogleMapController? _controller;

  /// Casco urbano de Pujili. Es el centro de arranque y el que se usa
  /// cuando no hay nada que encuadrar (`CONCEPTO.md` §4.5, Estados: la
  /// app debe ser usable sin conceder ubicacion).
  static const _pujili = LatLng(-0.9578, -78.6967);

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _onRouteChanged(ThematicRoute route, List<Attraction> all) {
    setState(() => _route = route);
    _fitTo(_route.filter(all));
  }

  /// Encuadra los pines visibles.
  ///
  /// Hace falta porque el Quilotoa esta a ~25 km del casco urbano: un
  /// zoom fijo sobre Pujili lo dejaria siempre fuera de pantalla.
  Future<void> _fitTo(List<Attraction> places) async {
    final controller = _controller;
    if (controller == null || places.isEmpty) return;

    await controller.animateCamera(
      CameraUpdate.newLatLngBounds(boundsOf(places), 64),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l.mapTitle)),
      body: BlocBuilder<AttractionsBloc, AttractionsState>(
        builder: (context, state) {
          if (state is AttractionsLoading || state is AttractionsInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AttractionsError) {
            return Center(child: Text(state.message));
          }
          if (state is! AttractionsLoaded) return const SizedBox.shrink();

          final places = _route.filter(state.all);

          return Column(
            children: [
              RouteSelector(
                active: _route,
                onChanged: (route) => _onRouteChanged(route, state.all),
              ),
              Expanded(
                child: Stack(
                  children: [
                    _Map(
                      places: places,
                      initial: _pujili,
                      onCreated: (controller) {
                        _controller = controller;
                        _fitTo(places);
                      },
                    ),
                    PlacesSheet(places: places),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Rectangulo que contiene todos los puntos.
///
/// Con un solo lugar el rectangulo seria un punto y el mapa haria un
/// zoom absurdo, asi que se le da un margen minimo.
///
/// Esta fuera del `State` para poder probarla sin montar la pantalla: el
/// widget `GoogleMap` es una platform view y no se puede pintar en un
/// test de widget.
LatLngBounds boundsOf(List<Attraction> places) {
  assert(places.isNotEmpty, 'boundsOf necesita al menos un lugar');

  var minLat = places.first.latitude;
  var maxLat = places.first.latitude;
  var minLng = places.first.longitude;
  var maxLng = places.first.longitude;

  for (final p in places) {
    if (p.latitude < minLat) minLat = p.latitude;
    if (p.latitude > maxLat) maxLat = p.latitude;
    if (p.longitude < minLng) minLng = p.longitude;
    if (p.longitude > maxLng) maxLng = p.longitude;
  }

  const minSpan = 0.01;
  if (maxLat - minLat < minSpan) {
    final mid = (maxLat + minLat) / 2;
    minLat = mid - minSpan / 2;
    maxLat = mid + minSpan / 2;
  }
  if (maxLng - minLng < minSpan) {
    final mid = (maxLng + minLng) / 2;
    minLng = mid - minSpan / 2;
    maxLng = mid + minSpan / 2;
  }

  return LatLngBounds(
    southwest: LatLng(minLat, minLng),
    northeast: LatLng(maxLat, maxLng),
  );
}

/// Color del pin segun la categoria del lugar.
///
/// El diseño pide pines ilustrados —un cantaro, una cupula, una montaña—
/// dentro de una gota. Eso necesita iconos dibujados que no existen
/// todavia, asi que por ahora se distinguen por color, que es una
/// degradacion honesta y no un pin inventado.
double markerHueOf(AttractionCategory category) {
  switch (category) {
    case AttractionCategory.crafts:
      return BitmapDescriptor.hueOrange;
    case AttractionCategory.religious:
      return BitmapDescriptor.hueViolet;
    case AttractionCategory.nature:
      return BitmapDescriptor.hueGreen;
    case AttractionCategory.cultural:
      return BitmapDescriptor.hueAzure;
  }
}

class _Map extends StatelessWidget {
  final List<Attraction> places;
  final LatLng initial;
  final ValueChanged<GoogleMapController> onCreated;

  const _Map({
    required this.places,
    required this.initial,
    required this.onCreated,
  });

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;

    return GoogleMap(
      initialCameraPosition: CameraPosition(target: initial, zoom: 13),
      onMapCreated: onCreated,
      markers: {
        for (final place in places)
          Marker(
            markerId: MarkerId(place.id),
            position: LatLng(place.latitude, place.longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              markerHueOf(place.category),
            ),
            infoWindow: InfoWindow(
              title: place.name.resolve(lang),
              snippet: place.location.resolve(lang),
            ),
          ),
      },
      // El boton de "mi ubicacion" pediria permiso de geolocalizacion, que
      // depende de la pregunta abierta nº 9 y cambiaria el onboarding.
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      // El sheet arrastrable tapa el control nativo de zoom.
      zoomControlsEnabled: false,
    );
  }
}
