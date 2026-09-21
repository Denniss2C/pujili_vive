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
    attractions/  FEATURE DE REFERENCIA — completa (data/domain/presentation + BLoC),
                  lista y detalle con "Cómo llegar"
    calendar/     completa (diferenciador clave), lista viva y detalle
    home/         completa (solo presentation: consume calendar y attractions)
    map/          completa (solo presentation: consume attractions)
    settings/     completa (idioma persistido + acerca de)
    artisans/     scaffold
  core/flavors/ FlavorConfig + entrypoints main_dev / main_prod
  core/widgets/ armazon comun de las pantallas de detalle
  shell/        MainShell — navegación inferior unificada (5 tabs),
                un Navigator por tab, y ShellCubit para el tab activo
  l10n/         app_es.arb / app_en.arb (+ generados, gitignored)
assets/
  data/attractions.json      6 atractivos acordados, bilingüe
  data/festival_events.json  programa SIMULADO de 15 días, bilingüe
  images/                    fotos reales de Pujilí
```

## 4. Estado actual

| Área | Estado |
| --- | --- |
| `attractions` | ✅ Completa (domain/data/presentation + BLoC). Plantilla de referencia. |
| `calendar` | ✅ Completa, con el árbol de tests entero y el detalle de fiesta. La lista reacciona al reloj: blanca mientras la fiesta ocurre, atenuada cuando termina. |
| `home` | ✅ Completa. Solo `presentation`: no tiene domain ni data propios porque no tiene datos propios, compone los de `calendar` y `attractions`. |
| `map` | ✅ Completa. Solo `presentation`: consume el `AttractionsBloc` de la raíz, con su propio filtro de ruta para no arrastrar el de Explorar. |
| `settings` | ✅ Completa (domain/data/presentation). Idioma persistido con `shared_preferences`. |
| `artisans` | 🟡 Scaffold: una página de 17 líneas, sin domain ni data. Bloqueada por contenido (pregunta abierta nº 18). |
| Contenido del calendario | 🟡 **Simulado**: 30 fiestas inventadas del 21 sep al 5 oct de 2026, para poder ver el estado en vivo. Las reales son Corpus (junio) y cantonales (octubre). |
| Contenido real | 🟡 Fotos de atractivos ✅. Faltan datos prácticos verificados, las coordenadas de dos atractivos y todo el contenido de artesanos. |
| Google Maps | 🟡 La pantalla está hecha; **falta la API key**. Sin ella el área del mapa sale en blanco, pero el build no se rompe y el sheet con la lista sigue funcionando. |
| Quinto tab | ✅ Es Artesanos. Ajustes salió de la barra y se abre desde el engranaje de Inicio (preguntas resueltas nº 8 y nº 1). |
| Flavors y firma | ✅ `dev` / `prod` en Android e iOS, con `make aab-prod`. Falta generar el keystore real. |
| Tests | 🟡 120 tests. `calendar`, `home` y el shell cubiertos; a `attractions` le faltan usecase, repositorio y bloc. |

## 5. Decisiones de diseño

- Navegación inferior **unificada** en `shell/main_shell.dart` (5 tabs:
  Inicio, Explorar, Calendario, Mapa, Artesanos).
- Todo texto visible sale de los `.arb` (nada hardcodeado) para soportar
  ES/EN desde el MVP.
- Los atractivos del JSON son los 6 acordados (Isinche, Plaza/Iglesia
  Matriz, Cruz del Calvario, cerámica de La Victoria, feria dominical,
  Quilotoa).

## 6. Referencias

- Reglas de código y arquitectura: [`project_rules/`](../project_rules/)
- Configuración de Google Maps: [`MAPS_SETUP.md`](./MAPS_SETUP.md)
- Publicación Android: [`RELEASE_ANDROID.md`](./RELEASE_ANDROID.md)
- Qué sigue y qué bloquea cada fase: [`ROADMAP.md`](./ROADMAP.md)
- El producto, con sus 20 preguntas abiertas: [`CONCEPTO.md`](./CONCEPTO.md)
- Ambientes dev/prod: [`FLAVORS.md`](./FLAVORS.md)
