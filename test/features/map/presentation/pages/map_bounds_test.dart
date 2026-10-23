import 'package:flutter_test/flutter_test.dart';
import 'package:pujili_vive/features/map/presentation/pages/map_page.dart';

import '../../../../helpers/fixtures/attraction_fixtures.dart';

void main() {
  test('el rectangulo contiene todos los puntos', () {
    // El Quilotoa esta a ~25 km del casco urbano: si no se encuadra, un
    // zoom fijo sobre Pujili lo deja siempre fuera de pantalla.
    final bounds = boundsOf([
      buildAttraction(id: 'pujili', latitude: -0.9578, longitude: -78.6967),
      buildAttraction(id: 'quilotoa', latitude: -0.8583, longitude: -78.9061),
    ]);

    expect(bounds.southWest.latitude, -0.9578);
    expect(bounds.northEast.latitude, -0.8583);
    expect(bounds.southWest.longitude, -78.9061);
    expect(bounds.northEast.longitude, -78.6967);
  });

  test('con un solo lugar deja un margen, no un punto', () {
    // Un rectangulo de area cero haria que el mapa ampliara al maximo.
    final bounds = boundsOf([
      buildAttraction(latitude: -0.9578, longitude: -78.6967),
    ]);

    expect(
      bounds.northEast.latitude - bounds.southWest.latitude,
      closeTo(0.01, 1e-9),
    );
    expect(
      bounds.northEast.longitude - bounds.southWest.longitude,
      closeTo(0.01, 1e-9),
    );
  });
}
