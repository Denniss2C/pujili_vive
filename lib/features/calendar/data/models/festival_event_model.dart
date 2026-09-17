import '../../../../core/constants/localized_text.dart';
import '../../domain/entities/festival_event.dart';

class FestivalEventModel extends FestivalEvent {
  const FestivalEventModel({
    required super.id,
    required super.title,
    required super.shortDescription,
    required super.startDate,
    required super.isHighlighted,
    required super.images,
    super.endDate,
    super.location,
  });

  factory FestivalEventModel.fromJson(Map<String, dynamic> json) {
    return FestivalEventModel(
      id: json['id'] as String,
      title: LocalizedText.fromJson(json['title'] as Map<String, dynamic>),
      shortDescription: LocalizedText.fromJson(
        json['shortDescription'] as Map<String, dynamic>,
      ),
      // Las fechas vienen en ISO-8601 (YYYY-MM-DD). Se parsean aqui para
      // que el resto de la app trabaje con DateTime y no con cadenas.
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      isHighlighted: json['isHighlighted'] as bool? ?? false,
      location: json['location'] == null
          ? null
          : LocalizedText.fromJson(json['location'] as Map<String, dynamic>),
      images: (json['images'] as List<dynamic>? ?? const [])
          .map((e) => e as String)
          .toList(),
    );
  }
}
