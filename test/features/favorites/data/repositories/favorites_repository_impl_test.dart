import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pujili_vive/core/error/exceptions.dart';
import 'package:pujili_vive/core/error/failures.dart';
import 'package:pujili_vive/features/favorites/data/datasources/favorites_local_datasource.dart';
import 'package:pujili_vive/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:pujili_vive/features/favorites/domain/entities/favorite_ref.dart';

class _MockDataSource extends Mock implements FavoritesLocalDataSource {}

void main() {
  late _MockDataSource dataSource;
  late FavoritesRepositoryImpl repository;

  setUp(() {
    dataSource = _MockDataSource();
    repository = FavoritesRepositoryImpl(localDataSource: dataSource);
  });

  test('convierte las claves guardadas en referencias', () async {
    when(() => dataSource.getKeys()).thenAnswer(
      (_) async => ['attraction:quilotoa', 'festival:corpus-christi'],
    );

    final result = await repository.getFavorites();

    expect(result.getOrElse(() => {}), {
      const FavoriteRef.attraction('quilotoa'),
      const FavoriteRef.festival('corpus-christi'),
    });
  });

  test('descarta las claves que no entiende sin fallar', () async {
    // Una version vieja pudo guardar otro formato: se pierde esa entrada,
    // pero la pantalla de guardados sigue abriendo.
    when(() => dataSource.getKeys()).thenAnswer(
      (_) async => ['quilotoa', 'artisan:alfareria', 'attraction:isinche'],
    );

    final result = await repository.getFavorites();

    expect(result.getOrElse(() => {}), {
      const FavoriteRef.attraction('isinche'),
    });
  });

  test('un fallo de disco al leer se convierte en CacheFailure', () async {
    when(() => dataSource.getKeys()).thenThrow(CacheException('disco lleno'));

    expect(
      await repository.getFavorites(),
      const Left<Failure, Set<FavoriteRef>>(CacheFailure('disco lleno')),
    );
  });

  test('guardar escribe cada referencia como tipo:id', () async {
    when(() => dataSource.saveKeys(any())).thenAnswer((_) async {});

    final result = await repository.save({
      const FavoriteRef.attraction('quilotoa'),
      const FavoriteRef.festival('corpus-christi'),
    });

    expect(result, const Right<Failure, Unit>(unit));
    final saved =
        verify(() => dataSource.saveKeys(captureAny())).captured.single;
    expect(saved, ['attraction:quilotoa', 'festival:corpus-christi']);
  });

  test('un fallo de disco al guardar se convierte en CacheFailure', () async {
    when(() => dataSource.saveKeys(any()))
        .thenThrow(CacheException('sin permisos'));

    expect(
      await repository.save({const FavoriteRef.attraction('quilotoa')}),
      const Left<Failure, Unit>(CacheFailure('sin permisos')),
    );
  });
}
