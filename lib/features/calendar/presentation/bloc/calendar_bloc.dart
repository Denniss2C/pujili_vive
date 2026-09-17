import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/localized_text.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/festival_event.dart';
import '../../domain/usecases/get_festival_events.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final GetFestivalEvents getFestivalEvents;

  CalendarBloc({required this.getFestivalEvents}) : super(CalendarInitial()) {
    on<LoadFestivalEvents>(_onLoad);
    on<SearchFestivalEvents>(_onSearch);
  }

  Future<void> _onLoad(
    LoadFestivalEvents event,
    Emitter<CalendarState> emit,
  ) async {
    emit(CalendarLoading());
    final result = await getFestivalEvents(NoParams());
    result.fold(
      (failure) => emit(CalendarError(failure.message)),
      (events) => emit(CalendarLoaded(all: events, filtered: events)),
    );
  }

  void _onSearch(
    SearchFestivalEvents event,
    Emitter<CalendarState> emit,
  ) {
    final current = state;
    if (current is! CalendarLoaded) return;

    final query = event.query.trim();
    if (query.isEmpty) {
      emit(CalendarLoaded(all: current.all, filtered: current.all));
      return;
    }

    // Se busca en los DOS idiomas a la vez, no solo en el activo: quien
    // escribe "Corpus" lo encuentra igual con la app en ingles, y evita
    // tener que pasarle el locale al bloc.
    final needle = _normalize(query);
    final filtered = current.all.where((e) {
      return _matches(e.title, needle) || _matches(e.shortDescription, needle);
    }).toList();

    emit(
      CalendarLoaded(all: current.all, filtered: filtered, query: query),
    );
  }

  bool _matches(LocalizedText text, String needle) {
    return _normalize(text.es).contains(needle) ||
        _normalize(text.en).contains(needle);
  }

  /// Minusculas y sin tildes, para que "Pujili" encuentre "Pujilí".
  static String _normalize(String value) {
    const accented = 'áàäâãéèëêíìïîóòöôõúùüûñç';
    const plain = 'aaaaaeeeeiiiiooooouuuunc';
    final buffer = StringBuffer();
    for (final rune in value.toLowerCase().runes) {
      final char = String.fromCharCode(rune);
      final index = accented.indexOf(char);
      buffer.write(index == -1 ? char : plain[index]);
    }
    return buffer.toString();
  }
}
