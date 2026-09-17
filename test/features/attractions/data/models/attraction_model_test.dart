import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pujili_vive/features/attractions/data/models/attraction_model.dart';

void main() {
  Map<String, dynamic> base() => json.decode('''
  {
    "id": "mirador-cruz-calvario",
    "name": { "es": "Mirador Cruz del Calvario", "en": "Cruz del Calvario Viewpoint" },
    "shortDescription": { "es": "Vista del valle", "en": "Valley view" },
    "category": "cultural",
    "latitude": -0.95,
    "longitude": -78.69,
    "location": { "es": "Pujilí", "en": "Pujilí" },
    "images": []
  }
  ''') as Map<String, dynamic>;

  test('horario y costo son opcionales: ausentes en el JSON -> null', () {
    // Un mirador no tiene horario (docs/CONCEPTO.md §4.3). Antes de hacer
    // el campo opcional, el dato lo esquivaba con "Recomendado de dia".
    final model = AttractionModel.fromJson(base());

    expect(model.schedule, isNull);
    expect(model.cost, isNull);
  });

  test('tambien acepta null explicito', () {
    final model = AttractionModel.fromJson(
      base()
        ..['schedule'] = null
        ..['cost'] = null,
    );

    expect(model.schedule, isNull);
    expect(model.cost, isNull);
  });

  test('si vienen, se parsean bilingues', () {
    final model = AttractionModel.fromJson(
      base()
        ..['schedule'] = {'es': '8:00 - 16:00', 'en': '8:00 AM - 4:00 PM'}
        ..['cost'] = {'es': 'USD 2.00', 'en': 'USD 2.00'},
    );

    expect(model.schedule?.es, '8:00 - 16:00');
    expect(model.cost?.en, 'USD 2.00');
  });
}
