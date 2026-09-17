import 'package:pujili_vive/core/constants/localized_text.dart';
import 'package:pujili_vive/features/attractions/domain/entities/attraction.dart';
import 'package:pujili_vive/features/attractions/domain/entities/attraction_category.dart';

const _sentinel = Object();

/// Atractivo de prueba. `schedule` y `cost` se pueden anular a proposito
/// para probar que el detalle oculta la columna.
Attraction buildAttraction({
  String id = 'santuario-nino-isinche',
  String nameEs = 'Santuario del Niño de Isinche',
  AttractionCategory category = AttractionCategory.religious,
  Object? schedule = _sentinel,
  Object? cost = _sentinel,
  List<String> images = const [],
  double latitude = -0.9667,
  double longitude = -78.7,
}) {
  return Attraction(
    id: id,
    name: LocalizedText(es: nameEs, en: 'Sanctuary of El Niño de Isinche'),
    shortDescription: const LocalizedText(
      es: 'Lugar sagrado de peregrinación.',
      en: 'Sacred pilgrimage site.',
    ),
    category: category,
    latitude: latitude,
    longitude: longitude,
    location: const LocalizedText(es: 'Isinche, Pujilí', en: 'Isinche, Pujilí'),
    images: images,
    schedule: identical(schedule, _sentinel)
        ? const LocalizedText(es: '9:00 - 18:00', en: '9:00 AM - 6:00 PM')
        : schedule as LocalizedText?,
    cost: identical(cost, _sentinel)
        ? const LocalizedText(es: 'Entrada libre', en: 'Free entry')
        : cost as LocalizedText?,
  );
}
