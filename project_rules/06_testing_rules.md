# 06 — Testing: Unit, Widget, Integration

> **Cobertura mínima objetivo:** 80 % en `domain/` y `data/`, 70 % en
> `presentation/bloc/`. Toda PR con lógica nueva sin tests es rechazada.

---

## 1. Pirámide de testing

```
        ┌──────────────────┐
        │  Integration     │  ← pocos, flujos críticos end-to-end
        ├──────────────────┤
        │  Widget Tests    │  ← pantallas y componentes clave
        ├──────────────────┤
        │  Unit Tests      │  ← UseCases, Repos, BLoCs, Mappers
        └──────────────────┘
```

---

## 2. Estructura de carpetas

```
test/
├── core/
├── features/
│   └── attractions/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   └── usecases/
│       └── presentation/
│           ├── bloc/
│           ├── pages/
│           └── widgets/
└── helpers/
    ├── fixtures/
    └── mocks/
```

> Hoy `test/` solo tiene `widget_test.dart`. La feature `attractions`
> debe ser la primera en tener su árbol de tests completo, como plantilla.

---

## 3. Unit Tests

### 3.1 UseCase

```dart
test('GetAttractions retorna lista cuando el repo responde OK', () async {
  when(() => mockRepo.getAttractions())
      .thenAnswer((_) async => [attractionFake]);
  final usecase = GetAttractions(mockRepo);

  final result = await usecase();

  expect(result, [attractionFake]);
  verify(() => mockRepo.getAttractions()).called(1);
});
```

### 3.2 Repository / Datasource

```dart
test('getAttractions parsea el JSON del bundle', () async {
  when(() => bundle.loadString('assets/data/attractions.json'))
      .thenAnswer((_) async => fixtureJson);

  final result = await datasource.getAttractions();

  expect(result, isA<List<AttractionModel>>());
});
```

### 3.3 BLoC con `bloc_test`

Ver ejemplo en [`03_bloc_rules.md`](./03_bloc_rules.md) §6.

---

## 4. Widget Tests

```dart
testWidgets('AttractionsView muestra empty state si la lista está vacía',
    (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<AttractionsBloc>.value(
        value: MockAttractionsBloc(const AttractionsState()),
        child: const AttractionsView(),
      ),
    ),
  );
  await tester.pumpAndSettle();
  expect(find.byType(EmptyView), findsOneWidget);
});
```

Reglas:
- Configurar los `localizationsDelegates` en widget tests (app bilingüe).
- `pumpAndSettle` solo cuando no hay animaciones infinitas.

---

## 5. Integration Tests

`integration_test/` para flujos críticos: navegación entre los 5 tabs,
carga de atractivos, apertura del mapa.

---

## 6. Mocks y Fixtures

- Mocks con `mocktail` (ya está en `dev_dependencies`).
- Fixtures en `test/helpers/fixtures/`.

```dart
class AttractionFixture {
  static Attraction make() => const Attraction(
        id: 'isinche',
        name: 'Santuario de Isinche',
        description: '...',
        lat: -0.9613,
        lng: -78.7010,
      );
}
```

---

## 7. Cobertura

```bash
flutter test --coverage      # genera coverage/lcov.info
```

- Umbral: ≥ 80 % de líneas en `domain/` y `data/`.
- Ningún archivo de `domain/`/`data/` con lógica debe quedar sin tests.

---

## 8. Errores prohibidos

- ❌ Tests que dependen de red o assets remotos.
- ❌ Tests sin `expect`.
- ❌ `await Future.delayed` en lugar de `pumpAndSettle`.
- ❌ Comparar objetos sin `Equatable`.

---

## 9. Checklist

- [ ] Cada `usecase`: 1 test de éxito y 1 de error.
- [ ] Cada `repository`/`datasource`: test con dependencias mockeadas.
- [ ] Cada `bloc`: `blocTest` por evento.
- [ ] Cada `page` crítica: widget test.
- [ ] Cobertura ≥ 80 % en `domain/` y `data/`.
