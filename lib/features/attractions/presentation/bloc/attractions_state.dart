part of 'attractions_bloc.dart';

abstract class AttractionsState extends Equatable {
  const AttractionsState();

  @override
  List<Object?> get props => [];
}

class AttractionsInitial extends AttractionsState {}

class AttractionsLoading extends AttractionsState {}

class AttractionsLoaded extends AttractionsState {
  final List<Attraction> all;
  final List<Attraction> filtered;
  final AttractionCategory? activeFilter;

  const AttractionsLoaded({
    required this.all,
    required this.filtered,
    this.activeFilter,
  });

  @override
  List<Object?> get props => [all, filtered, activeFilter];
}

class AttractionsError extends AttractionsState {
  final String message;
  const AttractionsError(this.message);

  @override
  List<Object?> get props => [message];
}
