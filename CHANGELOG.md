# Changelog

Todos los cambios notables de este proyecto se documentan en este archivo.

El formato sigue [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/)
y el proyecto se adhiere a [Semantic Versioning](https://semver.org/lang/es/).

## [Unreleased]

### Added
- Mapa: los 6 atractivos como pines sobre `GoogleMap`, selector de rutas
  tematicas y sheet arrastrable "Explorar lugares" que abre el detalle.
  Sustituye al placeholder de 17 lineas. **Necesita una Google Maps API
  key** (`docs/MAPS_SETUP.md`): sin ella el area del mapa sale en blanco,
  pero el sheet sigue funcionando porque lee datos locales.
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
- `dependabot.yml`: las actualizaciones automaticas se gestionan a mano.
  Los bumps que ya habia propuesto quedan aplicados en `main`.

### Fixed
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
