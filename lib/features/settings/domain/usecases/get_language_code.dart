import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/settings_repository.dart';

class GetLanguageCode implements UseCase<String?, NoParams> {
  final SettingsRepository repository;

  GetLanguageCode(this.repository);

  @override
  Future<Either<Failure, String?>> call(NoParams params) {
    return repository.getLanguageCode();
  }
}
