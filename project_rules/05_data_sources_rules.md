# 05 — Datos Locales (JSON / assets) y Google Maps

> Pujilí Vive **no usa backend ni Firebase** en el MVP. El contenido
> (atractivos, fiestas, artesanos) vive como **assets locales** y el mapa
> se dibuja con **Google Maps**. Estas son las reglas para ambos.

---

## 1. Datos como assets

- Los datos versionados viven en `assets/data/*.json` y se declaran en
  `pubspec.yaml` bajo `flutter: assets:`.
- El JSON es **bilingüe**: cada texto visible trae `es` y `en`, o se
  resuelve con el helper `core/constants/localized_text.dart`.
- El esquema del JSON se refleja 1:1 en un `Model` con `fromJson`.
  Un cambio de esquema obliga a actualizar el `Model` y sus tests.

```json
{
  "id": "isinche",
  "name": { "es": "Santuario de Isinche", "en": "Isinche Sanctuary" },
  "lat": -0.9613,
  "lng": -78.7010
}
```

Reglas:
- ❌ No leer assets fuera de un `DataSource`.
- ❌ No parsear JSON dentro de un widget o BLoC.
- ✅ Validar tipos al parsear (`as num`, `as String`) y lanzar
  `CacheException`/`FormatException` ante datos corruptos.

---

## 2. Google Maps

- La API key **no** se versiona (ver [`10_security_rules.md`](./10_security_rules.md)).
- El widget `GoogleMap` vive en la capa **presentation** de la feature
  `map`; los pines salen de entidades de dominio (atractivos), no de un
  JSON leído en el widget.
- Restringir la key en Google Cloud Console:
  - Android: SHA-1 + package name (`ec.gob.pujili.pujili_vive`).
  - iOS: bundle id.
  - Web: HTTP referrers.
  - API restrictions: solo **Maps SDK**.
- La app debe compilar y funcionar **sin** la key (mapa en blanco), para
  no bloquear el CI ni el desarrollo local.

---

## 3. Migración a backend (futuro)

Si algún día hay API remota, el cambio debe ser **transparente para el
dominio**: se agrega un `*_remote_datasource.dart` y el repositorio
decide origen (remoto con caché local de respaldo). El contrato del
`Repository` en `domain/` no cambia.

---

## 4. Checklist

- [ ] Los datos nuevos van a `assets/data/` y están declarados en `pubspec.yaml`.
- [ ] Hay un `Model.fromJson` que refleja el esquema, con test.
- [ ] Ningún widget/BLoC lee o parsea assets directamente.
- [ ] La Maps API key no está en el diff.
- [ ] La app corre sin la Maps API key.
