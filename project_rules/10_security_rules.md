# 10 — Reglas de Seguridad

> Toda decisión de seguridad es **bloqueante** para producción.
> Ver también [`SECURITY.md`](../SECURITY.md) en la raíz.

---

## 1. Secretos y credenciales

### Prohibido
- ❌ Hardcodear la Google Maps API key, tokens o contraseñas.
- ❌ Commitear `local.properties`, `key.properties`, `*.jks`, `.env`.
- ❌ Dejar la key real en `AppDelegate.swift` o `web/index.html` al hacer commit.

### Obligatorio
- ✅ Maps API key en `android/local.properties` (local) y desde el secret
  `MAPS_API_KEY` en CI.
- ✅ Restringir la key por plataforma y por API en Google Cloud Console.
- ✅ La app compila y corre **sin** la key (mapa en blanco).

### `.gitignore` mínimo relevante
```gitignore
.env
.env.*
!.env.example
**/local.properties
**/key.properties
/android/app/*.jks
**/keystore.properties
```

---

## 2. Permisos de la app

- Pedir ubicación **en tiempo de uso**, no al abrir.
- Declarar solo los permisos que se usan.

---

## 3. Transporte y datos

- HTTPS obligatorio; nada de `http://` en código.
- No PII en logs ni en `SharedPreferences` sin cifrar.
- El contenido (atractivos, fiestas, artesanos) es público y sin datos
  personales.

---

## 4. Checklist

- [ ] No hay credenciales/keys en el diff.
- [ ] `local.properties`/`key.properties`/`.env` gitignored.
- [ ] Maps key restringida en Cloud Console.
- [ ] Permisos nuevos justificados.
- [ ] HTTPS en cualquier red.
