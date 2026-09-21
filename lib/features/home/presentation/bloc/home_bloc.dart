import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../attractions/domain/entities/attraction.dart';
import '../../../attractions/domain/usecases/get_attractions.dart';
import '../../../calendar/domain/entities/festival_event.dart';
import '../../../calendar/domain/usecases/get_festival_events.dart';

part 'home_event.dart';
part 'home_state.dart';

/// Inicio no tiene datos propios: es el escaparate de las otras features
/// (`docs/CONCEPTO.md` §8, prioridad 2). Por eso reutiliza los usecases de
/// `calendar` y `attractions` en vez de montar su propia capa de datos.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetFestivalEvents getFestivalEvents;
  final GetAttractions getAttractions;

  /// Inyectable para poder fijar "ahora" en los tests: de que fiestas son
  /// futuras depende toda la pantalla.
  final DateTime Function() now;

  HomeBloc({
    required this.getFestivalEvents,
    required this.getAttractions,
    DateTime Function()? now,
  })  : now = now ?? DateTime.now,
        super(HomeInitial()) {
    on<LoadHome>(_onLoad);
  }

  Future<void> _onLoad(LoadHome event, Emitter<HomeState> emit) async {
    emit(HomeLoading());

    // Las dos secciones se cargan a la vez y **fallan por separado**: si
    // el calendario revienta, "Que visitar" sigue en pie. El concepto lo
    // pide explicito: el error va dentro de la seccion afectada, no tumba
    // la pantalla entera.
    final results = await Future.wait([
      getFestivalEvents(NoParams()),
      getAttractions(NoParams()),
    ]);

    final eventsResult = results[0];
    final attractionsResult = results[1];

    emit(
      HomeLoaded(
        upcomingEvents: eventsResult.fold(
          (_) => const [],
          (events) => _upcoming(events.cast<FestivalEvent>()),
        ),
        eventsFailed: eventsResult.isLeft(),
        attractions: attractionsResult.fold(
          (_) => const [],
          (items) => items.cast<Attraction>(),
        ),
        attractionsFailed: attractionsResult.isLeft(),
      ),
    );
  }

  /// Solo las fiestas que **no han terminado**.
  ///
  /// Antes se comparaba contra el dia, porque las fiestas no tenian hora
  /// y una seguia siendo "hoy" a las once de la noche. Ahora hay dos al
  /// dia con hora de inicio y fin, asi que mantener la de la mañana
  /// cuando ya es de noche ponia el contador en ceros y llamaba "proximo
  /// evento" a algo que ya habia acabado.
  ///
  /// La que esta ocurriendo **si** se queda: es la mas relevante de
  /// todas, y la tarjeta lo dice en vez de contar hacia atras.
  List<FestivalEvent> _upcoming(List<FestivalEvent> events) {
    final instant = now();
    return events.where((e) => !e.endsAt.isBefore(instant)).toList();
  }
}
