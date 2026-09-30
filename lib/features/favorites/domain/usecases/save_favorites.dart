import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/favorite_ref.dart';
import '../repositories/favorites_repository.dart';

/// Guarda la lista entera, no un alta o una baja sueltas.
///
/// El cubit ya tiene el conjunto completo en memoria, asi que escribirlo
/// de una vez evita leer-modificar-escribir y las carreras que eso trae.
class SaveFavorites implements UseCase<Unit, Set<FavoriteRef>> {
  final FavoritesRepository repository;

  SaveFavorites(this.repository);

  @override
  Future<Either<Failure, Unit>> call(Set<FavoriteRef> params) {
    return repository.save(params);
  }
}
