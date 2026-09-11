# 09 — Estilo de Código y Linters

> La calidad de código no se negocia. Las reglas se aplican en el IDE y
> en CI.

---

## 1. Dart Format

```bash
dart format lib test
```

- 100 % de cobertura de formato. CI falla si hay diff
  (`dart format --set-exit-if-changed lib test`).
- Longitud máxima de línea: **80 caracteres**.

---

## 2. Lints (`analysis_options.yaml`)

El proyecto parte de `flutter_lints` y añade el set de
`analysis_options.yaml`. Hoy la mayoría son de severidad **info**: se ven
en el IDE y en CI pero **no rompen el build todavía**.

> **Objetivo (endurecimiento por grupos):**
> 1. Subir a `--fatal-warnings` (ya activo vía `flutter analyze`).
> 2. Cuando el código esté limpio, pasar el análisis a
>    `flutter analyze --fatal-infos --fatal-warnings` en el CI.
> 3. Activar los modos estrictos del analizador:
>    ```yaml
>    analyzer:
>      language:
>        strict-casts: true
>        strict-inference: true
>        strict-raw-types: true
>    ```
> Se hace por grupos para no generar un PR irrevisable de golpe.

---

## 3. Reglas de formato específicas

### 3.1 Imports
- Orden: `dart:`, `package:`, relativo. Separados por línea en blanco.
- Preferir imports de paquete (`package:pujili_vive/...`) sobre relativos
  de muchos niveles.

### 3.2 Strings
- Comillas simples (`prefer_single_quotes`).
- Interpolación en lugar de concatenación.

### 3.3 Async
- `async`/`await` sobre `.then` encadenado.
- `unawaited(future)` para futures ignorados a propósito.
- Streams: `cancel` en `dispose`.

### 3.4 Null safety
- Tipos no-null por defecto; `?` solo si es necesario.
- `late` solo para inicialización tardía real.

### 3.5 Logging
- ❌ `print(...)` prohibido (`avoid_print`).
- ✅ `dart:developer` `log()` o un `Logger`.

---

## 4. Reglas de widgets

- `const` siempre que se pueda.
- `key` en constructores públicos (`use_key_in_widget_constructors`).
- Colores desde `AppColors`, no hex literales.
- Widgets que superan **200 líneas** → extraer sub-widgets.

---

## 5. Documentación

- Doc comments `///` en clases y métodos públicos no triviales.

---

## 6. Errores prohibidos (resumen)

- ❌ `print`/`debugPrint` en producción.
- ❌ `// ignore: <lint>` sin justificar en la PR.
- ❌ `TODO` sin ticket.
- ❌ Código comentado.
- ❌ Magic numbers/strings (usar constantes).
- ❌ `catch (e) {}` vacío.

---

## 7. Checklist

- [ ] `dart format` sin diffs.
- [ ] `flutter analyze` sin errores ni warnings.
- [ ] Sin `print`, sin código comentado, sin TODOs huérfanos.
- [ ] `const` donde aplique.
