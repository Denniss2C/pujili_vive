# 07 — Convenciones de Naming

> Obligatorias y validadas por el análisis estático.

---

## 1. Reglas generales de Dart/Flutter

| Elemento | Convención | Ejemplo |
| --- | --- | --- |
| Clases, enums, typedefs | `PascalCase` | `AttractionsBloc`, `Attraction` |
| Extensiones | `PascalCase` | `StringExtensions` |
| Métodos, funciones, variables | `camelCase` | `getAttractions` |
| Constantes | `camelCase` (Dart style) | `defaultTimeout` |
| Archivos | `snake_case.dart` | `attractions_bloc.dart` |
| Privados | prefijo `_` | `_onRequested` |
| Booleanos | `is`, `has`, `can`, `should` | `isLoading`, `hasItems` |

---

## 2. BLoC

| Elemento | Convención | Ejemplo |
| --- | --- | --- |
| Bloc | `<Feature>Bloc` | `AttractionsBloc` |
| Cubit | `<Feature>Cubit` | `LocaleCubit` |
| Event | `<Feature>Event` (sealed) | `AttractionsEvent` |
| Estado | `<Feature>State` (sealed) | `AttractionsState` |
| Eventos | `<Verbo><Sustantivo>` | `AttractionsRequested` |
| Estados | `<Status>` | `AttractionsLoading`, `AttractionsLoaded` |

---

## 3. Capas

| Capa | Sufijo | Ejemplo |
| --- | --- | --- |
| Entity (domain) | sin sufijo o `Entity` | `Attraction` |
| Model (data) | `Model` | `AttractionModel` |
| Repository interface (domain) | `Repository` | `AttractionsRepository` |
| Repository impl (data) | `RepositoryImpl` | `AttractionsRepositoryImpl` |
| Datasource (data) | `DataSource` | `AttractionsLocalDataSource` |
| Datasource impl | `DataSourceImpl` | `AttractionsLocalDataSourceImpl` |
| UseCase (domain) | `<Verbo><Sustantivo>` | `GetAttractions` |
| Failure (core) | `Failure` | `CacheFailure` |
| Exception (core) | `Exception` | `CacheException` |

> Un mismo concepto **no** puede llamarse distinto en distintas capas.

---

## 4. Rutas / tabs

- Rutas nombradas centralizadas; `static const String routeName`.
- Ejemplos de tabs del shell: `home`, `attractions`, `calendar`, `map`,
  `artisans`.

---

## 5. Constantes

```dart
abstract final class AppConstants {
  AppConstants._();
  static const Duration loadTimeout = Duration(seconds: 10);
}
```

---

## 6. Errores prohibidos

- ❌ `snake_case`/`kebab-case` en clases.
- ❌ `PascalCase` en nombres de archivo.
- ❌ Abreviaturas crípticas: `attrRepo`, `attrMdl`.
- ❌ `Helper`, `Manager`, `Utils` genéricos.
- ❌ Mezcla español/inglés en identificadores de código (el código en
  inglés; el contenido de usuario, bilingüe vía `.arb`/JSON).
