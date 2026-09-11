# Arquitectura — Pujilí Vive

> Este documento describe **cómo está construido y qué existe hoy**. Las
> reglas de *cómo escribir el código* viven en [`project_rules/`](../project_rules/).

## 1. Resumen

App móvil de turismo para el cantón Pujilí (Cotopaxi). Flutter, bilingüe
(ES/EN), con **Clean Architecture + BLoC** y **Feature-First**. Sin backend
en el MVP: el contenido viaja como **assets locales** (`assets/data/`) y el
mapa usa **Google Maps**.

- Bundle id / applicationId: `ec.gob.pujili.pujili_vive`
- Plataformas: Android, iOS y Web
- SDK: Dart `^3.5.0`, probado en Flutter 3.44.7

## 2. Capas (por feature)

```
presentation (UI + BLoC)  ──▶  domain (entidades, usecases, repos abstract)  ◀──  data (models, datasources, repos impl)
```

`domain` no depende de nadie. `data` implementa los contratos de `domain`.
`presentation` solo conoce `domain`. Detalle en
[`project_rules/02_clean_architecture_rules.md`](../project_rules/02_clean_architecture_rules.md).

## 3. Estructura

```
lib/
  core/         theme (paleta Danzante), error, usecases (contrato base), di (get_it), constants
  features/
    attractions/  FEATURE DE REFERENCIA — completa (data/domain/presentation + BLoC)
    home/         scaffold
    calendar/     scaffold  (diferenciador clave)
    map/          scaffold  (Google Maps)
    artisans/     scaffold
  shell/        MainShell — navegación inferior unificada (5 tabs)
  l10n/         app_es.arb / app_en.arb (+ generados, gitignored)
assets/
  data/attractions.json   6 atractivos acordados, bilingüe
  images/                 fotos reales de Pujilí
```

## 4. Estado actual

| Área | Estado |
| --- | --- |
| `attractions` | ✅ Completa (domain/data/presentation + BLoC). Plantilla de referencia. |
| `home`, `calendar`, `map`, `artisans` | 🟡 Scaffold. Migrar al patrón de `attractions` al ganar lógica. |
| Contenido real | 🟡 Faltan fotos y datos prácticos verificados. |
| Google Maps | 🟡 Falta cargar la API key y reemplazar el placeholder de `map_page.dart` por el widget `GoogleMap` con pines. |
| Tab "Perfil" | 🟡 Apunta temporalmente a `ArtisansPage`; crear su feature. |
| Tests | 🟡 Solo `widget_test.dart`. Empezar por el árbol de tests de `attractions`. |

## 5. Decisiones de diseño

- Navegación inferior **unificada** en `shell/main_shell.dart` (5 tabs:
  Inicio, Explorar, Calendario, Mapa, Perfil).
- Todo texto visible sale de los `.arb` (nada hardcodeado) para soportar
  ES/EN desde el MVP.
- Los atractivos del JSON son los 6 acordados (Isinche, Plaza/Iglesia
  Matriz, Cruz del Calvario, cerámica de La Victoria, feria dominical,
  Quilotoa).

## 6. Referencias

- Reglas de código y arquitectura: [`project_rules/`](../project_rules/)
- Configuración de Google Maps: [`MAPS_SETUP.md`](./MAPS_SETUP.md)
- Publicación Android: [`RELEASE_ANDROID.md`](./RELEASE_ANDROID.md)
- Ambientes dev/prod: [`FLAVORS.md`](./FLAVORS.md)
