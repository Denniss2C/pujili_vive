import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../attractions/domain/entities/attraction.dart';
import '../../../attractions/domain/entities/attraction_category.dart';
import '../../../attractions/presentation/bloc/attractions_bloc.dart';
import '../../../attractions/presentation/pages/attraction_detail_page.dart';
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
/// **Teselas de OpenStreetMap, sin API key ni facturacion** (ver
/// `docs/MAPS_SETUP.md`). El mapa funciona recien clonado el repo. A
/// cambio, las teselas son un servicio donado por la OSM Foundation con
/// condiciones de uso: la app se identifica con `userAgentPackageName` y
/// el credito a OpenStreetMap se pinta en pantalla, que la licencia ODbL
/// lo exige.
///
/// Sin red, el area del mapa se queda en el color de fondo y el sheet de
/// "Explorar lugares" sigue funcionando, que es lo que pide el diseño
/// para ese caso (`docs/CONCEPTO.md` §4.5, Estados).
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  ThematicRoute _route = ThematicRoute.all;
  final MapController _controller = MapController();

  /// `fitCamera` necesita que el mapa exista: llamarlo antes de que
  /// `FlutterMap` se monte lanza. `onMapReady` levanta esta bandera.
  bool _ready = false;

  /// Casco urbano de Pujili. Es el centro de arranque y el que se usa
  /// cuando no hay nada que encuadrar (`CONCEPTO.md` §4.5, Estados: la
  /// app debe ser usable sin conceder ubicacion).
  static const _pujili = LatLng(-0.9578, -78.6967);

  @override
  void dispose() {
    _controller.dispose();
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
  void _fitTo(List<Attraction> places) {
    if (!_ready || places.isEmpty) return;

    _controller.fitCamera(
      CameraFit.bounds(
        bounds: boundsOf(places),
        padding: const EdgeInsets.all(64),
      ),
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
                      controller: _controller,
                      onReady: () {
                        _ready = true;
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
/// Esta fuera del `State` para poder probarla sola, sin encuadrar un mapa
/// de verdad.
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

  return LatLngBounds(LatLng(minLat, minLng), LatLng(maxLat, maxLng));
}

/// Color del pin segun la categoria del lugar.
///
/// Google imponia su catalogo cerrado de tonos; al pintar los pines
/// nosotros, el mapa habla el idioma visual del resto de la app. Lo unico
/// que el mapa no puede permitirse es que dos categorias compartan color:
/// serian pines distintos que parecen lo mismo.
Color markerColorOf(AttractionCategory category) {
  switch (category) {
    case AttractionCategory.crafts:
      return AppColors.terracotta;
    case AttractionCategory.religious:
      return AppColors.gold;
    case AttractionCategory.nature:
      return AppColors.deepGreen;
    case AttractionCategory.cultural:
      return AppColors.textDark;
  }
}

class _Map extends StatelessWidget {
  final List<Attraction> places;
  final LatLng initial;
  final MapController controller;
  final VoidCallback onReady;

  const _Map({
    required this.places,
    required this.initial,
    required this.controller,
    required this.onReady,
  });

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;

    return FlutterMap(
      mapController: controller,
      options: MapOptions(
        initialCenter: initial,
        initialZoom: 13,
        onMapReady: onReady,
        // Lo que se ve mientras las teselas cargan, o si no hay red. En
        // crema y no en el gris del paquete: parece parte de la app y no
        // un hueco.
        backgroundColor: AppColors.cream,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          // La politica de teselas de la OSM Foundation exige que la app
          // se identifique. Sin esto pueden bloquearla.
          userAgentPackageName: 'ec.gob.pujili.pujili_vive',
        ),
        MarkerLayer(
          markers: [
            for (final place in places)
              Marker(
                key: Key('map-pin-${place.id}'),
                point: LatLng(place.latitude, place.longitude),
                width: 44,
                height: 44,
                // El pin apunta hacia abajo: el widget va encima del
                // punto para que la punta caiga sobre las coordenadas.
                alignment: Alignment.topCenter,
                child: _Pin(
                  label: place.name.resolve(lang),
                  color: markerColorOf(place.category),
                  onTap: () => AttractionDetailPage.open(context, place),
                ),
              ),
          ],
        ),
        const _OpenStreetMapCredit(),
      ],
    );
  }
}

/// Pin de un lugar.
///
/// El diseño pide una gota con un icono ilustrado dentro —un cantaro,
/// una cupula, una montaña—, y esos dibujos no existen todavia. Hasta que
/// existan, la gota de Material en el color de la categoria: una
/// degradacion honesta y no un pin inventado.
///
/// El halo blanco no es adorno. Sobre un mapa con calles y manchas verdes
/// un pin plano se pierde, y el terracota sobre teja es casi invisible.
class _Pin extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _Pin({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            const Icon(Icons.place, size: 44, color: Colors.white),
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Icon(Icons.place, size: 38, color: color),
            ),
          ],
        ),
      ),
    );
  }
}

/// Credito a OpenStreetMap.
///
/// No es decorativo: las teselas son ODbL y la licencia exige que el
/// credito se vea. Va arriba a la derecha porque el sheet arrastrable
/// tapa la esquina de abajo, que es donde suele ponerse.
class _OpenStreetMapCredit extends StatelessWidget {
  const _OpenStreetMapCredit();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.cardBackground.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            child: Text(
              '© OpenStreetMap',
              style: TextStyle(fontSize: 11, color: AppColors.textDark),
            ),
          ),
        ),
      ),
    );
  }
}
