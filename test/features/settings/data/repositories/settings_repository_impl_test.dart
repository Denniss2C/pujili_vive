import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pujili_vive/core/error/exceptions.dart';
import 'package:pujili_vive/core/error/failures.dart';
import 'package:pujili_vive/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:pujili_vive/features/settings/data/repositories/settings_repository_impl.dart';

class _MockDataSource extends Mock implements SettingsLocalDataSource {}

void main() {
  late _MockDataSource dataSource;
  late SettingsRepositoryImpl repository;

  setUp(() {
    dataSource = _MockDataSource();
    repository = SettingsRepositoryImpl(localDataSource: dataSource);
  });

  test('devuelve el idioma guardado', () async {
    when(() => dataSource.getLanguageCode()).thenAnswer((_) async => 'en');

    expect(
      await repository.getLanguageCode(),
      const Right<Failure, String?>('en'),
    );
  });

  test('sin preferencia guardada devuelve null, no un fallo', () async {
    // null significa "el idioma del telefono", que es el valor por
    // defecto: no haber elegido nunca no es un error.
    when(() => dataSource.getLanguageCode()).thenAnswer((_) async => null);

    expect(
      await repository.getLanguageCode(),
      const Right<Failure, String?>(null),
    );
  });

  test('un fallo de disco al leer se convierte en CacheFailure', () async {
    when(() => dataSource.getLanguageCode())
        .thenThrow(CacheException('disco lleno'));

    expect(
      await repository.getLanguageCode(),
      const Left<Failure, String?>(CacheFailure('disco lleno')),
    );
  });

  test('guardar delega en el datasource', () async {
    when(() => dataSource.saveLanguageCode(any())).thenAnswer((_) async {});

    expect(
      await repository.saveLanguageCode('es'),
      const Right<Failure, Unit>(unit),
    );
    verify(() => dataSource.saveLanguageCode('es')).called(1);
  });

  test('un fallo de disco al guardar se convierte en CacheFailure', () async {
    when(() => dataSource.saveLanguageCode(any()))
        .thenThrow(CacheException('sin permisos'));

    expect(
      await repository.saveLanguageCode('en'),
      const Left<Failure, Unit>(CacheFailure('sin permisos')),
    );
  });
}
