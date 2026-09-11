# 08 — Estructura de Carpetas

> Estructura canónica de Pujilí Vive. Toda desviación requiere
> justificación arquitectónica.

---

## 1. Raíz del proyecto

```
pujili_vive/
├── android/
├── ios/
├── web/
├── lib/
├── test/
├── integration_test/       ← flujos críticos (a crear)
├── assets/
│   ├── data/               ← attractions.json (y futuros)
│   └── images/
├── project_rules/          ← este manual
├── .github/                ← CI, plantillas, CODEOWNERS, dependabot
├── .editorconfig
├── .gitignore
├── analysis_options.yaml
├── l10n.yaml
├── pubspec.yaml
├── CHANGELOG.md
├── CONTRIBUTING.md
├── SECURITY.md
├── LICENSE
└── README.md
```

---

## 2. lib/

```
lib/
├── main.dart
├── core/
│   ├── constants/          ← localized_text.dart
│   ├── theme/              ← app_colors.dart, app_theme.dart
│   ├── error/              ← failures.dart, exceptions.dart
│   ├── usecases/           ← usecase.dart (contrato base)
│   └── di/                 ← injection.dart (get_it)
├── features/
│   ├── attractions/        ← FEATURE DE REFERENCIA (completa)
│   ├── home/               ← scaffold → migrar al patrón
│   ├── calendar/           ← scaffold
│   ├── map/                ← scaffold (Google Maps)
│   └── artisans/           ← scaffold
├── shell/                  ← main_shell.dart (navegación inferior)
└── l10n/                   ← app_es.arb, app_en.arb (+ generados, gitignored)
```

---

## 3. Anatomía de una feature (referencia: `attractions`)

```
features/attractions/
├── data/
│   ├── datasources/attractions_local_datasource.dart
│   ├── models/attraction_model.dart
│   └── repositories/attractions_repository_impl.dart
├── domain/
│   ├── entities/attraction.dart
│   ├── entities/attraction_category.dart
│   ├── repositories/attractions_repository.dart   (abstract)
│   └── usecases/get_attractions.dart
└── presentation/
    ├── bloc/attractions_bloc.dart
    ├── bloc/attractions_event.dart
    ├── bloc/attractions_state.dart
    ├── pages/attractions_page.dart
    └── widgets/attraction_card.dart
```

---

## 4. Reglas de la estructura

1. **No** crear `helpers/`/`utils/` sueltos en la raíz de `lib/`.
2. Código compartido solo en `core/`, `shell/` o `l10n/`.
3. Cada feature es **independiente**: no importa a otras features. Si
   necesitas lógica de otra, muévela a `core/`.
4. `data/`, `domain/`, `presentation/` son obligatorias en cada feature
   con lógica de negocio.
5. `presentation/widgets/` solo widgets de esa feature; si es compartido,
   va a `core/widgets/`.
6. Ningún archivo fuera de `presentation/`/`shell/` importa
   `package:flutter/material.dart`.

---

## 5. Migración de scaffolds

| Feature | Acción |
| --- | --- |
| `home`, `calendar`, `map`, `artisans` | Al ganar lógica, crear `{data,domain,presentation}` siguiendo `attractions`. |
| Tab "Perfil" apuntando a `ArtisansPage` | Crear su propia feature cuando exista contenido. |
| Datos hardcoded en widgets | Mover a `assets/data/` + `data/datasources/`. |
| Strings hardcoded | Mover a `lib/l10n/app_*.arb`. |
