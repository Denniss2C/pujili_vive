# Changelog

Todos los cambios notables de este proyecto se documentan en este archivo.

El formato sigue [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/)
y el proyecto se adhiere a [Semantic Versioning](https://semver.org/lang/es/).

## [Unreleased]

### Added
- **Marca propia**: icono de app en Android e iOS y splash nativo, en vez
  del icono azul de Flutter y el splash blanco de la plantilla. La marca
  es el tocado de plumas del Danzante sobre la mascara, dibujada con la
  paleta del proyecto. Es un **placeholder honesto**: sirve para dejar de
  parecer un proyecto sin estrenar y se sustituye sin tocar codigo.
- La misma marca en la cabecera de Inicio, para que la app se reconozca
  por dentro igual que en el lanzador.
- Feature `favorites`: corazon en el detalle de atractivo y de fiesta, y
  pantalla "Guardados" detras del corazon de la cabecera de Inicio. No es
  un tab: los cinco estan tomados.
- Guardados almacena **ids, no copias**, asi que nunca enseña datos
  viejos y un guardado huerfano —si el atractivo desaparece del JSON—
  simplemente deja de aparecer en vez de quedar como ficha rota.
- `InMemoryFavoritesRepository` en los helpers de test: un repositorio que
  funciona de verdad, para que un test pueda tocar el corazon y comprobar
  el resultado sin programar respuestas una por una.

- El calendario esta **vivo**: mira el reloj y una fiesta pasa sola a
  tarjeta blanca cuando le llega su hora, y se atenua cuando termina, sin
  que el usuario toque nada. La lista se repinta cada 30 s.
- `EventStatus` y `FestivalEvent.statusAt()`: en que punto esta una
  fiesta respecto al reloj (`upcoming` / `inProgress` / `past`). Vive en
  domain, asi que se prueba sin pintar nada.
- Las fiestas tienen **hora de inicio y de fin**, no solo fecha. El
  bloque de fecha de la tarjeta la muestra, porque con dos fiestas por
  dia el dia solo ya no las distingue.
- Programa simulado de 15 dias en `festival_events.json`: 30 fiestas
  cantonales inventadas, dos por dia, del 21 de septiembre al 5 de
  octubre de 2026. **Sustituye a las 4 fiestas de 2027.** Las fiestas
  reales son dos al año, Corpus en junio y cantonales en octubre; hay que
  poner las de verdad antes de publicar.
- Tests que validan el programa entero: dos fiestas por dia, sin huecos,
  sin solapes, sin cruzar la medianoche y con fin posterior al inicio.

- Mapa: los 6 atractivos como pines sobre `flutter_map` con teselas de
  OpenStreetMap, selector de rutas tematicas y sheet arrastrable
  "Explorar lugares" que abre el detalle. Sustituye al placeholder de 17
  lineas. **No necesita API key ni cuenta de Google Cloud**: funciona
  recien clonado el repo (`docs/MAPS_SETUP.md`). Sin red, el area del mapa
  se queda en crema y el sheet sigue funcionando porque lee datos
  locales.
- **El mapa entra en la suite de tests.** `GoogleMap` era una *platform
  view* y no pintaba nada en un test de widget, asi que la pantalla solo
  podia probarse por las piezas de alrededor. `FlutterMap` es Flutter
  puro: hay tests que montan `MapPage`, cuentan los pines y tocan uno.
- Credito visible a OpenStreetMap sobre el mapa, arriba a la derecha
  porque el sheet tapa la esquina de abajo. No es adorno: la licencia
  ODbL de las teselas lo exige, y un test falla si alguien lo borra.
- El selector de rutas lleva una cuarta opcion, "Todas", que el diseño no
  dibuja. Sin ella los dos atractivos de categoria `cultural` —la Plaza e
  Iglesia Matriz y la Feria Dominical— no apareceran en ninguna de las
  tres rutas y quedarian invisibles en el mapa.
- Feature `settings`: idioma (Sistema / Español / English) que sobrevive
  al cierre de la app, y "acerca de" con la version. Sin "contacto": no
  hay una direccion real a la que escribir.
- Detalle de fiesta: cierra el flujo del diferenciador del producto. Hasta
  ahora las tarjetas del calendario y el boton "Ver la fiesta" de Inicio no
  llevaban a ningun sitio. Muestra fecha (o rango), ubicacion cuando la hay
  y una pildora dorada si la fiesta es destacada.
- `core/widgets/detail_layout.dart`: el armazon de las pantallas de detalle
  —portada a sangre, panel crema, cinta del Danzante, fila de datos
  practicos— extraido para que lo compartan atractivos y fiestas en vez de
  duplicarlo. El detalle de atractivo pasa a construirse sobre el.
- Detalle de atractivo: foto a sangre, datos practicos y boton "Como
  llegar", que abre la app de mapas del telefono con la ruta. Es el nodo
  de convergencia de la app y hasta ahora no existia: el horario y el
  costo estaban en el JSON pero ninguna pantalla los mostraba.
- Cada tab tiene su propio `Navigator`: el detalle se abre dentro del tab
  activo, con la barra inferior visible. Volver a tocar el tab activo
  regresa a su raiz.
- Feature `home`: escaparate del calendario. Cuenta regresiva en vivo a la
  proxima fiesta, carrusel "Que visitar" y cabecera con el nombre de la
  app. Cada seccion falla por separado: si el calendario revienta, los
  atractivos siguen en pie.
- Feature `calendar`: el calendario de fiestas, diferenciador del producto.
  Linea de tiempo agrupada por mes, dos jerarquias de tarjeta
  (destacada / normal), busqueda bilingue e insensible a tildes, y estados
  vacios distintos para "no hay fiestas" y "la busqueda no encontro nada".
- Fotos reales de los 6 atractivos en `assets/images/`. Hasta ahora el
  JSON apuntaba a archivos que no existian y la app pintaba un icono de
  marcador: es la primera vez que se ven fotos de verdad.
- Arbol de tests de `calendar` (24 tests en total, antes habia 1), incluido
  uno que valida el asset real que se empaqueta.
- Tests que validan el asset de atractivos: ids unicos, textos bilingues
  completos y que **cada foto referenciada exista en disco**.
- Flavors `dev` / `prod`: entrypoints, `FlavorConfig`, productFlavors de
  Gradle, `Makefile`, `.vscode/launch.json` y documentacion.
- Nombre distinto en el lanzador por flavor (`resValue` + `@string/app_name`):
  "Pujili Vive Dev" y "Pujili Vive" conviven en el mismo dispositivo.
- Cinta "DEV" en pantalla para no confundir la build que se esta probando.
- Firma de release condicional via `android/key.properties` (opcional).
- Targets `doctor`, `version`, `outdated` y `verify-signing` en el Makefile.
- Políticas de repositorio: `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`,
  `SECURITY.md`, `LICENSE` (propietaria) y `project_rules/`.
- CI de GitHub Actions (formato, análisis y tests).
- Plantillas de Pull Request e Issues y `CODEOWNERS`.
- `.editorconfig` y `.gitignore` reforzado.
- `analysis_options.yaml` con set de lints ampliado.

### Changed
- **El mapa dejo Google Maps y pasa a OpenStreetMap** (`flutter_map`). El
  motivo: la pantalla estaba hecha desde el 21 de septiembre y llevaba
  ocho dias en blanco esperando una API key que exigia cuenta de Google
  Cloud, tarjeta y un secreto en el CI. Con teselas de la OSM Foundation
  no hay nada que cargar. Lo que se pierde: el aspecto del mapa ya no se
  puede tematizar desde la app —el estilo lo decide quien sirve las
  teselas—, asi que el terracota del diseño queda mas lejos que antes
  (`CONCEPTO.md` pregunta nº 17).
- **Nuevo requisito para desarrollar en macOS**: aceptar la licencia de
  Xcode (`sudo xcodebuild -license accept`). `flutter_map` arrastra
  `path_provider`, que en Apple se apoya en `objective_c`, y su *build
  hook* llama a `xcrun`. Sin la licencia, `flutter test` falla con
  "Building native assets failed" antes de correr un solo test. El CI no
  se entera: compila en Linux y ese hook se salta.
- Los pines pasan de los tonos del catalogo de Google a los colores de la
  paleta del Danzante: terracota para artesania, dorado para religioso,
  verde para naturaleza y gris oscuro para cultural.
- **Tocar un pin abre el detalle del atractivo**, y ya no una ventana de
  informacion. La decision nº 12 de `CONCEPTO.md` era la `InfoWindow`
  nativa de Google y murio con el proveedor; `flutter_map` no tiene
  equivalente. Lleva a la misma pantalla que las filas del sheet y las
  tarjetas de Explorar, en vez de estrenar una burbuja propia.
- El blanco de la tarjeta **cambia de significado**: antes lo ponia
  `isHighlighted` y era fijo en el JSON; ahora quiere decir "esto esta
  pasando ahora". `isHighlighted` se queda con lo que siempre quiso decir
  —esta fiesta importa mas— y pasa a un marco dorado sin relleno, para
  que no se confundan dos cosas distintas.
- Los eventos pasados se atenuan en vez de quedarse iguales, y siguen en
  la lista: se ve por donde va el programa sin perder lo que hubo
  (`CONCEPTO.md` pregunta resuelta nº 4).
- Inicio ya no llama "proximo evento" a una fiesta que ya termino: filtra
  por hora de fin y no por dia. Mientras una ocurre, la tarjeta dice
  "AHORA" y hasta que hora va, en vez de una cuenta regresiva en ceros.
- El detalle de fiesta muestra la franja horaria ("21 sept 2026 · 10:00 –
  12:30") y una pildora distinta segun este ocurriendo o sea destacada.

- El quinto tab deja de ser Perfil y pasa a ser **Artesanos**. Perfil no
  tenia contenido decidido y sin cuentas de usuario no hay perfil que
  mostrar; Artesanos tenia pantalla diseñada y ningun tab. Deshace de paso
  el parche del scaffold, que ya apuntaba ahi (`CONCEPTO.md` §4.6 y §4.7,
  preguntas resueltas 1 y 8).
- Ajustes se abre desde un engranaje en la cabecera de Inicio, no desde la
  barra. `ShellTab.profile` pasa a `ShellTab.artisans`.
- "Ver la fiesta" de Inicio abre el detalle de ESA fiesta en vez de saltar
  al tab Calendario, donde habia que volver a buscarla a mano
  (`docs/CONCEPTO.md` §4.1). El detalle se abre dentro del tab Inicio, asi
  que el tab no cambia.
- `schedule` y `cost` de `Attraction` pasan a ser opcionales. Si faltan,
  el detalle oculta la columna.
- `ShellCubit`: el tab activo pasa de `setState` a un cubit, porque otras
  pantallas necesitan cambiarlo (Inicio manda al Calendario y a Explorar).

### Removed
- Dependencia `google_maps_flutter` y **toda la fontaneria de la API
  key**: la lectura de `MAPS_API_KEY` en `build.gradle.kts`, su
  `manifestPlaceholder`, el `meta-data com.google.android.geo.API_KEY`
  del manifest, el `GMSServices.provideAPIKey` de `AppDelegate.swift`, el
  `<script>` de `maps.googleapis.com` en `web/index.html` y el paso del
  CI que inyectaba el secreto. El secreto `MAPS_API_KEY` de GitHub ya no
  se usa y se puede borrar.
  `ios/Podfile.lock` **sigue listando el pod de GoogleMaps**: no se pudo
  regenerar (esta maquina no tiene aceptada la licencia de Xcode y
  `pod install` la exige). Se rehace solo en el proximo `make pods` o
  build de iOS.
- `NSLocationWhenInUseUsageDescription` del `Info.plist` de iOS, que
  prometia "usar tu ubicacion para mostrarte los atractivos mas cercanos".
  La app nunca lo hizo. Un proposito de ubicacion declarado va a la
  etiqueta de privacidad de la App Store y lo pregunta la revision.
- Permisos `ACCESS_FINE_LOCATION` y `ACCESS_COARSE_LOCATION` del manifest
  de Android. Eran herencia de `google_maps_flutter` y la app **nunca
  pidio la ubicacion**: no hay boton de "mi ubicacion" (depende de la
  pregunta abierta nº 9). Pedir permisos que no se usan es de lo que
  Play Store pregunta en la revision.
- `dependabot.yml`: las actualizaciones automaticas se gestionan a mano.
  Los bumps que ya habia propuesto quedan aplicados en `main`.

### Fixed
- **El mapa encuadraba pines detras de su propio sheet.** El encuadre
  dejaba 64 px de margen por los cuatro lados, pero el sheet "Explorar
  lugares" cubre el 45 % de abajo: los pines del sur quedaban tapados, sin
  poder verse ni tocarse. Ahora el margen inferior descuenta lo que el
  sheet ocupa. Venia de la version con Google (`newLatLngBounds(bounds,
  64)` tenia el mismo margen uniforme); lo descubrio uno de los tests
  nuevos, que no existia porque con Google la pantalla no se podia probar.
- Los pines señalaban ~6 px por encima de su sitio —unos 115 m con el zoom
  de arranque—: los iconos de Material dejan margen dentro de su caja, asi
  que la punta dibujada no llegaba al borde por el que se ancla el pin.
- Alejar el mapa con dos dedos podia llegar a ver el mundo entero, donde la
  proyeccion repite el planeta a los lados y cada pin se clonaba **con su
  misma Key**, reventando la pantalla en debug con "Duplicate keys found".
  Ahora hay suelo de zoom, que ademas evita pedir teselas de medio planeta
  a un servidor donado.
- El giro con dos dedos queda desactivado. `flutter_map` lo trae activado y
  no hay brujula para deshacerlo, asi que un giro accidental dejaba el mapa
  torcido sin vuelta atras, con los pines inclinados apuntando a otro
  sitio.
- El sheet del mapa envolvia sus filas en un `DecoratedBox` con fondo, que
  tapa el fondo y el ink de los `ListTile`: al tocarlas no se veia nada.
  Pasa a `Material`, que ademas da la sombra.
- `ShellCubit` estaba registrado como singleton pero lo provee un
  `BlocProvider(create:)`, que lo cierra al desmontarse. Pasa a factory.
- CI en rojo desde el primer merge: `dart format` fallaba por dos archivos
  sin formatear (`attraction_model.dart`, `attractions_bloc.dart`).
- `analysis_options.yaml` referenciaba `avoid_returning_null_for_future`,
  lint retirado en Dart 3.3.0, que generaba un warning fatal.
- El paso de análisis del CI usa `--no-fatal-infos`: `flutter analyze` trae
  esa opción activada por defecto, lo que rompía el build con lints de
  nivel `info`, en contra de lo definido en `project_rules/09_code_style.md`.

## [1.0.0] - 2026-08-28

### Added
- MVP bilingüe (ES/EN) con Clean Architecture + BLoC.
- Feature `attractions` completa (domain/data/presentation) como plantilla.
- Shell con navegación inferior unificada (5 tabs).
- Scaffolds de `home`, `calendar`, `map` y `artisans`.
- Datos iniciales de 6 atractivos en `assets/data/attractions.json`.

[Unreleased]: https://github.com/Denniss2C/pujili_vive/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/Denniss2C/pujili_vive/releases/tag/v1.0.0
