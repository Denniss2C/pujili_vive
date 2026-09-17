import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pujili_vive/core/error/failures.dart';
import 'package:pujili_vive/core/usecases/usecase.dart';
import 'package:pujili_vive/features/calendar/domain/entities/festival_event.dart';
import 'package:pujili_vive/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:pujili_vive/features/calendar/domain/usecases/get_festival_events.dart';

import '../../../../helpers/fixtures/festival_event_fixtures.dart';

class _MockCalendarRepository extends Mock implements CalendarRepository {}

void main() {
  late _MockCalendarRepository repository;
  late GetFestivalEvents usecase;

  setUp(() {
    repository = _MockCalendarRepository();
    usecase = GetFestivalEvents(repository);
  });

  test('devuelve las fiestas ordenadas por fecha ascendente', () async {
    // El repositorio las entrega desordenadas a proposito: ordenar es
    // responsabilidad del usecase, porque la pantalla agrupa por mes
    // recorriendo la lista una sola vez.
    when(() => repository.getFestivalEvents()).thenAnswer(
      (_) async => Right([sanLorenzo, corpusChristi, virgenDelCarmen]),
    );

    final result = await usecase(NoParams());

    final events = result.getOrElse(() => <FestivalEvent>[]);
    expect(
      events.map((e) => e.id).toList(),
      ['corpus-christi-danzantes', 'virgen-del-carmen', 'san-lorenzo'],
    );
  });

  test('no altera la lista original del repositorio', () async {
    final original = [sanLorenzo, corpusChristi];
    when(() => repository.getFestivalEvents())
        .thenAnswer((_) async => Right(original));

    await usecase(NoParams());

    expect(original.first.id, 'san-lorenzo');
  });

  test('propaga el fallo cuando el repositorio falla', () async {
    when(() => repository.getFestivalEvents())
        .thenAnswer((_) async => const Left(CacheFailure('sin datos')));

    final result = await usecase(NoParams());

    expect(
      result,
      const Left<Failure, List<FestivalEvent>>(CacheFailure('sin datos')),
    );
  });
}
