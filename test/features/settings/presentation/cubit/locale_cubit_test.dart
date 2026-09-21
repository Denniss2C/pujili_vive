import 'dart:ui';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pujili_vive/core/error/failures.dart';
import 'package:pujili_vive/core/usecases/usecase.dart';
import 'package:pujili_vive/features/settings/domain/usecases/get_language_code.dart';
import 'package:pujili_vive/features/settings/domain/usecases/save_language_code.dart';
import 'package:pujili_vive/features/settings/presentation/cubit/locale_cubit.dart';

class _MockGet extends Mock implements GetLanguageCode {}

class _MockSave extends Mock implements SaveLanguageCode {}

void main() {
  late _MockGet get;
  late _MockSave save;

  setUpAll(() => registerFallbackValue(NoParams()));

  setUp(() {
    get = _MockGet();
    save = _MockSave();
    when(() => save(any())).thenAnswer((_) async => const Right(unit));
  });

  LocaleCubit build() =>
      LocaleCubit(getLanguageCode: get, saveLanguageCode: save);

  test('arranca sin idioma elegido: manda el del telefono', () {
    expect(build().state, isNull);
  });

  blocTest<LocaleCubit, Locale?>(
    'load() aplica el idioma guardado',
    setUp: () => when(() => get(any()))
        .thenAnswer((_) async => const Right<Failure, String?>('en')),
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => [const Locale('en')],
  );

  blocTest<LocaleCubit, Locale?>(
    'si leer las preferencias falla, se queda con el del telefono',
    // Un disco que no responde no debe dejar la app sin idioma: el valor
    // por defecto ya es "el del sistema".
    setUp: () => when(() => get(any()))
        .thenAnswer((_) async => const Left(CacheFailure())),
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => <Locale?>[null],
  );

  blocTest<LocaleCubit, Locale?>(
    'change() aplica el idioma y lo guarda',
    build: build,
    act: (cubit) => cubit.change('es'),
    expect: () => [const Locale('es')],
    verify: (_) => verify(() => save('es')).called(1),
  );

  blocTest<LocaleCubit, Locale?>(
    'volver a "el del telefono" borra la preferencia',
    build: build,
    seed: () => const Locale('en'),
    act: (cubit) => cubit.change(null),
    expect: () => <Locale?>[null],
    verify: (_) => verify(() => save(null)).called(1),
  );

  blocTest<LocaleCubit, Locale?>(
    'si el guardado falla, el cambio se aplica igual en pantalla',
    // Negarle el cambio al usuario porque el disco no responde seria peor
    // que perderlo al reiniciar.
    setUp: () => when(() => save(any()))
        .thenAnswer((_) async => const Left(CacheFailure())),
    build: build,
    act: (cubit) => cubit.change('en'),
    expect: () => [const Locale('en')],
  );
}
