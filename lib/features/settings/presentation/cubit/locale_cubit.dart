import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_language_code.dart';
import '../../domain/usecases/save_language_code.dart';

/// El idioma elegido, o `null` para seguir el del telefono.
///
/// Es un `Cubit<Locale?>` y no un bloc con estados porque **no tiene
/// estados**: o hay un idioma elegido o no lo hay. No hay carga que
/// mostrar —se resuelve antes de pintar la app— ni error que enseñar: si
/// las preferencias fallan, la app se queda con el idioma del sistema,
/// que es exactamente el valor por defecto.
class LocaleCubit extends Cubit<Locale?> {
  final GetLanguageCode getLanguageCode;
  final SaveLanguageCode saveLanguageCode;

  LocaleCubit({
    required this.getLanguageCode,
    required this.saveLanguageCode,
  }) : super(null);

  /// Lee la preferencia guardada. Se llama una vez, al arrancar.
  Future<void> load() async {
    final result = await getLanguageCode(NoParams());
    // Un fallo al leer no se propaga: sin preferencia, manda el sistema.
    result.fold((_) => emit(null), (code) => emit(_toLocale(code)));
  }

  /// Cambia el idioma y lo guarda. La UI se repinta con el nuevo valor
  /// aunque el guardado falle: negarle el cambio al usuario porque el
  /// disco no responde seria peor que perderlo al reiniciar.
  Future<void> change(String? code) async {
    emit(_toLocale(code));
    await saveLanguageCode(code);
  }

  static Locale? _toLocale(String? code) => code == null ? null : Locale(code);
}
