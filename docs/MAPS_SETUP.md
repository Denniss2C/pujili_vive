# El mapa

La app dibuja el mapa con [`flutter_map`](https://pub.dev/packages/flutter_map)
sobre teselas de **OpenStreetMap**. No hay API key, ni cuenta de Google
Cloud, ni secreto en el CI: **el mapa funciona recién clonado el repo**.

Este documento existe de todos modos, porque las teselas gratuitas no son
gratis para todo el mundo y conviene saber por qué.

## 1. De dónde salen las teselas

```
https://tile.openstreetmap.org/{z}/{x}/{y}.png
```

Es el servidor público de la **OpenStreetMap Foundation**, un servicio
donado con una
[política de uso](https://operations.osmfoundation.org/policies/tiles/) que
la app cumple así:

| Lo que pide la política | Cómo lo cumple la app |
| --- | --- |
| Identificarse con un `User-Agent` propio | `userAgentPackageName: 'ec.gob.pujili.pujili_vive'` en el `TileLayer` |
| No usar subdominios (`{s}.tile...`) | La URL no los lleva |
| Acreditar a OpenStreetMap de forma visible | El crédito se pinta arriba a la derecha del mapa, y hay un test que falla si alguien lo borra |
| Tráfico moderado, sin descargas masivas | La app solo pide las teselas que el usuario mira; no precarga ni guarda regiones |

**Al ejecutar en modo debug, `flutter_map` imprime un aviso** recordando esa
política. Es del paquete, no de la app: está detrás de `kDebugMode`, así que
no aparece en release ni lo ve un usuario. No se puede silenciar sin cambiar
de servidor de teselas.

## 2. Si la app crece

El servidor de la OSMF va sobrado para una app municipal, pero no es para
tráfico de producción a gran escala. Si algún día hace falta mudarse, solo
cambia el `urlTemplate` (y las cabeceras) del `TileLayer` en
[`map_page.dart`](../lib/features/map/presentation/pages/map_page.dart).
Candidatos habituales, todos con capa gratuita y **key propia**: MapTiler,
Stadia Maps, Thunderforest, o un servidor de teselas propio.

Ese mismo cambio es el que haría falta para el **aspecto terracota** que
dibuja el diseño (`docs/MOCKS.html`, pantalla 5): el estilo por defecto de
OpenStreetMap no se puede tematizar desde la app, eso lo decide quien sirve
las teselas.

## 3. Qué pasa sin red

El área del mapa se queda en el crema de la paleta y el sheet "Explorar
lugares" sigue funcionando, porque lee el JSON local. Es lo que pide
`CONCEPTO.md` §4.5 para ese caso.

## 4. Lo que el mapa *no* hace

- **No pide la ubicación del usuario.** No hay botón de "mi ubicación" y el
  manifest no declara permisos de ubicación: depende de la pregunta abierta
  nº 9 de `CONCEPTO.md`.
- **No calcula rutas.** "Cómo llegar" abre la app de mapas del teléfono
  (Apple Maps en iOS, Google Maps en el resto) vía `url_launcher`. Eso no
  necesita key ni cuesta dinero: es la app instalada la que trabaja.

## 5. Verificación

```bash
flutter test test/features/map/   # el mapa entra en la suite
flutter run --flavor dev          # las teselas deben cargar sin configurar nada
```
