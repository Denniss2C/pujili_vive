import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/attraction.dart';
import '../../domain/entities/attraction_category.dart';
import '../../domain/usecases/get_attractions.dart';

part 'attractions_event.dart';
part 'attractions_state.dart';

class AttractionsBloc extends Bloc<AttractionsEvent, AttractionsState> {
  final GetAttractions getAttractions;

  AttractionsBloc({required this.getAttractions})
      : super(AttractionsInitial()) {
    on<LoadAttractions>(_onLoad);
    on<FilterAttractions>(_onFilter);
  }

  Future<void> _onLoad(
    LoadAttractions event,
    Emitter<AttractionsState> emit,
  ) async {
    emit(AttractionsLoading());
    final result = await getAttractions(NoParams());
    result.fold(
      (failure) => emit(AttractionsError(failure.message)),
      (attractions) => emit(
        AttractionsLoaded(all: attractions, filtered: attractions),
      ),
    );
  }

  void _onFilter(
    FilterAttractions event,
    Emitter<AttractionsState> emit,
  ) {
    final current = state;
    if (current is! AttractionsLoaded) return;

    final filtered = event.category == null
        ? current.all
        : current.all.where((a) => a.category == event.category).toList();

    emit(
      AttractionsLoaded(
        all: current.all,
        filtered: filtered,
        activeFilter: event.category,
      ),
    );
  }
}
