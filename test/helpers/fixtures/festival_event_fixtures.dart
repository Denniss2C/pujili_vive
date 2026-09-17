import 'package:pujili_vive/core/constants/localized_text.dart';
import 'package:pujili_vive/features/calendar/domain/entities/festival_event.dart';

/// Fiestas de prueba. Las fechas son deliberadamente desordenadas para
/// que los tests puedan comprobar que el orden lo garantiza el usecase.
FestivalEvent buildEvent({
  String id = 'test-event',
  String titleEs = 'Fiesta de prueba',
  String titleEn = 'Test festival',
  String descEs = 'Descripción de prueba',
  String descEn = 'Test description',
  DateTime? startDate,
  bool isHighlighted = false,
}) {
  return FestivalEvent(
    id: id,
    title: LocalizedText(es: titleEs, en: titleEn),
    shortDescription: LocalizedText(es: descEs, en: descEn),
    startDate: startDate ?? DateTime(2027, 5, 27),
    isHighlighted: isHighlighted,
    images: const [],
  );
}

final corpusChristi = buildEvent(
  id: 'corpus-christi-danzantes',
  titleEs: 'Corpus Christi: Danzantes de Pujilí',
  titleEn: 'Corpus Christi: Dancers of Pujilí',
  startDate: DateTime(2027, 5, 27),
  isHighlighted: true,
);

final sanLorenzo = buildEvent(
  id: 'san-lorenzo',
  titleEs: 'Fiesta de San Lorenzo',
  titleEn: 'Feast of Saint Lawrence',
  descEs: 'Desfile cívico y comparsas.',
  descEn: 'Civic parade and street troupes.',
  startDate: DateTime(2027, 8, 10),
);

final virgenDelCarmen = buildEvent(
  id: 'virgen-del-carmen',
  titleEs: 'Fiesta de la Virgen del Carmen',
  titleEn: 'Feast of the Virgin of Carmen',
  descEs: 'Feria gastronómica y artesanal.',
  descEn: 'Food and crafts fair.',
  startDate: DateTime(2027, 7, 16),
);
