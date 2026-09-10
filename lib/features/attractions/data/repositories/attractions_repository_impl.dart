import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/attraction.dart';
import '../../domain/repositories/attractions_repository.dart';
import '../datasources/attractions_local_datasource.dart';

class AttractionsRepositoryImpl implements AttractionsRepository {
  final AttractionsLocalDataSource localDataSource;

  AttractionsRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Attraction>>> getAttractions() async {
    try {
      final result = await localDataSource.getAttractions();
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(DataFailure(e.toString()));
    }
  }
}
