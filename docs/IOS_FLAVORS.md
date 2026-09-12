# Flavors en iOS

En Android los flavors se declaran en `build.gradle.kts`. iOS **no tiene
flavors**: se replican con **build configurations + schemes** dentro del
`.xcodeproj`.

> **Ya está hecho y versionado.** No hay que repetir nada en Xcode. Este
> documento explica cómo está montado y cómo verificarlo.

## Cómo ejecutar

```bash
flutter run --flavor dev  -t lib/core/flavors/main_dev.dart
flutter run --flavor prod -t lib/core/flavors/main_prod.dart
# o, más corto:
make run-dev
make run-prod
```

> Con flavors activos, **`--flavor` es obligatorio**. Sin él Flutter falla
> con `You must specify a --flavor option to select one of the available
> schemes.`

## Cómo está montado

### Las 9 build configurations

A las 3 originales (que **no se borran**) se les suman 6:

| Configuración | Bundle id | Nombre visible |
| --- | --- | --- |
| `Debug-dev`, `Release-dev`, `Profile-dev` | `ec.gob.pujili.pujiliVive.dev` | `Pujili Vive Dev` |
| `Debug-prod`, `Release-prod`, `Profile-prod` | `ec.gob.pujili.pujiliVive` | `Pujili Vive` |
| `Debug`, `Release`, `Profile` (originales) | `ec.gob.pujili.pujiliVive` | `Pujili Vive` |

**El nombre importa literalmente.** Flutter busca `<Modo>-<flavor>`: con
`--flavor dev` espera `Debug-dev`, `Release-dev` y `Profile-dev`.

### Los 2 schemes (marcados como *Shared*, por eso se versionan)

| Scheme | Run / Test / Analyze | Profile | Archive |
| --- | --- | --- | --- |
| `dev` | `Debug-dev` | `Profile-dev` | `Release-dev` |
| `prod` | `Debug-prod` | `Profile-prod` | `Release-prod` |

**El nombre del scheme debe coincidir exactamente con el valor de
`--flavor`.** Si no estuviera marcado como *Shared*, no se versionaría y
el resto del equipo no lo tendría.

### El nombre visible: `APP_DISPLAY_NAME`

No se usa `PRODUCT_NAME`, porque también bautiza el binario y el `.app`, y
un nombre con espacios confunde a las herramientas de Flutter. En su lugar
hay un *User-Defined Setting* `APP_DISPLAY_NAME` con un valor por
configuración, y `ios/Runner/Info.plist` lo referencia:

```xml
<key>CFBundleDisplayName</key>
<string>$(APP_DISPLAY_NAME)</string>
```

### El `Podfile` declara las 9 configuraciones

```ruby
project 'Runner', {
  'Debug' => :debug, 'Profile' => :release, 'Release' => :release,
  'Debug-dev' => :debug, 'Profile-dev' => :release, 'Release-dev' => :release,
  'Debug-prod' => :debug, 'Profile-prod' => :release, 'Release-prod' => :release,
}
```

Sin esto, CocoaPods no sabe cuáles son debug y cuáles release, y genera
los `xcconfig` de los Pods con los ajustes equivocados.

> Tras tocar configuraciones hay que **regenerar los pods**
> (`cd ios && pod install`), o el build falla con errores de framework no
> encontrado.

## Verificación

```bash
flutter build ios --simulator --flavor dev  -t lib/core/flavors/main_dev.dart  --debug
plutil -extract CFBundleDisplayName raw build/ios/iphonesimulator/Runner.app/Info.plist
plutil -extract CFBundleIdentifier  raw build/ios/iphonesimulator/Runner.app/Info.plist
```

Comprobado: `dev` → `Pujili Vive Dev` / `...pujiliVive.dev`, y `prod` →
`Pujili Vive` / `...pujiliVive`. Las dos apps conviven en el simulador.

## Firma

`flutter build ios --simulator` no firma nada, así que sirve para
comprobar que compila sin cuenta de Apple. Para dispositivo físico o para
archivar hace falta un `DEVELOPMENT_TEAM` válido en las 9 configuraciones.

## Referencia

Guía oficial: https://docs.flutter.dev/deployment/flavors
