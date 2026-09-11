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
    required super.schedule,
    required super.cost,
    required super.location,
    required super.images,
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
      schedule:
          LocalizedText.fromJson(json['schedule'] as Map<String, dynamic>),
      cost: LocalizedText.fromJson(json['cost'] as Map<String, dynamic>),
      location:
          LocalizedText.fromJson(json['location'] as Map<String, dynamic>),
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
    );
  }
}
