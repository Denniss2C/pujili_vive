import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/attraction.dart';
import '../repositories/attractions_repository.dart';

class GetAttractions implements UseCase<List<Attraction>, NoParams> {
  final AttractionsRepository repository;

  GetAttractions(this.repository);

  @override
  Future<Either<Failure, List<Attraction>>> call(NoParams params) {
    return repository.getAttractions();
  }
}
