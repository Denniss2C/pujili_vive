# Publicación Android

## 1. Firma de release

La firma **no se versiona**. Crea un keystore y un `key.properties` local
(ambos gitignored).

```bash
keytool -genkey -v -keystore ~/pujili-upload.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Crea `android/key.properties` (NO commitear):

```properties
storeFile=/ruta/absoluta/pujili-upload.jks
storePassword=********
keyAlias=upload
keyPassword=********
```

Y engancha la firma en `android/app/build.gradle.kts` (reemplazando el
`signingConfig` de debug que hay hoy en `buildTypes.release`). Patrón:

```kotlin
import java.io.FileInputStream
import java.util.Properties

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    FileInputStream(keystorePropertiesFile).use { keystoreProperties.load(it) }
}

android {
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = (keystoreProperties["storeFile"] as String?)?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}
```

## 2. Maps API key

Asegúrate de tener `MAPS_API_KEY` en `android/local.properties`
(ver [`MAPS_SETUP.md`](./MAPS_SETUP.md)).

## 3. Build (flavor prod)

```bash
# App Bundle para Play Store (recomendado)
flutter build appbundle --flavor prod -t lib/main_prod.dart --release
# o con Makefile
make aab-prod

# APK (pruebas/distribución directa)
flutter build apk --flavor prod -t lib/main_prod.dart --release
```

Salida:
- AAB: `build/app/outputs/bundle/prodRelease/app-prod-release.aab`
- APK: `build/app/outputs/flutter-apk/app-prod-release.apk`

## 4. Recomendaciones

- Ofusca el binario:
  `--obfuscate --split-debug-info=build/symbols`.
- Sube el AAB a **Play Console** (canal interno primero).
- El `applicationId` de producción es `ec.gob.pujili.pujili_vive`.
