import 'package:dartz/dartz.dart';
import 'package:pujili_vive/core/error/failures.dart';
import 'package:pujili_vive/features/favorites/domain/entities/favorite_ref.dart';
import 'package:pujili_vive/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:pujili_vive/features/favorites/domain/usecases/get_favorites.dart';
import 'package:pujili_vive/features/favorites/domain/usecases/save_favorites.dart';
import 'package:pujili_vive/features/favorites/presentation/cubit/favorites_cubit.dart';

/// Repositorio de guardados en memoria.
///
/// Se prefiere a un mock porque **funciona de verdad**: guardar y volver
/// a leer se comporta como en la app, asi que un test puede tocar el
/// corazon y comprobar el resultado sin programar respuestas una por una.
class InMemoryFavoritesRepository implements FavoritesRepository {
  Set<FavoriteRef> _saved;

  InMemoryFavoritesRepository([Set<FavoriteRef> initial = const {}])
      : _saved = {...initial};

  Set<FavoriteRef> get saved => _saved;

  @override
  Future<Either<Failure, Set<FavoriteRef>>> getFavorites() async =>
      Right({..._saved});

  @override
  Future<Either<Failure, Unit>> save(Set<FavoriteRef> favorites) async {
    _saved = {...favorites};
    return const Right(unit);
  }
}

/// Un [FavoritesCubit] listo para montar en un test de widget.
///
/// Casi toda pantalla lo necesita en el arbol desde que los detalles
/// llevan corazon, asi que vive aqui en vez de repetirse en cada fichero.
FavoritesCubit buildFavoritesCubit({
  Set<FavoriteRef> initial = const {},
  InMemoryFavoritesRepository? repository,
}) {
  final repo = repository ?? InMemoryFavoritesRepository(initial);
  return FavoritesCubit(
    getFavorites: GetFavorites(repo),
    saveFavorites: SaveFavorites(repo),
  );
}
