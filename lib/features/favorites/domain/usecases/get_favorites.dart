import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/favorite_ref.dart';
import '../repositories/favorites_repository.dart';

class GetFavorites implements UseCase<Set<FavoriteRef>, NoParams> {
  final FavoritesRepository repository;

  GetFavorites(this.repository);

  @override
  Future<Either<Failure, Set<FavoriteRef>>> call(NoParams params) {
    return repository.getFavorites();
  }
}
