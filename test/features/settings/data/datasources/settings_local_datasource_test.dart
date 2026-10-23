import 'package:flutter_test/flutter_test.dart';
import 'package:pujili_vive/core/error/exceptions.dart';
import 'package:pujili_vive/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _key = 'settings.languageCode';

void main() {
  late SettingsLocalDataSourceImpl dataSource;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    dataSource = SettingsLocalDataSourceImpl();
  });

  test('sin preferencia guardada devuelve null', () async {
    expect(await dataSource.getLanguageCode(), isNull);
  });

  test('se vuelve a leer el idioma que se guardo', () async {
    await dataSource.saveLanguageCode('en');

    expect(await dataSource.getLanguageCode(), 'en');
  });

  test('guardar null borra la clave en vez de guardar un centinela', () async {
    await dataSource.saveLanguageCode('en');
    await dataSource.saveLanguageCode(null);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.containsKey(_key), isFalse);
    expect(await dataSource.getLanguageCode(), isNull);
  });

  group('si las preferencias no estan disponibles', () {
    setUp(() {
      dataSource = SettingsLocalDataSourceImpl(
        prefs: () async => throw Exception('plugin ausente'),
      );
    });

    test('leer lanza CacheException', () {
      expect(dataSource.getLanguageCode(), throwsA(isA<CacheException>()));
    });

    test('guardar lanza CacheException', () {
      expect(
        dataSource.saveLanguageCode('es'),
        throwsA(isA<CacheException>()),
      );
    });
  });
}
