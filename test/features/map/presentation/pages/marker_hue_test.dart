import 'package:flutter_test/flutter_test.dart';
import 'package:pujili_vive/features/attractions/domain/entities/attraction_category.dart';
import 'package:pujili_vive/features/map/presentation/pages/map_page.dart';

void main() {
  test('cada categoria tiene un color de pin distinto', () {
    // Si dos categorias compartieran color, el mapa mentiria: pines
    // distintos que parecen lo mismo.
    final hues = AttractionCategory.values.map(markerHueOf).toSet();

    expect(hues.length, AttractionCategory.values.length);
  });
}
