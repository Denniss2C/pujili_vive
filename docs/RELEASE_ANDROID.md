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

Eso es **todo lo que hay que hacer**: la firma ya está enganchada en
`android/app/build.gradle.kts` y es **condicional**.

- **Con** `key.properties` → el release se firma con tu keystore.
- **Sin** `key.properties` → cae a la clave de debug, para que quien no
  tenga el keystore pueda compilar release igualmente y el build no se
  rompa para nadie.

> ⚠️ Esa comodidad tiene un filo: **un AAB firmado con debug lo rechaza
> Play Store, y el build no avisa.** Verifica siempre antes de subir:
>
> ```bash
> make verify-signing
> ```
>
> Debe aparecer tu `Owner`, **no** `CN=Android Debug`.

> ⚠️ Perder el `.jks` o su contraseña **impide publicar actualizaciones
> para siempre**. Guarda copia en dos sitios y la contraseña en un
> gestor.

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
