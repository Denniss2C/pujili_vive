import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/favorite_ref.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/save_favorites.dart';

/// Lo que el usuario ha guardado.
///
/// Es un `Cubit<Set<FavoriteRef>>` sin estados de carga ni de error a
/// proposito: un corazon tiene que responder al instante. Si el disco
/// falla al guardar, la pantalla ya cambio y lo unico que se pierde es la
/// persistencia; negarle el toque al usuario seria peor.
class FavoritesCubit extends Cubit<Set<FavoriteRef>> {
  final GetFavorites getFavorites;
  final SaveFavorites saveFavorites;

  FavoritesCubit({
    required this.getFavorites,
    required this.saveFavorites,
  }) : super(const {});

  /// Lee lo guardado. Se llama una vez, al arrancar.
  Future<void> load() async {
    final result = await getFavorites(NoParams());
    // Un fallo al leer deja la lista vacia: es el mismo estado que tiene
    // alguien que todavia no ha guardado nada, y la pantalla ya sabe
    // explicarlo.
    result.fold((_) => emit(const {}), emit);
  }

  bool contains(FavoriteRef ref) => state.contains(ref);

  Future<void> toggle(FavoriteRef ref) async {
    final next = Set<FavoriteRef>.from(state);
    if (!next.remove(ref)) next.add(ref);

    emit(next);
    await saveFavorites(next);
  }
}
