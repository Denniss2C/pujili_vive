import 'dart:async';

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
/// Sin red, el area del mapa se queda en el color de fondo con un aviso
/// encima, y el sheet de "Explorar lugares" sigue funcionando, que es lo
/// que pide el diseño para ese caso (`docs/CONCEPTO.md` §4.5, Estados).
class MapPage extends StatefulWidget {
  /// De donde salen las teselas. Solo lo cambian los tests, para simular
  /// un telefono sin red; la app usa siempre OpenStreetMap.
  @visibleForTesting
  final TileProvider? tileProvider;

  const MapPage({super.key, this.tileProvider});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  ThematicRoute _route = ThematicRoute.all;

  /// La pagina solo decide **que ruta** se mira. Donde apunta la camara lo
  /// decide `_Map`, que es quien conoce su propio tamaño: sin el alto no
  /// se puede saber cuanto tapa el sheet.
  void _onRouteChanged(ThematicRoute route) {
    setState(() => _route = route);
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
                onChanged: _onRouteChanged,
              ),
              Expanded(
                child: Stack(
                  children: [
                    _Map(
                      route: _route,
                      places: places,
                      tileProvider: widget.tileProvider,
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

/// Encuadre de camara que deja visibles todos los lugares.
///
/// **El margen de abajo no es simetrico a proposito.** El sheet "Explorar
/// lugares" cubre [PlacesSheet.initialSize] del alto, asi que encuadrar
/// contra el alto entero mete los pines del sur detras del sheet: no se
/// ven y no se pueden tocar. Se descuenta esa franja, mas un margen para
/// que el pin no quede pegado al borde.
///
/// [mapHeight] es el alto del area de mapa, no el de la pantalla.
CameraFit cameraFitFor(List<Attraction> places, {required double mapHeight}) {
  const margin = 48.0;

  return CameraFit.bounds(
    bounds: boundsOf(places),
    padding: EdgeInsets.fromLTRB(
      margin,
      margin,
      margin,
      margin + mapHeight * PlacesSheet.initialSize,
    ),
  );
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
      // La paleta tiene tres colores de acento y cuatro categorias. El
      // gris oscuro es el unico tono restante que se lee sobre teselas;
      // si algun dia la paleta gana un cuarto acento, este es el sitio.
      return AppColors.textDark;
  }
}

/// El mapa y su camara.
///
/// Tiene estado —y no lo tiene la pagina— porque encuadrar necesita el
/// alto del area de mapa, y el alto solo se conoce aqui dentro.
class _Map extends StatefulWidget {
  final ThematicRoute route;
  final List<Attraction> places;
  final TileProvider? tileProvider;

  const _Map({
    required this.route,
    required this.places,
    this.tileProvider,
  });

  @override
  State<_Map> createState() => _MapState();
}

class _MapState extends State<_Map> {
  final MapController _controller = MapController();

  /// Casco urbano de Pujili. Es el centro de arranque y el que se usa
  /// cuando no hay nada que encuadrar (`CONCEPTO.md` §4.5, Estados: la
  /// app debe ser usable sin conceder ubicacion).
  static const _pujili = LatLng(-0.9578, -78.6967);

  double _mapHeight = 0;

  /// Uno solo para toda la vida del mapa. Si el `TileLayer` lo crea por su
  /// cuenta, cada repintado —cada cambio de ruta— estrena un proveedor con
  /// su propio cliente HTTP, y al salir solo se cierra el ultimo.
  ///
  /// No se desecha en [dispose]: lo hace el `TileLayer` al desmontarse.
  late final TileProvider _tiles = widget.tileProvider ?? NetworkTileProvider();

  /// Cada evento hace que el `TileLayer` descarte sus teselas y las pida
  /// de nuevo. Es lo que dispara "Reintentar".
  final StreamController<void> _reloadTiles = StreamController.broadcast();

  bool _tilesFailed = false;

  /// Las teselas esperan a que el mapa este encuadrado. `FlutterMap`
  /// aplica `initialCameraFit` en un post-frame callback, asi que el
  /// primer frame sale con el zoom inicial; con el `TileLayer` ya montado,
  /// en ese frame se pedian ~30 teselas de zoom 13 que el encuadre
  /// descartaba al instante. `onMapReady` llega en el mismo post-frame,
  /// registrado antes que el encuadre: para el frame siguiente la camara
  /// ya esta en su sitio.
  bool _mapReady = false;

  /// `FlutterMap` solo libera el controlador si lo creo el mismo; este es
  /// nuestro, y ademas le cuelga un `AnimationController`. Sin esta
  /// llamada se filtra.
  @override
  void dispose() {
    _controller.dispose();
    _reloadTiles.close();
    super.dispose();
  }

  void _onTileError(TileImage tile, Object error, StackTrace? stackTrace) {
    if (_tilesFailed) return;
    // El fallo puede llegar mientras el `TileLayer` se esta construyendo,
    // y ahi no se puede llamar a setState: se aplaza al final del frame.
    scheduleMicrotask(() {
      if (mounted && !_tilesFailed) setState(() => _tilesFailed = true);
    });
  }

  void _retryTiles() {
    setState(() => _tilesFailed = false);
    _reloadTiles.add(null);
  }

  /// Reencuadra al cambiar de ruta.
  ///
  /// Se compara la **ruta** y no la lista de lugares porque el filtro
  /// devuelve una lista nueva en cada build: comparar listas reencuadraria
  /// el mapa en cada repintado y el usuario no podria ni moverlo.
  ///
  /// El **primer** encuadre no pasa por aqui: lo hace `FlutterMap` con
  /// `initialCameraFit`, que espera a tener un tamaño real antes de
  /// aplicarlo. Encuadrar a mano contra un tamaño cero produce una camara
  /// degenerada y el mapa se quedaria abierto al mundo entero.
  @override
  void didUpdateWidget(_Map old) {
    super.didUpdateWidget(old);

    // Una ruta vacia deja la camara donde estaba: no hay nada que
    // encuadrar, y mover el mapa sin pines solo desorienta.
    if (old.route != widget.route && widget.places.isNotEmpty) {
      _controller.fitCamera(cameraFitFor(widget.places, mapHeight: _mapHeight));
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;

    return LayoutBuilder(
      builder: (context, constraints) {
        _mapHeight = constraints.maxHeight;

        return FlutterMap(
          mapController: _controller,
          options: MapOptions(
            initialCenter: _pujili,
            initialZoom: 13,
            // El Quilotoa esta a ~25 km del casco urbano: sin encuadrar, un
            // zoom fijo sobre Pujili lo dejaria siempre fuera de pantalla.
            // Lo aplica `FlutterMap` cuando ya tiene un tamaño real.
            initialCameraFit: widget.places.isEmpty
                ? null
                : cameraFitFor(widget.places, mapHeight: _mapHeight),
            // Suelo de zoom. Sin el, un pellizco puede alejarse hasta ver
            // el mundo entero: ahi la proyeccion repite el planeta a los
            // lados y `MarkerLayer` clona cada pin **con su misma Key** en
            // cada copia, lo que revienta el `Stack` en debug con
            // "Duplicate keys found". Y de paso no tiene sentido pedir
            // teselas de medio planeta para ver un canton.
            minZoom: 9,
            // Sin rotacion. `flutter_map` la trae activada y no hay brujula
            // para deshacerla, asi que un giro accidental con dos dedos
            // dejaria el mapa torcido sin vuelta atras. Los pines tampoco
            // se mantienen verticales por si solos: girarian con el mapa
            // hasta dejar de apuntar a su propio punto.
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            ),
            // Lo que se ve mientras las teselas cargan, o si no hay red. En
            // crema y no en el gris del paquete: parece parte de la app y
            // no un hueco.
            backgroundColor: AppColors.cream,
            onMapReady: () => setState(() => _mapReady = true),
          ),
          children: [
            if (_mapReady)
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                // La politica de teselas de la OSM Foundation exige que la
                // app se identifique. Sin esto pueden bloquearla.
                userAgentPackageName: 'ec.gob.pujili.pujili_vive',
                tileProvider: _tiles,
                errorTileCallback: _onTileError,
                reset: _reloadTiles.stream,
              ),
            MarkerLayer(
              markers: [
                for (final place in widget.places)
                  Marker(
                    key: Key('map-pin-${place.id}'),
                    point: LatLng(place.latitude, place.longitude),
                    width: 44,
                    height: 44,
                    // El pin apunta hacia abajo, asi que el widget va
                    // encima del punto. No es `topCenter` exacto: los
                    // iconos de Material dejan 2 de sus 24 unidades de
                    // margen, asi que la punta dibujada no llega al borde
                    // de su caja y con `topCenter` cada pin señalaria ~6 px
                    // mas arriba de su sitio —unos 115 m con el zoom de
                    // arranque—. El -0.72 baja el ancla hasta la punta de
                    // verdad.
                    alignment: const Alignment(0, -0.72),
                    child: _Pin(
                      label: place.name.resolve(lang),
                      color: markerColorOf(place.category),
                      onTap: () => AttractionDetailPage.open(context, place),
                    ),
                  ),
              ],
            ),
            const _OpenStreetMapCredit(),
            if (_tilesFailed) _TilesFailedNotice(onRetry: _retryTiles),
          ],
        );
      },
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
/// credito se vea. El texto es el que piden las guias de atribucion de
/// la OSMF, con "contributors" incluido: son los que aportan los datos y
/// nombrarlos es justo la parte que la licencia reclama.
///
/// Va arriba a la derecha porque el sheet arrastrable tapa la esquina de
/// abajo, que es donde suele ponerse.
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
              '© OpenStreetMap contributors',
              style: TextStyle(fontSize: 11, color: AppColors.textDark),
            ),
          ),
        ),
      ),
    );
  }
}

/// Aviso de que las teselas no cargan (`CONCEPTO.md` §4.5, Estados: sin
/// red). Va **dentro** del area del mapa y no a pantalla completa: el
/// sheet de lugares es local y sigue sirviendo sin conexion.
///
/// Dice "no se pudo cargar" y no "sin conexion" a proposito: lo unico que
/// la app sabe es que las teselas fallaron. Un telefono puede tener wifi y
/// no resolver nombres —le paso al emulador—, y ahi un detector de
/// conectividad juraria que todo va bien.
class _TilesFailedNotice extends StatelessWidget {
  final VoidCallback onRetry;

  const _TilesFailedNotice({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        // Por debajo del credito de OpenStreetMap, que ocupa la esquina.
        padding: const EdgeInsets.fromLTRB(12, 36, 12, 0),
        child: Material(
          key: const Key('map-tiles-failed'),
          color: AppColors.cardBackground,
          elevation: 2,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 6, 6, 6),
            child: Row(
              children: [
                const Icon(
                  Icons.cloud_off_outlined,
                  color: AppColors.terracotta,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l.mapTilesFailed,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                TextButton(onPressed: onRetry, child: Text(l.retry)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
