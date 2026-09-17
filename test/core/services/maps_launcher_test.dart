import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pujili_vive/core/services/maps_launcher.dart';

void main() {
  group('directionsUri', () {
    test('en iOS usa Apple Maps, que viene en todos los iPhone', () {
      final uri = UrlMapsLauncher.directionsUri(
        platform: TargetPlatform.iOS,
        latitude: -0.9667,
        longitude: -78.7,
      );

      expect(uri.host, 'maps.apple.com');
      expect(uri.queryParameters['daddr'], '-0.9667,-78.7');
    });

    test('en Android usa la URL oficial de indicaciones de Google Maps', () {
      final uri = UrlMapsLauncher.directionsUri(
        platform: TargetPlatform.android,
        latitude: -0.9667,
        longitude: -78.7,
      );

      expect(uri.host, 'www.google.com');
      expect(uri.path, '/maps/dir/');
      expect(uri.queryParameters['api'], '1');
      expect(uri.queryParameters['destination'], '-0.9667,-78.7');
    });

    test('siempre es https, nunca un esquema propio', () {
      // Un esquema como comgooglemaps:// obligaria a declararlo en el
      // Info.plist y en el AndroidManifest para poder abrirlo.
      for (final platform in TargetPlatform.values) {
        final uri = UrlMapsLauncher.directionsUri(
          platform: platform,
          latitude: 1,
          longitude: 2,
        );
        expect(uri.scheme, 'https', reason: '$platform');
      }
    });
  });

  test('openDirections lanza la URL de la plataforma activa', () async {
    Uri? lanzada;
    final launcher = UrlMapsLauncher(
      platform: () => TargetPlatform.iOS,
      launch: (uri) async {
        lanzada = uri;
        return true;
      },
    );

    final ok =
        await launcher.openDirections(latitude: -0.9667, longitude: -78.7);

    expect(ok, isTrue);
    expect(lanzada?.host, 'maps.apple.com');
  });

  test('openDirections devuelve false si no hay app que la abra', () async {
    final launcher = UrlMapsLauncher(
      platform: () => TargetPlatform.android,
      launch: (_) async => false,
    );

    expect(
      await launcher.openDirections(latitude: 0, longitude: 0),
      isFalse,
    );
  });
}
