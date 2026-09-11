# 03 — BLoC Pattern: Reglas

> **Pujilí Vive usa `flutter_bloc` para la gestión de estado.** No se
> admite `setState` para estado de feature, ni `Provider`/`Riverpod` en
> paralelo. Se permite `ValueNotifier` solo para estado puramente local
> de un widget que NO se comparte.

---

## 1. Estructura obligatoria

Por cada feature con estado:

```
features/<feature>/presentation/bloc/
├── <feature>_bloc.dart
├── <feature>_event.dart
└── <feature>_state.dart
```

---

## 2. Naming

| Elemento | Convención | Ejemplo |
| --- | --- | --- |
| Bloc | `XxxBloc` | `AttractionsBloc` |
| Cubit | `XxxCubit` | `LocaleCubit` |
| Event | `XxxEvent` (sealed) | `AttractionsEvent` |
| Estado | `XxxState` (sealed) | `AttractionsState` |
| Eventos | `<Verbo><Sustantivo>` | `AttractionsRequested` |
| Estados | `Initial/Loading/Loaded/Error` | `AttractionsLoaded` |

---

## 3. Implementación

```dart
// attractions_event.dart
sealed class AttractionsEvent extends Equatable {
  const AttractionsEvent();
  @override
  List<Object?> get props => [];
}

class AttractionsRequested extends AttractionsEvent {
  const AttractionsRequested();
}
```

```dart
// attractions_state.dart
enum AttractionsStatus { initial, loading, loaded, error }

class AttractionsState extends Equatable {
  final AttractionsStatus status;
  final List<Attraction> attractions;
  final Failure? failure;

  const AttractionsState({
    this.status = AttractionsStatus.initial,
    this.attractions = const [],
    this.failure,
  });

  AttractionsState copyWith({
    AttractionsStatus? status,
    List<Attraction>? attractions,
    Failure? failure,
  }) =>
      AttractionsState(
        status: status ?? this.status,
        attractions: attractions ?? this.attractions,
        failure: failure,
      );

  @override
  List<Object?> get props => [status, attractions, failure];
}
```

```dart
// attractions_bloc.dart
class AttractionsBloc extends Bloc<AttractionsEvent, AttractionsState> {
  final GetAttractions getAttractions;

  AttractionsBloc(this.getAttractions) : super(const AttractionsState()) {
    on<AttractionsRequested>(_onRequested);
  }

  Future<void> _onRequested(
    AttractionsRequested e,
    Emitter<AttractionsState> emit,
  ) async {
    emit(state.copyWith(status: AttractionsStatus.loading));
    try {
      final data = await getAttractions();
      emit(state.copyWith(
        status: AttractionsStatus.loaded,
        attractions: data,
      ));
    } on Failure catch (failure) {
      emit(state.copyWith(status: AttractionsStatus.error, failure: failure));
    }
  }
}
```

> Un estado de error nunca lleva texto ya escrito: lleva el `Failure`, y
> la pantalla lo traduce con `AppLocalizations` al pintarlo.

---

## 4. Uso en widgets

- `BlocProvider` lo más cerca posible de la pantalla que lo usa.
- `BlocBuilder` para rebuild; `BlocListener` para side-effects
  (navegación, SnackBar); `BlocConsumer` para ambos.
- **NUNCA** instanciar un BLoC con `MiBloc()` dentro de un widget.

```dart
BlocProvider(
  create: (_) => sl<AttractionsBloc>()..add(const AttractionsRequested()),
  child: const AttractionsView(),
);
```

---

## 5. Errores prohibidos

| Anti-patrón | Por qué |
| --- | --- |
| `setState` para estado compartido | No hay evento, ni historial, ni test. |
| Lógica de negocio en `build()` | Acopla UI y reglas. |
| `print` en BLoC | Usar `Logger` / `log()`. |
| BLoC que recibe `BuildContext` | Rompe la regla D de SOLID. |
| Estado mutable en BLoC | Rompe `Equatable`. |

---

## 6. Testing de BLoC

Cada BLoC debe cubrir: estado inicial, transición a éxito y transición a
error, con `blocTest` y mocks (`mocktail`).

```dart
blocTest<AttractionsBloc, AttractionsState>(
  'emite [loading, loaded] al pedir atractivos',
  build: () {
    when(() => mockGet()).thenAnswer((_) async => [attractionFake]);
    return AttractionsBloc(mockGet);
  },
  act: (bloc) => bloc.add(const AttractionsRequested()),
  expect: () => [
    const AttractionsState(status: AttractionsStatus.loading),
    AttractionsState(
      status: AttractionsStatus.loaded,
      attractions: [attractionFake],
    ),
  ],
);
```

---

## 7. Checklist

- [ ] Separación `*_bloc/_event/_state`.
- [ ] `Event` y `State` son `sealed` y `Equatable`.
- [ ] El BLoC solo depende de UseCases.
- [ ] Se manejan los 4 estados.
- [ ] Hay `blocTest` por cada evento crítico.
