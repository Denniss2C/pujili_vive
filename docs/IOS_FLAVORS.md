# Flavors en iOS (pasos en Xcode)

En Android los flavors se configuran por código (`build.gradle.kts`). En
iOS hay que crearlos en **Xcode**, porque implica configuraciones y
esquemas dentro del `.xcodeproj` (editarlo a mano es riesgoso).

> Haz esto una sola vez. Después, `flutter run --flavor dev -t lib/core/flavors/main_dev.dart`
> usará el esquema `dev`.

## 1. Abrir el proyecto

```bash
open ios/Runner.xcworkspace
```

## 2. Duplicar configuraciones

En **Runner (proyecto) → Info → Configurations**, duplica cada
configuración para cada flavor:

- `Debug`   → `Debug-dev`, `Debug-prod`
- `Release` → `Release-dev`, `Release-prod`
- `Profile` → `Profile-dev`, `Profile-prod`

## 3. Bundle id por flavor

En **Runner (target) → Build Settings → Packaging → Product Bundle
Identifier**, ajusta por configuración:

- `*-dev`  → `ec.gob.pujili.pujiliVive.dev`
- `*-prod` → `ec.gob.pujili.pujiliVive`

(Opcional: **Product Name** distinto para ver "Pujilí Vive Dev".)

## 4. Crear los esquemas

**Product → Scheme → Manage Schemes… → +**. Crea `dev` y `prod` (marca
*Shared*). En cada uno, **Edit Scheme…** y asigna la configuración
correcta a Run/Test/Profile/Archive (p. ej. `dev` → `Debug-dev` /
`Release-dev`).

## 5. Probar

```bash
flutter run   --flavor dev  -t lib/core/flavors/main_dev.dart
flutter build ios --flavor prod -t lib/core/flavors/main_prod.dart --no-codesign
```

Flutter mapea `--flavor dev` al esquema `dev`. Si el nombre del esquema no
coincide con el flavor, el build falla indicándolo.

## Referencia

Guía oficial: https://docs.flutter.dev/deployment/flavors
