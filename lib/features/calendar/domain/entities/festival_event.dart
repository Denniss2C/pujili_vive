import 'package:equatable/equatable.dart';
import '../../../../core/constants/localized_text.dart';
import 'event_status.dart';

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

  /// Cuándo empieza la fiesta, **con hora**.
  ///
  /// Ojo: el Corpus Christi es **fiesta móvil** y su fecha depende de la
  /// Pascua, así que este dato no se puede fijar una vez y olvidarse.
  /// Cómo se mantiene sigue sin decidirse (`CONCEPTO.md` §9, pregunta 19).
  final DateTime startDate;

  /// Cuándo termina. `null` significa que dura el día entero de
  /// [startDate], que era la semántica original cuando las fiestas solo
  /// tenían fecha; ver [statusAt].
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

  /// Cuándo acaba de verdad.
  ///
  /// Sin [endDate] la fiesta ocupa el día entero: es lo que significaba
  /// un evento sin fin cuando las fechas no llevaban hora, y es mejor
  /// que darlo por terminado en el instante en que empieza.
  DateTime get endsAt =>
      endDate ??
      DateTime(startDate.year, startDate.month, startDate.day, 23, 59, 59);

  /// En qué punto está la fiesta respecto a [now].
  ///
  /// El calendario lo recalcula con el reloj en marcha, así que una
  /// tarjeta pasa sola de [EventStatus.upcoming] a
  /// [EventStatus.inProgress] y de ahí a [EventStatus.past] sin que el
  /// usuario toque nada.
  EventStatus statusAt(DateTime now) {
    if (now.isBefore(startDate)) return EventStatus.upcoming;
    if (now.isBefore(endsAt)) return EventStatus.inProgress;
    return EventStatus.past;
  }

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
