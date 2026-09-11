# 01 — Arquitectura General

> **Principio rector:** *Pujilí Vive sigue Clean Architecture con
> Feature-First y BLoC.*

---

## 1. Visión general

El proyecto se construye sobre tres capas lógicas, dentro de cada
**feature**:

```
┌─────────────────────────────────────────────────┐
│  Presentation (UI + BLoC)                       │
│  - Widgets, Pages, BLoC/Cubit, States, Events   │
└──────────────────────▲──────────────────────────┘
                       │ depende de
┌──────────────────────┴──────────────────────────┐
│  Domain (Núcleo puro)                           │
│  - Entities, UseCases, Repositories (abstract)  │
└──────────────────────▲──────────────────────────┘
                       │ depende de
┌──────────────────────┴──────────────────────────┐
│  Data (Implementación)                          │
│  - Models (DTO), DataSources, Repositories impl │
└─────────────────────────────────────────────────┘
```

**Regla de dependencia:** las capas internas **nunca** conocen a las
externas. `domain` no importa nada de Flutter ni de paquetes externos.

---

## 2. Feature-First

Cada feature vive en `lib/features/<feature_name>/` con sus tres capas.
Ejemplo real del proyecto:

```
features/attractions/
├── data/
│   ├── datasources/   ← attractions_local_datasource.dart (lee el JSON)
│   ├── models/        ← attraction_model.dart
│   └── repositories/  ← attractions_repository_impl.dart
├── domain/
│   ├── entities/      ← attraction.dart, attraction_category.dart
│   ├── repositories/  ← attractions_repository.dart (abstract)
│   └── usecases/      ← get_attractions.dart
└── presentation/
    ├── bloc/          ← attractions_bloc / _event / _state
    ├── pages/         ← attractions_page.dart
    └── widgets/       ← attraction_card.dart
```

> **`attractions` es la plantilla de referencia.** Las features scaffold
> (`home`, `calendar`, `map`, `artisans`) deben migrarse a esta forma al
> ganar lógica de negocio.

---

## 3. Core compartido

`lib/core/` contiene servicios transversales:

- `core/constants/` — helpers globales (ej. `localized_text.dart`).
- `core/theme/` — paleta (Danzante), tipografía, `AppTheme`.
- `core/error/` — `Failure`, `Exception`, manejo uniforme.
- `core/usecases/` — contrato base `UseCase`.
- `core/di/` — inyección de dependencias (`injection.dart`, `get_it`).

Adicionalmente:
- `lib/l10n/` — textos bilingües (`.arb`).
- `lib/shell/` — `MainShell` con la navegación inferior unificada.

> **Regla del service locator:** solo `main.dart` (y el arranque de la
> app) consultan `sl<T>()`. Todo lo demás recibe sus dependencias por
> constructor: un widget o BLoC que llame al service locator por su
> cuenta deja de ser testeable sin arrancar el grafo entero.

---

## 4. Principios SOLID aplicados

| Principio | Aplicación concreta |
| --- | --- |
| **S** — Single Responsibility | Un BLoC maneja **una** feature. Un Repository, **una** fuente de datos. |
| **O** — Open/Closed | Las features nuevas se **agregan** sin modificar las existentes. |
| **L** — Liskov Substitution | `AttractionsRepositoryImpl` es sustituible por cualquier `AttractionsRepository`. |
| **I** — Interface Segregation | Repositorios pequeños y específicos. |
| **D** — Dependency Inversion | El BLoC depende de **abstract** `Repository`, no de la implementación. |

---

## 5. Reglas innegociables

1. **Ningún Widget importa un datasource, `http` o `google_maps_flutter`
   como fuente de datos de negocio directamente.**
2. **Ningún BLoC importa modelos DTO.** Solo entidades de dominio.
3. **Ningún archivo en `domain/` importa Flutter.**
4. **Toda decisión de UI pasa por BLoC/Cubit** (o `ValueNotifier` solo en
   estado puramente local de widget).
5. **Ninguna cadena de texto visible al usuario va hardcoded.** Todo pasa
   por `AppLocalizations`.

---

## 6. Checklist de arquitectura para una nueva feature

- [ ] Carpeta `features/<name>/{data,domain,presentation}` creada.
- [ ] Entidad(es) de dominio definidas (inmutables, `Equatable`).
- [ ] Casos de uso (`usecases/`) implementados.
- [ ] Repositorio abstracto en `domain/repositories/`.
- [ ] Implementación en `data/repositories/`.
- [ ] Datasource(s) en `data/datasources/`.
- [ ] Model(s) DTO en `data/models/` con `fromJson` + `toEntity()`.
- [ ] BLoC + `Event` + `State` (inmutable, `Equatable`).
- [ ] Page(s) que consumen el BLoC con `BlocBuilder`/`BlocListener`.
- [ ] Widgets reutilizables en `presentation/widgets/`.
- [ ] Tests de UseCases, Repositories y BLoC.
- [ ] Sin código muerto. Sin TODOs sin ticket asociado.
