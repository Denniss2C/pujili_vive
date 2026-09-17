import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pujili_vive/features/calendar/data/models/festival_event_model.dart';

void main() {
  const completo = '''
  {
    "id": "corpus-christi-danzantes",
    "title": { "es": "Corpus Christi", "en": "Corpus Christi" },
    "shortDescription": { "es": "La fiesta mayor", "en": "The main festival" },
    "startDate": "2027-05-27",
    "endDate": "2027-05-28",
    "isHighlighted": true,
    "location": { "es": "Plaza central", "en": "Main square" },
    "images": ["assets/images/danzante.jpg"]
  }
  ''';

  const minimo = '''
  {
    "id": "san-lorenzo",
    "title": { "es": "San Lorenzo", "en": "Saint Lawrence" },
    "shortDescription": { "es": "Desfile", "en": "Parade" },
    "startDate": "2027-08-10"
  }
  ''';

  test('parsea todos los campos y las fechas ISO', () {
    final model = FestivalEventModel.fromJson(
      json.decode(completo) as Map<String, dynamic>,
    );

    expect(model.id, 'corpus-christi-danzantes');
    expect(model.title.es, 'Corpus Christi');
    expect(model.startDate, DateTime(2027, 5, 27));
    expect(model.endDate, DateTime(2027, 5, 28));
    expect(model.isHighlighted, isTrue);
    expect(model.location?.en, 'Main square');
    expect(model.images, ['assets/images/danzante.jpg']);
  });

  test('tolera los campos opcionales ausentes', () {
    // Una fiesta de un solo dia, sin sitio fijo y sin foto todavia: es el
    // caso real de casi todo el dataset de hoy, asi que no puede reventar.
    final model = FestivalEventModel.fromJson(
      json.decode(minimo) as Map<String, dynamic>,
    );

    expect(model.endDate, isNull);
    expect(model.location, isNull);
    expect(model.images, isEmpty);
    expect(model.isHighlighted, isFalse);
  });
}
