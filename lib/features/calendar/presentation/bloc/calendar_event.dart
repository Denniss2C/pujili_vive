part of 'calendar_bloc.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object?> get props => [];
}

class LoadFestivalEvents extends CalendarEvent {
  const LoadFestivalEvents();
}

class SearchFestivalEvents extends CalendarEvent {
  final String query;
  const SearchFestivalEvents(this.query);

  @override
  List<Object?> get props => [query];
}
