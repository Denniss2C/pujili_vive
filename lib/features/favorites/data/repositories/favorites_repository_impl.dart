import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/favorite_ref.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_local_datasource.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource localDataSource;

  FavoritesRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, Set<FavoriteRef>>> getFavorites() async {
    try {
      final keys = await localDataSource.getKeys();
      // Las entradas que no se entienden se tiran, no tumban la lectura:
      // pueden venir de una version anterior con otro formato.
      final refs =
          keys.map(FavoriteRef.tryParse).whereType<FavoriteRef>().toSet();
      return Right(refs);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> save(Set<FavoriteRef> favorites) async {
    try {
      await localDataSource.saveKeys(favorites.map((f) => f.key).toList());
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
