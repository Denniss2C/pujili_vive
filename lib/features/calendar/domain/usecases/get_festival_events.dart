import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/festival_event.dart';
import '../repositories/calendar_repository.dart';

/// Devuelve las fiestas **ordenadas por fecha ascendente**.
///
/// El orden se garantiza aquí y no en la UI: la pantalla agrupa por mes
/// recorriendo la lista una sola vez, y eso solo funciona si ya viene
/// ordenada. Dejarlo al JSON seria confiar en que nadie edite mal el asset.
class GetFestivalEvents implements UseCase<List<FestivalEvent>, NoParams> {
  final CalendarRepository repository;

  GetFestivalEvents(this.repository);

  @override
  Future<Either<Failure, List<FestivalEvent>>> call(NoParams params) async {
    final result = await repository.getFestivalEvents();
    return result.map((events) {
      final sorted = [...events]
        ..sort((a, b) => a.startDate.compareTo(b.startDate));
      return sorted;
    });
  }
}
