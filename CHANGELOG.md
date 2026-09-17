# Changelog

Todos los cambios notables de este proyecto se documentan en este archivo.

El formato sigue [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/)
y el proyecto se adhiere a [Semantic Versioning](https://semver.org/lang/es/).

## [Unreleased]

### Added
- Feature `calendar`: el calendario de fiestas, diferenciador del producto.
  Linea de tiempo agrupada por mes, dos jerarquias de tarjeta
  (destacada / normal), busqueda bilingue e insensible a tildes, y estados
  vacios distintos para "no hay fiestas" y "la busqueda no encontro nada".
- Arbol de tests de `calendar` (24 tests en total, antes habia 1), incluido
  uno que valida el asset real que se empaqueta.
- Flavors `dev` / `prod`: entrypoints, `FlavorConfig`, productFlavors de
  Gradle, `Makefile`, `.vscode/launch.json` y documentacion.
- Nombre distinto en el lanzador por flavor (`resValue` + `@string/app_name`):
  "Pujili Vive Dev" y "Pujili Vive" conviven en el mismo dispositivo.
- Cinta "DEV" en pantalla para no confundir la build que se esta probando.
- Firma de release condicional via `android/key.properties` (opcional).
- Targets `doctor`, `version`, `outdated` y `verify-signing` en el Makefile.


### Added
- Políticas de repositorio: `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`,
  `SECURITY.md`, `LICENSE` (propietaria) y `project_rules/`.
- CI de GitHub Actions (formato, análisis y tests).
- Plantillas de Pull Request e Issues y `CODEOWNERS`.
- `.editorconfig` y `.gitignore` reforzado.
- `analysis_options.yaml` con set de lints ampliado.

### Removed
- `dependabot.yml`: las actualizaciones automaticas se gestionan a mano.
  Los bumps que ya habia propuesto quedan aplicados en `main`.

### Fixed
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
