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
| Material de firma Android | `android/key.properties`, `*.jks` | Firma de release. |

**El mapa no necesita ninguna credencial.** Usa `flutter_map` sobre teselas
de OpenStreetMap: no hay API key, ni cuenta de Google Cloud, ni secreto en
el CI (ver [`docs/MAPS_SETUP.md`](./docs/MAPS_SETUP.md)). Hasta el
2026-09-29 el mapa era Google Maps y esta tabla listaba tres claves; ya no
existe ninguna de las tres.

Reglas:

- ❌ Prohibido hardcodear claves, tokens o contraseñas en el código.
- ❌ Prohibido commitear `local.properties`, `key.properties`, `*.jks`, `.env`.
- ✅ Si algún día el mapa cambia a un proveedor de teselas con key, la
  clave va en `android/local.properties` y en un **GitHub Secret** para el
  CI, nunca en el repo.

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
