import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pujili_vive/core/theme/app_colors.dart';
import 'package:pujili_vive/features/attractions/domain/entities/attraction_category.dart';
import 'package:pujili_vive/features/map/presentation/pages/map_page.dart';

void main() {
  test('cada categoria tiene un color de pin distinto', () {
    // Si dos categorias compartieran color, el mapa mentiria: pines
    // distintos que parecen lo mismo.
    final colors = AttractionCategory.values.map(markerColorOf).toSet();

    expect(colors.length, AttractionCategory.values.length);
  });

  test('los pines usan la paleta del proyecto, no colores inventados', () {
    // Google imponia su catalogo de tonos (`BitmapDescriptor.hue*`). Al
    // pintar los pines nosotros, el mapa puede hablar el idioma visual
    // del resto de la app; este test evita que se deslice un color
    // suelto cuando se añada una categoria.
    // `Color` redefine `==`, asi que el Set no puede ser constante.
    final palette = <Color>{
      AppColors.terracotta,
      AppColors.gold,
      AppColors.deepGreen,
      AppColors.cream,
      AppColors.textDark,
    };

    for (final category in AttractionCategory.values) {
      expect(
        palette,
        contains(markerColorOf(category)),
        reason: '${category.name} pinta un color que no esta en AppColors',
      );
    }
  });

  test('el pin de artesania es el terracota del barro', () {
    // Ancla de significado: el color no es arbitrario, sigue al traje
    // del Danzante y al barro de los talleres.
    expect(markerColorOf(AttractionCategory.crafts), AppColors.terracotta);
  });
}
