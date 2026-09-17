part of 'calendar_bloc.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object?> get props => [];
}

class CalendarInitial extends CalendarState {}

class CalendarLoading extends CalendarState {}

class CalendarLoaded extends CalendarState {
  /// Todas las fiestas, ya ordenadas por fecha.
  final List<FestivalEvent> all;

  /// Lo que se pinta: `all` si no hay busqueda activa.
  final List<FestivalEvent> filtered;

  /// Texto buscado. Vacio = sin filtro.
  final String query;

  const CalendarLoaded({
    required this.all,
    required this.filtered,
    this.query = '',
  });

  /// Distingue "no hay fiestas cargadas" de "la busqueda no encontro nada".
  /// Son dos estados vacios distintos y la pantalla los explica distinto.
  bool get isEmptySearch => filtered.isEmpty && query.isNotEmpty;

  @override
  List<Object?> get props => [all, filtered, query];
}

class CalendarError extends CalendarState {
  final String message;
  const CalendarError(this.message);

  @override
  List<Object?> get props => [message];
}
