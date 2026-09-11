# Configuración de Google Maps

La app usa `google_maps_flutter`. La **API key no se versiona**: cada
plataforma la toma de un sitio local distinto. Sin la key la app compila y
corre con normalidad; solo el mapa queda en blanco.

## 1. Crear y restringir la key (Google Cloud Console)

1. Crea un proyecto en Google Cloud y habilita **Maps SDK for Android**,
   **Maps SDK for iOS** y **Maps JavaScript API** (web).
2. Crea una API key por plataforma (o una con varias *application
   restrictions*).
3. **Restríngela** siempre:
   - **Android:** *Application restriction* → Android apps → agrega el
     package `ec.gob.pujili.pujili_vive` (y `...dev` si usas flavors) con su
     huella **SHA-1** (`./gradlew signingReport` o `keytool`).
   - **iOS:** *Application restriction* → iOS apps → bundle id.
   - **Web:** *Application restriction* → HTTP referrers → tu dominio.
   - **API restriction:** limita cada key a su SDK correspondiente.

## 2. Dónde ponerla (local, sin commitear)

| Plataforma | Ubicación |
| --- | --- |
| Android | `android/local.properties` → `MAPS_API_KEY=tu_clave` (se inyecta como `manifestPlaceholder` desde `build.gradle.kts`). |
| iOS | `ios/Runner/AppDelegate.swift` → reemplazar `TU_GOOGLE_MAPS_API_KEY_IOS`. |
| Web | `web/index.html` → reemplazar `TU_GOOGLE_MAPS_API_KEY_WEB`. |

`local.properties` ya está en `.gitignore`. Para iOS/Web, **no** commitees
el archivo con la clave real.

## 3. En CI (GitHub Actions)

El workflow inyecta la key desde el secret **`MAPS_API_KEY`**:

1. Ve a **Settings → Secrets and variables → Actions → New repository secret**.
2. Nombre `MAPS_API_KEY`, valor: tu clave de Android.

Si el secret no existe, el build de Android se hace igual (el mapa saldrá en
blanco) y el CI no se pone rojo por eso.

## 4. Verificación

```bash
# Android
grep MAPS_API_KEY android/local.properties   # debe existir localmente
flutter run --flavor dev                      # (con flavors) el mapa debe cargar
```
