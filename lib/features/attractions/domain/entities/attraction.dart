import 'package:equatable/equatable.dart';
import '../../../../core/constants/localized_text.dart';
import 'attraction_category.dart';

class Attraction extends Equatable {
  final String id;
  final LocalizedText name;
  final LocalizedText shortDescription;
  final AttractionCategory category;
  final double latitude;
  final double longitude;

  /// Opcional: no todo atractivo tiene horario (un mirador no lo tiene).
  /// Si falta, el detalle oculta esa columna en vez de escribir
  /// "No disponible" (docs/CONCEPTO.md §4.3).
  final LocalizedText? schedule;

  /// Opcional, en USD. "Entrada libre" es un valor valido, no una ausencia.
  final LocalizedText? cost;
  final LocalizedText location;
  final List<String> images;

  const Attraction({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.category,
    required this.latitude,
    required this.longitude,
    required this.location,
    required this.images,
    this.schedule,
    this.cost,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        shortDescription,
        category,
        latitude,
        longitude,
        schedule,
        cost,
        location,
        images,
      ];
}
