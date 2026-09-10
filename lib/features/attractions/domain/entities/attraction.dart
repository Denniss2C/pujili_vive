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
  final LocalizedText schedule;
  final LocalizedText cost;
  final LocalizedText location;
  final List<String> images;

  const Attraction({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.category,
    required this.latitude,
    required this.longitude,
    required this.schedule,
    required this.cost,
    required this.location,
    required this.images,
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
