import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pujili_vive/features/calendar/data/models/festival_event_model.dart';
import 'package:pujili_vive/features/calendar/domain/entities/festival_event.dart';

/// Valida el asset REAL que se empaqueta en la app.
///
/// Los demas tests usan JSON de prueba, asi que una errata en
/// `festival_events.json` pasaria inadvertida hasta ejecutar la app. Aqui
/// se lee el archivo de disco y se mete por el mismo `fromJson` que usa
/// el datasource.
///
/// **Ninguna asercion depende de la fecha de hoy.** El asset es un
/// programa fijo y el tiempo pasa: un test que comprobara "hay fiestas
/// futuras" se pondria rojo solo con esperar, y eso es una alarma falsa
/// que nadie sabria interpretar dentro de seis meses.
void main() {
  final file = File('assets/data/festival_events.json');

  List<FestivalEventModel> readEvents() {
    final decoded = json.decode(file.readAsStringSync()) as List<dynamic>;
    return decoded
        .map((e) => FestivalEventModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  test('el asset existe y es una lista JSON valida', () {
    expect(file.existsSync(), isTrue, reason: 'falta ${file.path}');
    expect(json.decode(file.readAsStringSync()), isA<List<dynamic>>());
  });

  test('cada fiesta del asset se parsea sin reventar', () {
    final events = readEvents();

    expect(events, isNotEmpty);
    for (final event in events) {
      expect(event.id, isNotEmpty);
      expect(event.title.es, isNotEmpty);
      expect(event.title.en, isNotEmpty, reason: '${event.id} sin ingles');
      expect(event.shortDescription.es, isNotEmpty);
      expect(event.shortDescription.en, isNotEmpty);
    }
  });

  test('los ids son unicos', () {
    final ids = readEvents().map((e) => e.id).toList();

    expect(ids.toSet().length, ids.length, reason: 'hay ids repetidos');
  });

  test('toda fiesta tiene hora de inicio y de fin, y acaba despues', () {
    // De esto depende que la tarjeta se ponga blanca: sin hora de fin la
    // fiesta duraria el dia entero y el efecto en vivo se perderia.
    for (final event in readEvents()) {
      expect(
        event.endDate,
        isNotNull,
        reason: '${event.id} no tiene hora de fin',
      );
      expect(
        event.endDate!.isAfter(event.startDate),
        isTrue,
        reason: '${event.id} termina antes de empezar',
      );
    }
  });

  test('ninguna fiesta cruza la medianoche', () {
    // La linea de tiempo agrupa por dia; una que terminara al dia
    // siguiente apareceria bajo un dia y acabaria en otro.
    for (final event in readEvents()) {
      expect(
        event.endDate!.day,
        event.startDate.day,
        reason: '${event.id} empieza un dia y acaba en otro',
      );
    }
  });

  test('el programa es continuo y con dos fiestas por dia', () {
    final events = readEvents();
    final porDia = <DateTime, int>{};
    for (final event in events) {
      final dia = DateTime(
        event.startDate.year,
        event.startDate.month,
        event.startDate.day,
      );
      porDia[dia] = (porDia[dia] ?? 0) + 1;
    }

    final dias = porDia.keys.toList()..sort();

    for (final dia in dias) {
      expect(porDia[dia], 2, reason: 'el $dia no tiene dos fiestas');
    }

    // Sin huecos: un dia en blanco en mitad del programa es una errata.
    for (var i = 1; i < dias.length; i++) {
      expect(
        dias[i].difference(dias[i - 1]).inDays,
        1,
        reason: 'hay un salto entre ${dias[i - 1]} y ${dias[i]}',
      );
    }
  });

  test('las fiestas del dia no se solapan', () {
    final events = readEvents()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    for (var i = 1; i < events.length; i++) {
      final anterior = events[i - 1];
      final actual = events[i];
      if (anterior.startDate.day != actual.startDate.day) continue;

      expect(
        actual.startDate.isAfter(anterior.endDate!),
        isTrue,
        reason: '${actual.id} empieza antes de que acabe ${anterior.id}',
      );
    }
  });

  test('el Corpus Christi, si esta, cae en jueves', () {
    // Corpus Christi es fiesta movil: 60 dias despues de la Pascua, y eso
    // siempre es jueves. Hoy el asset es el programa simulado de las
    // fiestas cantonales y no lo incluye, pero el guardian se queda
    // armado para cuando vuelvan las fechas reales de junio. Ver la
    // pregunta abierta 19 en docs/CONCEPTO.md.
    final corpus = readEvents()
        .where((e) => e.id == 'corpus-christi-danzantes')
        .cast<FestivalEvent?>()
        .firstWhere((_) => true, orElse: () => null);

    if (corpus == null) return;

    expect(corpus.startDate.weekday, DateTime.thursday);
  });
}
