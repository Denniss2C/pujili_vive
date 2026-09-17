import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pujili_vive/core/error/failures.dart';
import 'package:pujili_vive/core/usecases/usecase.dart';
import 'package:pujili_vive/features/calendar/domain/usecases/get_festival_events.dart';
import 'package:pujili_vive/features/calendar/presentation/bloc/calendar_bloc.dart';

import '../../../../helpers/fixtures/festival_event_fixtures.dart';

class _MockGetFestivalEvents extends Mock implements GetFestivalEvents {}

class _FakeNoParams extends Fake implements NoParams {}

void main() {
  late _MockGetFestivalEvents getFestivalEvents;

  final events = [corpusChristi, virgenDelCarmen, sanLorenzo];

  setUpAll(() => registerFallbackValue(_FakeNoParams()));

  setUp(() => getFestivalEvents = _MockGetFestivalEvents());

  CalendarBloc build() => CalendarBloc(getFestivalEvents: getFestivalEvents);

  blocTest<CalendarBloc, CalendarState>(
    'carga las fiestas y las deja sin filtrar',
    setUp: () => when(() => getFestivalEvents(any()))
        .thenAnswer((_) async => Right(events)),
    build: build,
    act: (bloc) => bloc.add(const LoadFestivalEvents()),
    expect: () => [
      isA<CalendarLoading>(),
      isA<CalendarLoaded>()
          .having((s) => s.all, 'all', events)
          .having((s) => s.filtered, 'filtered', events)
          .having((s) => s.query, 'query', ''),
    ],
  );

  blocTest<CalendarBloc, CalendarState>(
    'emite error cuando el usecase falla',
    setUp: () => when(() => getFestivalEvents(any()))
        .thenAnswer((_) async => const Left(CacheFailure('sin datos'))),
    build: build,
    act: (bloc) => bloc.add(const LoadFestivalEvents()),
    expect: () => [
      isA<CalendarLoading>(),
      isA<CalendarError>().having((s) => s.message, 'message', 'sin datos'),
    ],
  );

  blocTest<CalendarBloc, CalendarState>(
    'la busqueda ignora tildes y mayusculas',
    setUp: () => when(() => getFestivalEvents(any()))
        .thenAnswer((_) async => Right(events)),
    build: build,
    act: (bloc) => bloc
      ..add(const LoadFestivalEvents())
      ..add(const SearchFestivalEvents('PUJILI')),
    skip: 2,
    expect: () => [
      isA<CalendarLoaded>().having(
        (s) => s.filtered.map((e) => e.id).toList(),
        'filtered',
        ['corpus-christi-danzantes'],
      ),
    ],
  );

  blocTest<CalendarBloc, CalendarState>(
    'la busqueda encuentra por el titulo en el otro idioma',
    setUp: () => when(() => getFestivalEvents(any()))
        .thenAnswer((_) async => Right(events)),
    build: build,
    act: (bloc) => bloc
      ..add(const LoadFestivalEvents())
      ..add(const SearchFestivalEvents('Lawrence')),
    skip: 2,
    expect: () => [
      isA<CalendarLoaded>().having(
        (s) => s.filtered.map((e) => e.id).toList(),
        'filtered',
        ['san-lorenzo'],
      ),
    ],
  );

  blocTest<CalendarBloc, CalendarState>(
    'una busqueda sin resultados se distingue de la lista vacia',
    setUp: () => when(() => getFestivalEvents(any()))
        .thenAnswer((_) async => Right(events)),
    build: build,
    act: (bloc) => bloc
      ..add(const LoadFestivalEvents())
      ..add(const SearchFestivalEvents('carnaval')),
    skip: 2,
    expect: () => [
      isA<CalendarLoaded>()
          .having((s) => s.filtered, 'filtered', isEmpty)
          .having((s) => s.isEmptySearch, 'isEmptySearch', isTrue),
    ],
  );

  blocTest<CalendarBloc, CalendarState>(
    'borrar la busqueda restaura la lista completa',
    setUp: () => when(() => getFestivalEvents(any()))
        .thenAnswer((_) async => Right(events)),
    build: build,
    act: (bloc) => bloc
      ..add(const LoadFestivalEvents())
      ..add(const SearchFestivalEvents('carnaval'))
      ..add(const SearchFestivalEvents('   ')),
    skip: 3,
    expect: () => [
      isA<CalendarLoaded>()
          .having((s) => s.filtered, 'filtered', events)
          .having((s) => s.isEmptySearch, 'isEmptySearch', isFalse),
    ],
  );

  blocTest<CalendarBloc, CalendarState>(
    'buscar antes de cargar no hace nada',
    build: build,
    act: (bloc) => bloc.add(const SearchFestivalEvents('corpus')),
    expect: () => <CalendarState>[],
  );
}
