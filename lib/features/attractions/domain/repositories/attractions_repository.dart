import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/attraction.dart';

abstract class AttractionsRepository {
  Future<Either<Failure, List<Attraction>>> getAttractions();
}
