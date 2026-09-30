import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';

abstract class FavoritesLocalDataSource {
  Future<List<String>> getKeys();

  Future<void> saveKeys(List<String> keys);
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  /// Inyectable para poder testear sin el plugin de plataforma.
  final Future<SharedPreferences> Function() _prefs;

  FavoritesLocalDataSourceImpl({
    Future<SharedPreferences> Function()? prefs,
  }) : _prefs = prefs ?? SharedPreferences.getInstance;

  static const _key = 'favorites.keys';

  @override
  Future<List<String>> getKeys() async {
    try {
      return (await _prefs()).getStringList(_key) ?? const [];
    } catch (e) {
      throw CacheException('No se pudieron leer los guardados: $e');
    }
  }

  @override
  Future<void> saveKeys(List<String> keys) async {
    try {
      final prefs = await _prefs();
      // Sin guardados se borra la clave en vez de dejar una lista vacia:
      // asi no queda basura en las preferencias.
      if (keys.isEmpty) {
        await prefs.remove(_key);
      } else {
        await prefs.setStringList(_key, keys);
      }
    } catch (e) {
      throw CacheException('No se pudieron guardar los favoritos: $e');
    }
  }
}
