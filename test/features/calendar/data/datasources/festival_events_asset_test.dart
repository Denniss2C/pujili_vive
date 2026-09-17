import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pujili_vive/features/calendar/data/models/festival_event_model.dart';

/// Valida el asset REAL que se empaqueta en la app.
///
/// Los demas tests usan JSON de prueba, asi que una errata en
/// `festival_events.json` pasaria inadvertida hasta ejecutar la app. Aqui
/// se lee el archivo de disco y se mete por el mismo `fromJson` que usa
/// el datasource.
void main() {
  final file = File('assets/data/festival_events.json');

  test('el asset existe y es una lista JSON valida', () {
    expect(file.existsSync(), isTrue, reason: 'falta ${file.path}');
    expect(json.decode(file.readAsStringSync()), isA<List<dynamic>>());
  });

  test('cada fiesta del asset se parsea sin reventar', () {
    final decoded = json.decode(file.readAsStringSync()) as List<dynamic>;
    final events = decoded
        .map((e) => FestivalEventModel.fromJson(e as Map<String, dynamic>))
        .toList();

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
    final decoded = json.decode(file.readAsStringSync()) as List<dynamic>;
    final ids = decoded.map((e) => (e as Map<String, dynamic>)['id']).toList();

    expect(ids.toSet().length, ids.length, reason: 'hay ids repetidos');
  });

  test('el Corpus Christi cae en jueves', () {
    // Corpus Christi es fiesta movil: 60 dias despues de la Pascua, y eso
    // siempre es jueves. Si alguien edita la fecha a mano y se equivoca,
    // este test lo caza. Ver pregunta abierta 19 en docs/CONCEPTO.md.
    final decoded = json.decode(file.readAsStringSync()) as List<dynamic>;
    final corpus = decoded
        .cast<Map<String, dynamic>>()
        .firstWhere((e) => e['id'] == 'corpus-christi-danzantes');

    final date = DateTime.parse(corpus['startDate'] as String);

    expect(date.weekday, DateTime.thursday);
  });
}
