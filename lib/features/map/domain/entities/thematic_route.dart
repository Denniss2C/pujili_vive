import '../../../attractions/domain/entities/attraction.dart';
import '../../../attractions/domain/entities/attraction_category.dart';

/// Las rutas temáticas del mapa (`docs/CONCEPTO.md` §6.6).
///
/// Es Dart puro: no sabe nada de Google Maps ni de colores de pin. El
/// aspecto de los pines vive en `presentation`, que es quien dibuja.
///
/// **Por qué hay una cuarta opción que el diseño no dibuja.** El diseño
/// propone tres rutas —artesano, religiosa, natural— pero `Attraction`
/// tiene cuatro categorías, y dos de los seis atractivos son `cultural`
/// (la Plaza e Iglesia Matriz y la Feria Dominical). Con solo tres rutas
/// esos dos no aparecerían en ningún filtro: quedarían invisibles en el
/// mapa. [all] los rescata y además es el estado inicial, que es lo que
/// se espera al abrir un mapa.
///
/// Sigue abierto si una ruta es solo un filtro de pines o un recorrido
/// dibujado sobre el mapa (`docs/CONCEPTO.md` §9, pregunta 11). Aquí es
/// un filtro, que es lo único que el diseño resuelve; un recorrido
/// necesitaría datos propios y no un enumerado.
enum ThematicRoute {
  all(null),
  artisan(AttractionCategory.crafts),
  religious(AttractionCategory.religious),
  nature(AttractionCategory.nature);

  /// La categoría que deja pasar. `null` en [all]: no filtra nada.
  final AttractionCategory? category;

  const ThematicRoute(this.category);

  List<Attraction> filter(List<Attraction> places) {
    final wanted = category;
    if (wanted == null) return places;
    return places.where((p) => p.category == wanted).toList();
  }
}
