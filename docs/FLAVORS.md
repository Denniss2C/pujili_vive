# Ambientes (Flavors) — dev / prod

La app tiene dos ambientes: **dev** y **prod**. Sirven para instalar la
versión de pruebas junto a la de producción (el `applicationId` de dev
lleva sufijo `.dev`) y para separar configuración por ambiente en el futuro.

> ⚠️ **Importante:** al activar flavors, `flutter run` **a secas ya no
> funciona**. Siempre hay que indicar el flavor y su entrypoint.

## Cómo correr

```bash
# dev
flutter run --flavor dev  -t lib/core/flavors/main_dev.dart
# prod
flutter run --flavor prod -t lib/core/flavors/main_prod.dart

# o con el Makefile
make run-dev
make run-prod
```

En **VSCode** usa las configuraciones ya incluidas en
`.vscode/launch.json` ("Pujilí Vive (dev)" / "(prod)") desde el botón *Run*.

## Cómo funciona

- `lib/core/flavors/flavor_config.dart` — enum `Flavor` y `FlavorConfig`
  (singleton). Consulta el ambiente con `FlavorConfig.isDev` / `.isProd`.
- `lib/core/flavors/main_dev.dart` / `lib/core/flavors/main_prod.dart` — fijan el flavor y delegan en
  `main.dart` (que queda intacto). Por eso `flutter test`, que usa
  `main.dart` / `PujiliViveApp`, sigue funcionando sin flavor (cae a prod).
- **Android:** `android/app/build.gradle.kts` define `productFlavors`
  (`dev` con `applicationIdSuffix = ".dev"`, `prod` sin sufijo).

## applicationId resultante

| Flavor | applicationId | versionName |
| --- | --- | --- |
| dev  | `ec.gob.pujili.pujili_vive.dev` | `x.y.z-dev` |
| prod | `ec.gob.pujili.pujili_vive`     | `x.y.z`     |

## iOS

Los flavors de iOS se configuran en **Xcode** (esquemas + configuraciones).
Ver [`IOS_FLAVORS.md`](./IOS_FLAVORS.md). Mientras no estén creados, en iOS
corre sin `--flavor`.

## Opcional: mostrar "Dev" en la app

`FlavorConfig.instance.appTitle` ya devuelve "Pujilí Vive (Dev)" en dev. Si
quieres que el título de `MaterialApp` o un banner lo reflejen, cambia en
`lib/main.dart`:

```dart
title: FlavorConfig.instance.appTitle,
```

(No se hizo automáticamente para no tocar `main.dart`.)
