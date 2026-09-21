import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/settings_repository.dart';

/// Guarda el idioma elegido. `null` vuelve al idioma del telefono.
class SaveLanguageCode implements UseCase<Unit, String?> {
  final SettingsRepository repository;

  SaveLanguageCode(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String? params) {
    return repository.saveLanguageCode(params);
  }
}
