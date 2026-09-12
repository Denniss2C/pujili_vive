# Pujilí Vive

App móvil de turismo para promocionar el cantón Pujilí, Cotopaxi (Ecuador).
Flutter + BLoC + Clean Architecture. MVP bilingüe (español / inglés).

## Cómo levantar el proyecto

Requiere Flutter 3.44+ (probado en 3.44.7 / Dart 3.12).

```bash
flutter pub get
flutter run
```

Plataformas soportadas: **Android, iOS y web**. El bundle ID / applicationId es
`ec.gob.pujili.pujili_vive`.

Los archivos de localización (`lib/l10n/app_localizations*.dart`) se generan
solos a partir de los `.arb` en cada build, por eso no se versionan.

### Clave de Google Maps

El mapa necesita una API key de Google Maps, que **no** se versiona. Cada
plataforma la toma de un sitio distinto:

| Plataforma | Dónde ponerla |
|---|---|
| Android | `android/local.properties` → `MAPS_API_KEY=tu_clave` (se inyecta como `manifestPlaceholder`) |
| iOS | `ios/Runner/AppDelegate.swift` → reemplazar `TU_GOOGLE_MAPS_API_KEY_IOS` |
| Web | `web/index.html` → reemplazar `TU_GOOGLE_MAPS_API_KEY_WEB` |

Sin la clave la app compila y corre con normalidad; solo el mapa quedaría en
blanco.

### Comandos útiles

```bash
flutter analyze          # análisis estático (analysis_options.yaml)
flutter test             # tests
flutter build apk        # Android
flutter build ios        # iOS
flutter build web        # web
```

## Estructura

```
lib/
  core/            # theme (paleta Danzante), errores, usecase base, DI, i18n helper
  l10n/            # app_es.arb / app_en.arb  (textos bilingües)
  features/
    attractions/   # feature COMPLETA de referencia (domain/data/presentation + BLoC)
    home/          # scaffold
    calendar/      # scaffold  <- diferenciador clave, priorizar
    map/           # scaffold  <- Google Maps embebido con rutas
    artisans/      # scaffold
  shell/           # MainShell: barra de navegación inferior UNIFICADA (5 tabs)
assets/
  data/attractions.json   # 6 atractivos acordados, bilingüe
  images/                 # colocar aquí las fotos reales
```

## Notas de diseño respecto a los mockups de Stitch

- Barra de navegación **unificada** en `shell/main_shell.dart` (los mockups la
  tenían distinta en cada pantalla). 5 tabs: Inicio, Explorar, Calendario,
  Mapa, Perfil.
- Todos los textos salen de los `.arb` — nada hardcodeado — para soportar
  español e inglés desde el MVP.
- Los atractivos del JSON son los 6 acordados (Isinche, Plaza/Iglesia Matriz,
  Cruz del Calvario, cerámica de La Victoria, feria dominical, Quilotoa), no
  los nombres inventados que aparecían en los mockups.

## Pendientes (TODO en el código)

- Pantallas `home`, `calendar`, `map`, `artisans` están como scaffold.
  La feature `attractions` sirve de plantilla para replicar el patrón.
- Falta contenido real: fotos de Pujilí y datos prácticos verificados.
- El tab "Perfil" apunta temporalmente a `ArtisansPage`; crear su feature.
- Para el mapa: falta la API key de Google Maps (ver arriba) y reemplazar el
  placeholder de `map_page.dart` por el widget `GoogleMap` con los pines.

## Contribuir y políticas del repositorio

Antes de tu primera contribución, lee:

- [`CONTRIBUTING.md`](./CONTRIBUTING.md) — flujo de trabajo, convención de
  ramas y de commits (Conventional Commits).
- [`project_rules/`](./project_rules/) — reglas de arquitectura, BLoC,
  testing, naming, estilo, seguridad y **Definition of Done**.
- [`SECURITY.md`](./SECURITY.md) — manejo de claves y reporte de
  vulnerabilidades.
- [`CODE_OF_CONDUCT.md`](./CODE_OF_CONDUCT.md).

Todo cambio entra por **Pull Request** contra `main` (rama protegida), con
CI en verde y al menos una aprobación. El historial de cambios está en
[`CHANGELOG.md`](./CHANGELOG.md).

> **Licencia:** software propietario. Todos los derechos reservados. Ver
> [`LICENSE`](./LICENSE).

## Ambientes (flavors) y comandos

Este proyecto usa flavors **dev/prod**, así que `flutter run` a secas ya no
aplica: usa el flavor y su entrypoint (o el Makefile / `.vscode/launch.json`).

```bash
make run-dev          # flutter run --flavor dev  -t lib/core/flavors/main_dev.dart
make run-prod         # flutter run --flavor prod -t lib/core/flavors/main_prod.dart
make check            # formato + análisis + tests (igual que el CI)
make aab-prod         # App Bundle de producción
make help             # todos los atajos
```

Documentación: [`docs/FLAVORS.md`](./docs/FLAVORS.md),
[`docs/IOS_FLAVORS.md`](./docs/IOS_FLAVORS.md),
[`docs/RELEASE_ANDROID.md`](./docs/RELEASE_ANDROID.md),
[`docs/MAPS_SETUP.md`](./docs/MAPS_SETUP.md).
