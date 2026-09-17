part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

/// No hay un `HomeError` global a proposito: cada seccion falla por su
/// cuenta y el resto de la pantalla sigue en pie.
class HomeLoaded extends HomeState {
  /// Fiestas que aun no han pasado, la primera es la mas proxima.
  final List<FestivalEvent> upcomingEvents;
  final bool eventsFailed;

  final List<Attraction> attractions;
  final bool attractionsFailed;

  const HomeLoaded({
    required this.upcomingEvents,
    required this.eventsFailed,
    required this.attractions,
    required this.attractionsFailed,
  });

  /// La fiesta del contador. `null` si no hay ninguna futura, y entonces
  /// la tarjeta **desaparece**: no se deja un contador en cero.
  FestivalEvent? get nextEvent =>
      upcomingEvents.isEmpty ? null : upcomingEvents.first;

  @override
  List<Object?> get props => [
        upcomingEvents,
        eventsFailed,
        attractions,
        attractionsFailed,
      ];
}
