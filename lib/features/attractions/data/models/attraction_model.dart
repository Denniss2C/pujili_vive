import '../../../../core/constants/localized_text.dart';
import '../../domain/entities/attraction.dart';
import '../../domain/entities/attraction_category.dart';

class AttractionModel extends Attraction {
  const AttractionModel({
    required super.id,
    required super.name,
    required super.shortDescription,
    required super.category,
    required super.latitude,
    required super.longitude,
    required super.location,
    required super.images,
    super.schedule,
    super.cost,
  });

  factory AttractionModel.fromJson(Map<String, dynamic> json) {
    return AttractionModel(
      id: json['id'] as String,
      name: LocalizedText.fromJson(json['name'] as Map<String, dynamic>),
      shortDescription: LocalizedText.fromJson(
        json['shortDescription'] as Map<String, dynamic>,
      ),
      category: AttractionCategory.fromString(json['category'] as String),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      schedule: _optionalText(json['schedule']),
      cost: _optionalText(json['cost']),
      location:
          LocalizedText.fromJson(json['location'] as Map<String, dynamic>),
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
    );
  }

  /// Un campo bilingue opcional. Ausente o `null` en el JSON -> `null`.
  static LocalizedText? _optionalText(Object? raw) {
    return raw == null
        ? null
        : LocalizedText.fromJson(raw as Map<String, dynamic>);
  }
}
