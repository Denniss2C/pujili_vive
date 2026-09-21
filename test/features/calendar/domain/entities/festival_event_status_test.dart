import 'package:flutter_test/flutter_test.dart';
import 'package:pujili_vive/features/calendar/domain/entities/event_status.dart';

import '../../../../helpers/fixtures/festival_event_fixtures.dart';

void main() {
  // Una fiesta de 10:00 a 13:00.
  final fiesta = buildEvent(
    startDate: DateTime(2026, 9, 21, 10),
    endDate: DateTime(2026, 9, 21, 13),
  );

  test('antes de su hora todavia no ha empezado', () {
    expect(
      fiesta.statusAt(DateTime(2026, 9, 21, 9, 59)),
      EventStatus.upcoming,
    );
  });

  test('en el instante exacto de empezar ya esta en curso', () {
    // El limite importa: es el momento en que la tarjeta se pone blanca.
    expect(
      fiesta.statusAt(DateTime(2026, 9, 21, 10)),
      EventStatus.inProgress,
    );
  });

  test('mientras dura esta en curso', () {
    expect(
      fiesta.statusAt(DateTime(2026, 9, 21, 11, 30)),
      EventStatus.inProgress,
    );
  });

  test('en el instante exacto de acabar ya paso', () {
    // La tarjeta vuelve a simple en cuanto termina, no un minuto despues.
    expect(fiesta.statusAt(DateTime(2026, 9, 21, 13)), EventStatus.past);
  });

  test('despues de acabar ha pasado', () {
    expect(
      fiesta.statusAt(DateTime(2026, 9, 21, 13, 1)),
      EventStatus.past,
    );
  });

  test('el dia anterior y el siguiente caen a cada lado', () {
    expect(fiesta.statusAt(DateTime(2026, 9, 20)), EventStatus.upcoming);
    expect(fiesta.statusAt(DateTime(2026, 9, 22)), EventStatus.past);
  });

  group('sin hora de fin', () {
    // Era la semantica original, cuando las fiestas solo tenian fecha:
    // sin fin, la fiesta ocupa el dia entero.
    final todoElDia = buildEvent(startDate: DateTime(2026, 9, 21, 10));

    test('ocupa el dia entero, no termina al empezar', () {
      expect(
        todoElDia.statusAt(DateTime(2026, 9, 21, 23, 0)),
        EventStatus.inProgress,
      );
    });

    test('al dia siguiente ya paso', () {
      expect(
        todoElDia.statusAt(DateTime(2026, 9, 22, 0, 1)),
        EventStatus.past,
      );
    });

    test('endsAt es el final de su dia', () {
      expect(todoElDia.endsAt, DateTime(2026, 9, 21, 23, 59, 59));
    });
  });
}
