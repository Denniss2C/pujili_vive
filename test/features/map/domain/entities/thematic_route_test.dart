import 'package:flutter_test/flutter_test.dart';
import 'package:pujili_vive/features/attractions/domain/entities/attraction_category.dart';
import 'package:pujili_vive/features/map/domain/entities/thematic_route.dart';

import '../../../../helpers/fixtures/attraction_fixtures.dart';

void main() {
  final plaza = buildAttraction(
    id: 'plaza',
    category: AttractionCategory.cultural,
  );
  final ceramica = buildAttraction(
    id: 'ceramica',
    category: AttractionCategory.crafts,
  );
  final isinche = buildAttraction(
    id: 'isinche',
    category: AttractionCategory.religious,
  );
  final quilotoa = buildAttraction(
    id: 'quilotoa',
    category: AttractionCategory.nature,
  );
  final todos = [plaza, ceramica, isinche, quilotoa];

  test('"Todas" no filtra nada', () {
    expect(ThematicRoute.all.filter(todos), todos);
  });

  test('cada ruta deja pasar solo su categoria', () {
    expect(ThematicRoute.artisan.filter(todos), [ceramica]);
    expect(ThematicRoute.religious.filter(todos), [isinche]);
    expect(ThematicRoute.nature.filter(todos), [quilotoa]);
  });

  test('los atractivos culturales solo se ven en "Todas"', () {
    // Es el motivo de que exista la cuarta opcion: el diseño dibuja tres
    // rutas y dos de los seis atractivos son culturales. Sin "Todas"
    // serian invisibles en el mapa.
    final enAlgunaRuta = ThematicRoute.values
        .where((r) => r != ThematicRoute.all)
        .expand((r) => r.filter(todos));

    expect(enAlgunaRuta.contains(plaza), isFalse);
    expect(ThematicRoute.all.filter(todos), contains(plaza));
  });
}
