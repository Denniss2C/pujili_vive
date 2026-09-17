import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pujili_vive/core/error/failures.dart';
import 'package:pujili_vive/core/usecases/usecase.dart';
import 'package:pujili_vive/features/attractions/domain/entities/attraction.dart';
import 'package:pujili_vive/features/attractions/domain/usecases/get_attractions.dart';
import 'package:pujili_vive/features/calendar/domain/entities/festival_event.dart';
import 'package:pujili_vive/features/calendar/domain/usecases/get_festival_events.dart';
import 'package:pujili_vive/features/home/presentation/bloc/home_bloc.dart';

import '../../../../helpers/fixtures/festival_event_fixtures.dart';

class _MockGetFestivalEvents extends Mock implements GetFestivalEvents {}

class _MockGetAttractions extends Mock implements GetAttractions {}

class _FakeNoParams extends Fake implements NoParams {}

void main() {
  late _MockGetFestivalEvents getFestivalEvents;
  late _MockGetAttractions getAttractions;

  // "Hoy" fijo: de que fiestas son futuras depende toda la pantalla, asi
  // que el test no puede depender del reloj de la maquina.
  final hoy = DateTime(2027, 6, 10);

  final pasada = buildEvent(id: 'pasada', startDate: DateTime(2027, 5, 27));
  final hoyMismo = buildEvent(id: 'hoy', startDate: DateTime(2027, 6, 10));
  final futura = buildEvent(id: 'futura', startDate: DateTime(2027, 8, 10));

  setUpAll(() => registerFallbackValue(_FakeNoParams()));

  setUp(() {
    getFestivalEvents = _MockGetFestivalEvents();
    getAttractions = _MockGetAttractions();
  });

  HomeBloc build() => HomeBloc(
        getFestivalEvents: getFestivalEvents,
        getAttractions: getAttractions,
        now: () => hoy,
      );

  void conEventos(List<FestivalEvent> events) {
    when(() => getFestivalEvents(any())).thenAnswer((_) async => Right(events));
  }

  void conAtractivos(List<Attraction> items) {
    when(() => getAttractions(any())).thenAnswer((_) async => Right(items));
  }

  blocTest<HomeBloc, HomeState>(
    'descarta las fiestas pasadas y conserva la de hoy',
    setUp: () {
      conEventos([pasada, hoyMismo, futura]);
      conAtractivos(const []);
    },
    build: build,
    act: (bloc) => bloc.add(const LoadHome()),
    expect: () => [
      isA<HomeLoading>(),
      isA<HomeLoaded>().having(
        (s) => s.upcomingEvents.map((e) => e.id).toList(),
        'upcoming',
        ['hoy', 'futura'],
      )
          // La mas proxima alimenta el contador.
          .having((s) => s.nextEvent?.id, 'nextEvent', 'hoy'),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'sin fiestas futuras, nextEvent es null y la tarjeta desaparece',
    setUp: () {
      conEventos([pasada]);
      conAtractivos(const []);
    },
    build: build,
    act: (bloc) => bloc.add(const LoadHome()),
    expect: () => [
      isA<HomeLoading>(),
      isA<HomeLoaded>()
          .having((s) => s.upcomingEvents, 'upcoming', isEmpty)
          .having((s) => s.nextEvent, 'nextEvent', isNull)
          .having((s) => s.eventsFailed, 'eventsFailed', isFalse),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'si fallan las fiestas, los atractivos siguen cargando',
    setUp: () {
      when(() => getFestivalEvents(any()))
          .thenAnswer((_) async => const Left(CacheFailure('sin datos')));
      conAtractivos(const []);
    },
    build: build,
    act: (bloc) => bloc.add(const LoadHome()),
    expect: () => [
      isA<HomeLoading>(),
      isA<HomeLoaded>()
          .having((s) => s.eventsFailed, 'eventsFailed', isTrue)
          .having((s) => s.attractionsFailed, 'attractionsFailed', isFalse),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'si fallan los atractivos, el contador sigue en pie',
    setUp: () {
      conEventos([futura]);
      when(() => getAttractions(any()))
          .thenAnswer((_) async => const Left(CacheFailure('sin datos')));
    },
    build: build,
    act: (bloc) => bloc.add(const LoadHome()),
    expect: () => [
      isA<HomeLoading>(),
      isA<HomeLoaded>()
          .having((s) => s.attractionsFailed, 'attractionsFailed', isTrue)
          .having((s) => s.nextEvent?.id, 'nextEvent', 'futura'),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'las dos secciones pueden fallar a la vez sin tumbar la pantalla',
    setUp: () {
      when(() => getFestivalEvents(any()))
          .thenAnswer((_) async => const Left(CacheFailure('sin datos')));
      when(() => getAttractions(any()))
          .thenAnswer((_) async => const Left(CacheFailure('sin datos')));
    },
    build: build,
    act: (bloc) => bloc.add(const LoadHome()),
    expect: () => [
      isA<HomeLoading>(),
      isA<HomeLoaded>()
          .having((s) => s.eventsFailed, 'eventsFailed', isTrue)
          .having((s) => s.attractionsFailed, 'attractionsFailed', isTrue),
    ],
  );
}
