import 'package:flutter_test/flutter_test.dart';
import 'package:pujili_vive/core/error/exceptions.dart';
import 'package:pujili_vive/features/favorites/data/datasources/favorites_local_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _key = 'favorites.keys';

void main() {
  late FavoritesLocalDataSourceImpl dataSource;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    dataSource = FavoritesLocalDataSourceImpl();
  });

  test('sin nada guardado devuelve una lista vacia', () async {
    expect(await dataSource.getKeys(), isEmpty);
  });

  test('se vuelve a leer lo que se guardo, en el mismo orden', () async {
    await dataSource.saveKeys(['festival:corpus', 'attraction:quilotoa']);

    expect(
      await dataSource.getKeys(),
      ['festival:corpus', 'attraction:quilotoa'],
    );
  });

  test('guardar una lista vacia borra la clave', () async {
    await dataSource.saveKeys(['attraction:quilotoa']);
    await dataSource.saveKeys([]);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.containsKey(_key), isFalse);
  });

  group('si las preferencias no estan disponibles', () {
    setUp(() {
      dataSource = FavoritesLocalDataSourceImpl(
        prefs: () async => throw Exception('plugin ausente'),
      );
    });

    test('leer lanza CacheException', () {
      expect(dataSource.getKeys(), throwsA(isA<CacheException>()));
    });

    test('guardar lanza CacheException', () {
      expect(
        dataSource.saveKeys(['attraction:quilotoa']),
        throwsA(isA<CacheException>()),
      );
    });
  });
}
