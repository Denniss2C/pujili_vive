import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pujili_vive/core/error/failures.dart';
import 'package:pujili_vive/features/settings/domain/repositories/settings_repository.dart';
import 'package:pujili_vive/features/settings/domain/usecases/save_language_code.dart';

class _MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late _MockSettingsRepository repository;
  late SaveLanguageCode usecase;

  setUp(() {
    repository = _MockSettingsRepository();
    usecase = SaveLanguageCode(repository);
    when(() => repository.saveLanguageCode(any()))
        .thenAnswer((_) async => const Right(unit));
  });

  test('guarda el idioma elegido', () async {
    expect(await usecase('en'), const Right<Failure, Unit>(unit));
    verify(() => repository.saveLanguageCode('en')).called(1);
  });

  test('null se pasa tal cual: vuelve al idioma del telefono', () async {
    await usecase(null);

    verify(() => repository.saveLanguageCode(null)).called(1);
  });

  test('propaga el fallo cuando el repositorio falla', () async {
    when(() => repository.saveLanguageCode(any()))
        .thenAnswer((_) async => const Left(CacheFailure('sin permisos')));

    expect(
      await usecase('es'),
      const Left<Failure, Unit>(CacheFailure('sin permisos')),
    );
  });
}
