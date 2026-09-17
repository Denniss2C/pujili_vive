import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pujili_vive/features/attractions/data/models/attraction_model.dart';

/// Valida el asset REAL de atractivos y, sobre todo, que las fotos a las
/// que apunta **existan en disco**.
///
/// Hasta ahora el JSON referenciaba archivos que no estaban (isinche_1.jpg
/// y compañia) y no se notaba: `Image.asset` cae a su `errorBuilder` y
/// pinta un icono, asi que la app parecia funcionar. Este test convierte
/// ese fallo silencioso en rojo.
void main() {
  final file = File('assets/data/attractions.json');

  List<Map<String, dynamic>> leer() {
    final decoded = json.decode(file.readAsStringSync()) as List<dynamic>;
    return decoded.cast<Map<String, dynamic>>();
  }

  test('el asset existe y cada atractivo se parsea', () {
    expect(file.existsSync(), isTrue, reason: 'falta ${file.path}');

    final attractions = leer().map(AttractionModel.fromJson).toList();

    expect(attractions, isNotEmpty);
    for (final a in attractions) {
      expect(a.id, isNotEmpty);
      expect(a.name.es, isNotEmpty);
      expect(a.name.en, isNotEmpty, reason: '${a.id} sin ingles');
    }
  });

  test('los ids son unicos', () {
    final ids = leer().map((e) => e['id']).toList();
    expect(ids.toSet().length, ids.length, reason: 'hay ids repetidos');
  });

  test('todas las fotos referenciadas existen en disco', () {
    final faltantes = <String>[];

    for (final raw in leer()) {
      final images = (raw['images'] as List<dynamic>).cast<String>();
      for (final path in images) {
        if (!File(path).existsSync()) {
          faltantes.add('${raw['id']} -> $path');
        }
      }
    }

    expect(faltantes, isEmpty, reason: 'fotos que no existen: $faltantes');
  });

  test('las fotos estan declaradas dentro de assets/images/', () {
    // Si alguien las mete en otra carpeta, el pubspec no las empaqueta y
    // fallan solo en el dispositivo, nunca en los tests.
    for (final raw in leer()) {
      final images = (raw['images'] as List<dynamic>).cast<String>();
      for (final path in images) {
        expect(
          path.startsWith('assets/images/'),
          isTrue,
          reason: '${raw['id']}: $path esta fuera de assets/images/',
        );
      }
    }
  });
}
