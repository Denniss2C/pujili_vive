import 'package:flutter_test/flutter_test.dart';
import 'package:pujili_vive/features/favorites/domain/entities/favorite_ref.dart';

void main() {
  test('la clave lleva el tipo por delante', () {
    // Sin el tipo, un atractivo y una fiesta con el mismo id serian el
    // mismo guardado.
    expect(const FavoriteRef.attraction('isinche').key, 'attraction:isinche');
    expect(const FavoriteRef.festival('isinche').key, 'festival:isinche');
  });

  test('un atractivo y una fiesta con el mismo id son distintos', () {
    expect(
      const FavoriteRef.attraction('x'),
      isNot(const FavoriteRef.festival('x')),
    );
  });

  test('se vuelve a leer lo que se escribio', () {
    for (final ref in const [
      FavoriteRef.attraction('quilotoa'),
      FavoriteRef.festival('pregon-de-fiestas'),
    ]) {
      expect(FavoriteRef.tryParse(ref.key), ref);
    }
  });

  test('un id con dos puntos dentro sobrevive', () {
    // Solo se parte por el PRIMER separador; el resto es el id.
    final ref = FavoriteRef.tryParse('festival:corpus:2027');

    expect(ref?.kind, FavoriteKind.festival);
    expect(ref?.id, 'corpus:2027');
  });

  test('lo que no se entiende devuelve null, no revienta', () {
    // Puede venir de una version anterior con otro formato.
    for (final basura in ['', 'suelto', ':sinTipo', 'festival:', 'otro:x']) {
      expect(FavoriteRef.tryParse(basura), isNull, reason: basura);
    }
  });
}
