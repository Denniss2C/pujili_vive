import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pujili_vive/core/error/failures.dart';
import 'package:pujili_vive/core/usecases/usecase.dart';
import 'package:pujili_vive/features/attractions/domain/entities/attraction_category.dart';
import 'package:pujili_vive/features/attractions/domain/usecases/get_attractions.dart';
import 'package:pujili_vive/features/attractions/presentation/bloc/attractions_bloc.dart';

import '../../../../helpers/fixtures/attraction_fixtures.dart';

class _MockGetAttractions extends Mock implements GetAttractions {}

class _FakeNoParams extends Fake implements NoParams {}

void main() {
  late _MockGetAttractions getAttractions;

  final santuario = buildAttraction(id: 'santuario-nino-isinche');
  final iglesia = buildAttraction(id: 'iglesia-matriz');
  final quilotoa = buildAttraction(
    id: 'quilotoa',
    category: AttractionCategory.nature,
  );
  final attractions = [santuario, quilotoa, iglesia];

  setUpAll(() => registerFallbackValue(_FakeNoParams()));

  setUp(() {
    getAttractions = _MockGetAttractions();
    when(() => getAttractions(any()))
        .thenAnswer((_) async => Right(attractions));
  });

  AttractionsBloc build() => AttractionsBloc(getAttractions: getAttractions);

  blocTest<AttractionsBloc, AttractionsState>(
    'carga los atractivos y los deja sin filtrar',
    build: build,
    act: (bloc) => bloc.add(const LoadAttractions()),
    expect: () => [
      isA<AttractionsLoading>(),
      isA<AttractionsLoaded>()
          .having((s) => s.all, 'all', attractions)
          .having((s) => s.filtered, 'filtered', attractions)
          .having((s) => s.activeFilter, 'activeFilter', isNull),
    ],
  );

  blocTest<AttractionsBloc, AttractionsState>(
    'emite error cuando el usecase falla',
    setUp: () => when(() => getAttractions(any()))
        .thenAnswer((_) async => const Left(CacheFailure('sin datos'))),
    build: build,
    act: (bloc) => bloc.add(const LoadAttractions()),
    expect: () => [
      isA<AttractionsLoading>(),
      isA<AttractionsError>().having((s) => s.message, 'message', 'sin datos'),
    ],
  );

  blocTest<AttractionsBloc, AttractionsState>(
    'filtrar por categoria conserva el orden y la lista completa',
    build: build,
    act: (bloc) => bloc
      ..add(const LoadAttractions())
      ..add(const FilterAttractions(AttractionCategory.religious)),
    skip: 2,
    expect: () => [
      isA<AttractionsLoaded>()
          .having(
            (s) => s.filtered.map((a) => a.id).toList(),
            'filtered',
            ['santuario-nino-isinche', 'iglesia-matriz'],
          )
          .having((s) => s.all, 'all', attractions)
          .having(
            (s) => s.activeFilter,
            'activeFilter',
            AttractionCategory.religious,
          ),
    ],
  );

  blocTest<AttractionsBloc, AttractionsState>(
    'una categoria sin atractivos deja la lista filtrada vacia',
    build: build,
    act: (bloc) => bloc
      ..add(const LoadAttractions())
      ..add(const FilterAttractions(AttractionCategory.crafts)),
    skip: 2,
    expect: () => [
      isA<AttractionsLoaded>()
          .having((s) => s.filtered, 'filtered', isEmpty)
          .having((s) => s.all, 'all', attractions),
    ],
  );

  blocTest<AttractionsBloc, AttractionsState>(
    'quitar el filtro restaura la lista completa',
    build: build,
    act: (bloc) => bloc
      ..add(const LoadAttractions())
      ..add(const FilterAttractions(AttractionCategory.nature))
      ..add(const FilterAttractions(null)),
    skip: 3,
    expect: () => [
      isA<AttractionsLoaded>()
          .having((s) => s.filtered, 'filtered', attractions)
          .having((s) => s.activeFilter, 'activeFilter', isNull),
    ],
  );

  blocTest<AttractionsBloc, AttractionsState>(
    'filtrar antes de cargar no hace nada',
    build: build,
    act: (bloc) =>
        bloc.add(const FilterAttractions(AttractionCategory.religious)),
    expect: () => <AttractionsState>[],
  );
}
