import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_datasource.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, String?>> getLanguageCode() async {
    try {
      return Right(await localDataSource.getLanguageCode());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveLanguageCode(String? code) async {
    try {
      await localDataSource.saveLanguageCode(code);
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
