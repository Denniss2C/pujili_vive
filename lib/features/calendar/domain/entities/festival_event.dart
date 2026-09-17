import 'package:equatable/equatable.dart';
import '../../../../core/constants/localized_text.dart';

/// Una fiesta del cantón.
///
/// El calendario de fiestas es el diferenciador del producto
/// (ver `docs/CONCEPTO.md` §8), así que esta entidad es el núcleo del MVP.
///
/// Los nombres de campo siguen la convención de [Attraction], que es la
/// plantilla arquitectónica del proyecto: `shortDescription` y `location`
/// en vez de los `description` / `locationLabel` que propone el concepto.
class FestivalEvent extends Equatable {
  final String id;
  final LocalizedText title;
  final LocalizedText shortDescription;

  /// Día en que empieza la fiesta.
  ///
  /// Ojo: el Corpus Christi es **fiesta móvil** y su fecha depende de la
  /// Pascua, así que este dato no se puede fijar una vez y olvidarse.
  /// Cómo se mantiene sigue sin decidirse (`CONCEPTO.md` §9, pregunta 19).
  final DateTime startDate;

  /// Solo para fiestas de varios días. `null` si dura uno.
  final DateTime? endDate;

  /// Cambia el tratamiento visual de la tarjeta, no su orden.
  /// Hoy solo el Corpus Christi y su Octava.
  final bool isHighlighted;

  /// Dónde ocurre. Opcional: no toda fiesta tiene un sitio único.
  final LocalizedText? location;

  /// La primera es la de portada. Puede venir vacía.
  final List<String> images;

  const FestivalEvent({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.startDate,
    required this.isHighlighted,
    required this.images,
    this.endDate,
    this.location,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        shortDescription,
        startDate,
        endDate,
        isHighlighted,
        location,
        images,
      ];
}
