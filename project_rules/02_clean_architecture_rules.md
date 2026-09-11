# 02 — Clean Architecture: Reglas

> **Objetivo:** que el código sea independiente de frameworks, UI y
> fuentes de datos, y que la lógica de negocio sea testable sin Flutter.

---

## 1. Las 3 capas en detalle

### 1.1 Domain (Núcleo puro)

- **NO** importa Flutter ni `dart:ui`.
- **NO** conoce el origen de los datos (JSON local, red, Maps).
- Contiene:
  - `entities/` — clases inmutables (`Equatable`).
  - `repositories/` — **abstract** `class`.
  - `usecases/` — una clase por acción del usuario, con un único `call()`.

```dart
// domain/entities/attraction.dart
import 'package:equatable/equatable.dart';

class Attraction extends Equatable {
  final String id;
  final String name;
  final String description;
  final double lat;
  final double lng;

  const Attraction({
    required this.id,
    required this.name,
    required this.description,
    required this.lat,
    required this.lng,
  });

  @override
  List<Object?> get props => [id, name, description, lat, lng];
}
```

```dart
// domain/repositories/attractions_repository.dart
abstract class AttractionsRepository {
  Future<List<Attraction>> getAttractions();
}
```

```dart
// domain/usecases/get_attractions.dart
class GetAttractions {
  final AttractionsRepository repository;
  const GetAttractions(this.repository);

  Future<List<Attraction>> call() => repository.getAttractions();
}
```

#### ❌ Incorrecto

```dart
// domain/usecases/get_attractions.dart
import 'dart:convert';          // ❌ el dominio no lee assets
import 'package:flutter/services.dart'; // ❌ Flutter en domain

class GetAttractions {
  Future<List<Attraction>> call() async {
    final raw = await rootBundle.loadString('assets/data/attractions.json');
    // ❌ el dominio no sabe de dónde salen los datos
  }
}
```

---

### 1.2 Data (Implementación)

- Implementa los **contratos** de `domain/repositories/`.
- Conoce el origen: JSON en assets, red, `SharedPreferences`, etc.
- Convierte **Model ↔ Entity** mediante mappers.

```dart
// data/models/attraction_model.dart
class AttractionModel extends Attraction {
  const AttractionModel({
    required super.id,
    required super.name,
    required super.description,
    required super.lat,
    required super.lng,
  });

  factory AttractionModel.fromJson(Map<String, dynamic> json) =>
      AttractionModel(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        lat: (json['lat'] as num).toDouble(),
        lng: (json['lng'] as num).toDouble(),
      );
}
```

```dart
// data/repositories/attractions_repository_impl.dart
class AttractionsRepositoryImpl implements AttractionsRepository {
  final AttractionsLocalDataSource local;
  const AttractionsRepositoryImpl(this.local);

  @override
  Future<List<Attraction>> getAttractions() => local.getAttractions();
}
```

---

### 1.3 Presentation (UI + BLoC)

- Solo conoce `domain/`.
- El BLoC depende de **UseCases**, no de `Repository` directamente.
- Los widgets **no** instancian el BLoC con `new`: usan `BlocProvider`.

---

## 2. Regla de oro: el sentido de las dependencias

```
presentation ──▶ domain ◀── data
                    ▲
                    │
                  usecases
```

`domain` **no depende de nadie**.

---

## 3. Errores y excepciones

- `core/error/` define `Failure` (jerarquía sellada) y `Exception`.
- `data` captura `Exception` y lo mapea a `Failure`.
- `presentation` solo recibe `Failure` y decide el texto (localizado).

> Un `Failure` no lleva texto para el usuario: la pantalla lo traduce con
> `AppLocalizations` en el momento de pintarlo. Si el texto naciera en
> `data/`, el idioma lo estaría eligiendo la capa que menos sabe de quién
> mira la pantalla.

---

## 4. Checklist

- [ ] `domain/` sin imports de Flutter ni de paquetes de datos.
- [ ] Cada `usecase` tiene una sola responsabilidad.
- [ ] Toda `entity` es inmutable y extiende `Equatable`.
- [ ] Todo `repository` es `abstract` y vive en `domain/`.
- [ ] `models/` nunca se filtran a `presentation/`.
- [ ] `data/` mapea `Exception → Failure`.
- [ ] Sin `print` en producción.
