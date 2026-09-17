import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/festival_event.dart';

abstract class CalendarRepository {
  Future<Either<Failure, List<FestivalEvent>>> getFestivalEvents();
}
