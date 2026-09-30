import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/favorite_ref.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, Set<FavoriteRef>>> getFavorites();

  Future<Either<Failure, Unit>> save(Set<FavoriteRef> favorites);
}
