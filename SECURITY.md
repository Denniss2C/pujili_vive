# Política de Seguridad — Pujilí Vive

## Reportar una vulnerabilidad

**No abras un issue público** para reportar vulnerabilidades. Escribe de
forma privada a **denniscaisa@gmail.com** con:

- Descripción del problema y su impacto.
- Pasos para reproducirlo.
- Versión / rama afectada.

Recibirás una confirmación en un plazo razonable y te mantendremos al
tanto de la corrección. Agradecemos la divulgación responsable.

---

## 1. Secretos y credenciales

Este proyecto **no versiona** ninguna credencial. En particular:

| Secreto | Dónde va | Por qué no al repo |
| --- | --- | --- |
| Google Maps API key (Android) | `android/local.properties` → `MAPS_API_KEY=` | Se inyecta como `manifestPlaceholder` en build. |
| Google Maps API key (iOS) | `ios/Runner/AppDelegate.swift` (local) | No debe commitearse con la clave real. |
| Google Maps API key (Web) | `web/index.html` (local) | Ídem. |
| Material de firma Android | `android/key.properties`, `*.jks` | Firma de release. |

Reglas:

- ❌ Prohibido hardcodear claves, tokens o contraseñas en el código.
- ❌ Prohibido commitear `local.properties`, `key.properties`, `*.jks`, `.env`.
- ✅ En CI, la Maps API key se restaura desde un **GitHub Secret**
  (`MAPS_API_KEY`), no desde el repo.
- ✅ Restringe la Maps API key por *application restrictions*
  (SHA-1 + package name en Android; bundle id en iOS; HTTP referrer en Web)
  y por *API restrictions* (solo Maps SDK) en Google Cloud Console.

> La app compila y corre sin la clave; solo el mapa queda en blanco.
> Eso permite que el CI (análisis y tests) no necesite la clave real.

---

## 2. Permisos de la app

- Pedir permisos sensibles (ubicación) **en tiempo de uso**, no al abrir.
- Declarar solo los permisos que se usan.
- No registrar PII ni ubicación del usuario sin consentimiento.

---

## 3. Transporte y datos

- HTTPS obligatorio para cualquier red. Nada de `http://` en código.
- No guardar datos sensibles en `SharedPreferences` sin cifrar; usar
  `flutter_secure_storage` si se necesita.
- Los datos de contenido (atractivos, fiestas, artesanos) son públicos y
  viajan como assets locales (`assets/data/`), sin datos personales.

---

## 4. Checklist de seguridad para cada PR

- [ ] No hay credenciales ni claves en el diff.
- [ ] `local.properties` / `key.properties` / `.env` siguen gitignored.
- [ ] Permisos nuevos justificados y documentados.
- [ ] Endpoints en HTTPS.
- [ ] Sin PII en logs.
