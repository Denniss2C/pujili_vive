import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';

abstract class SettingsLocalDataSource {
  Future<String?> getLanguageCode();

  Future<void> saveLanguageCode(String? code);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  /// Inyectable para poder testear sin el plugin de plataforma.
  final Future<SharedPreferences> Function() _prefs;

  SettingsLocalDataSourceImpl({
    Future<SharedPreferences> Function()? prefs,
  }) : _prefs = prefs ?? SharedPreferences.getInstance;

  static const _key = 'settings.languageCode';

  @override
  Future<String?> getLanguageCode() async {
    try {
      return (await _prefs()).getString(_key);
    } catch (e) {
      throw CacheException('No se pudo leer el idioma guardado: $e');
    }
  }

  @override
  Future<void> saveLanguageCode(String? code) async {
    try {
      final prefs = await _prefs();
      // Quitar la clave y guardar "sistema" son lo mismo: asi no hay un
      // valor centinela que interpretar al leer.
      if (code == null) {
        await prefs.remove(_key);
      } else {
        await prefs.setString(_key, code);
      }
    } catch (e) {
      throw CacheException('No se pudo guardar el idioma: $e');
    }
  }
}
