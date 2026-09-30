import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pujili_vive/core/error/failures.dart';
import 'package:pujili_vive/core/usecases/usecase.dart';
import 'package:pujili_vive/features/favorites/domain/entities/favorite_ref.dart';
import 'package:pujili_vive/features/favorites/domain/usecases/get_favorites.dart';
import 'package:pujili_vive/features/favorites/domain/usecases/save_favorites.dart';
import 'package:pujili_vive/features/favorites/presentation/cubit/favorites_cubit.dart';

import '../../../../helpers/favorites_cubit_helper.dart';

class _MockGet extends Mock implements GetFavorites {}

class _MockSave extends Mock implements SaveFavorites {}

void main() {
  const isinche = FavoriteRef.attraction('isinche');
  const pregon = FavoriteRef.festival('pregon-de-fiestas');

  group('con repositorio de verdad', () {
    test('guardar y volver a leer devuelve lo mismo', () async {
      final repo = InMemoryFavoritesRepository();
      final cubit = buildFavoritesCubit(repository: repo);

      await cubit.toggle(isinche);
      await cubit.toggle(pregon);

      expect(repo.saved, {isinche, pregon});

      // Un cubit nuevo sobre el mismo repositorio ve lo guardado: es lo
      // que pasa al cerrar y volver a abrir la app.
      final otro = buildFavoritesCubit(repository: repo);
      await otro.load();
      expect(otro.state, {isinche, pregon});

      await cubit.close();
      await otro.close();
    });

    test('volver a tocar el corazon lo quita', () async {
      final repo = InMemoryFavoritesRepository();
      final cubit = buildFavoritesCubit(repository: repo);

      await cubit.toggle(isinche);
      await cubit.toggle(isinche);

      expect(cubit.state, isEmpty);
      expect(repo.saved, isEmpty);
      await cubit.close();
    });
  });

  group('cuando el disco falla', () {
    late _MockGet get;
    late _MockSave save;

    setUpAll(() {
      registerFallbackValue(NoParams());
      registerFallbackValue(<FavoriteRef>{});
    });

    setUp(() {
      get = _MockGet();
      save = _MockSave();
    });

    blocTest<FavoritesCubit, Set<FavoriteRef>>(
      'si leer falla, se arranca sin guardados en vez de reventar',
      setUp: () => when(() => get(any()))
          .thenAnswer((_) async => const Left(CacheFailure())),
      build: () => FavoritesCubit(getFavorites: get, saveFavorites: save),
      act: (cubit) => cubit.load(),
      // Es el mismo estado que tiene quien no ha guardado nada nunca, y
      // la pantalla ya sabe explicarlo.
      expect: () => <Set<FavoriteRef>>[const {}],
    );

    blocTest<FavoritesCubit, Set<FavoriteRef>>(
      'si guardar falla, el corazon se marca igual en pantalla',
      setUp: () {
        when(() => get(any())).thenAnswer((_) async => const Right({}));
        when(() => save(any()))
            .thenAnswer((_) async => const Left(CacheFailure()));
      },
      build: () => FavoritesCubit(getFavorites: get, saveFavorites: save),
      act: (cubit) => cubit.toggle(isinche),
      // Negarle el toque al usuario porque el disco no responde seria
      // peor que perderlo al reiniciar.
      expect: () => [
        {isinche},
      ],
    );
  });
}
