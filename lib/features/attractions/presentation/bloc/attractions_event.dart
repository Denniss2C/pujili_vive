part of 'attractions_bloc.dart';

abstract class AttractionsEvent extends Equatable {
  const AttractionsEvent();

  @override
  List<Object?> get props => [];
}

class LoadAttractions extends AttractionsEvent {
  const LoadAttractions();
}

class FilterAttractions extends AttractionsEvent {
  final AttractionCategory? category;
  const FilterAttractions(this.category);

  @override
  List<Object?> get props => [category];
}
