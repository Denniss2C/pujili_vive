# 04 — Repositorios y Datasources

> **Objetivo:** encapsular TODO el acceso a datos detrás de contratos
> limpios, testeables y desacoplados del origen.

---

## 1. Anatomía

```
domain/repositories/  ─►  abstract class (contrato)
data/repositories/    ─►  class implements (lógica)
data/datasources/     ─►  class (origen crudo: JSON local, red, prefs)
data/models/          ─►  DTOs con fromJson / toEntity
```

---

## 2. Repositorio (interface en domain)

```dart
abstract class AttractionsRepository {
  Future<List<Attraction>> getAttractions();
}
```

- Métodos pequeños, intención clara.
- Retornan **entidades de dominio** (nunca `Model`).
- Parametrización por tipos primitivos, no `Map<String, dynamic>`.

---

## 3. Datasource

- Vive en `data/datasources/`.
- **No conoce** `Failure`, conoce `Exception` (capa de traducción).
- En este proyecto el origen principal es un JSON en assets:

```dart
abstract class AttractionsLocalDataSource {
  Future<List<AttractionModel>> getAttractions();
}

class AttractionsLocalDataSourceImpl implements AttractionsLocalDataSource {
  final AssetBundle bundle;
  const AttractionsLocalDataSourceImpl(this.bundle);

  @override
  Future<List<AttractionModel>> getAttractions() async {
    try {
      final raw = await bundle.loadString('assets/data/attractions.json');
      final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
      return list.map(AttractionModel.fromJson).toList();
    } on FlutterError catch (e) {
      throw CacheException(e.message);
    } on FormatException catch (e) {
      throw CacheException(e.message);
    }
  }
}
```

> Inyectar `AssetBundle` (en vez de usar `rootBundle` global) permite
> pasar un bundle falso en los tests y no depender de assets reales.

---

## 4. Implementación del Repositorio

```dart
class AttractionsRepositoryImpl implements AttractionsRepository {
  final AttractionsLocalDataSource local;
  const AttractionsRepositoryImpl(this.local);

  @override
  Future<List<Attraction>> getAttractions() async {
    try {
      return await local.getAttractions();
    } on CacheException catch (e) {
      throw CacheFailure(debugDetails: e.message);
    }
  }
}
```

Reglas:
- Mapear `Exception → Failure` en el repositorio.
- Cachear respuestas costosas cuando aplique.

---

## 5. Manejo de errores con `Either` (opcional)

El proyecto ya incluye `dartz`. Cuando un caso lo amerite:

```dart
Future<Either<Failure, List<Attraction>>> getAttractions();
```

Mantén una sola convención por feature: o excepciones tipadas `Failure`,
o `Either`. No mezclar dentro de la misma feature.

---

## 6. Errores prohibidos

- ❌ Repositorio que depende de `BuildContext`.
- ❌ Repositorio que **no** es `abstract` en `domain/`.
- ❌ BLoC que importa `data/models/`.
- ❌ Datasource que retorna `Entity` (debe retornar `Model`).
- ❌ Repositorio que hace UI (`print`, `SnackBar`).

---

## 7. Checklist

- [ ] `abstract class` en `domain/repositories/`.
- [ ] `class ... implements` en `data/repositories/`.
- [ ] Datasource(s) en `data/datasources/`.
- [ ] Mapper Model → Entity.
- [ ] `Exception` (data) → `Failure` (domain).
- [ ] Test del repositorio con datasource mockeado.
