import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

/// Preferencias del usuario que sobreviven al cierre de la app.
///
/// El idioma se guarda como codigo (`'es'`, `'en'`) y **`null` significa
/// "el del telefono"**, que es el valor por defecto: la app arranca en el
/// idioma del sistema mientras nadie elija otro.
abstract class SettingsRepository {
  Future<Either<Failure, String?>> getLanguageCode();

  Future<Either<Failure, Unit>> saveLanguageCode(String? code);
}
