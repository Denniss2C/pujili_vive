import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Abre la app de mapas del telefono con indicaciones hasta un punto.
///
/// Es una interfaz y no una llamada directa a `url_launcher` para que las
/// pantallas no dependan de un plugin de plataforma: en los tests se
/// sustituye por un doble y no hace falta un dispositivo.
abstract class MapsLauncher {
  /// Devuelve `false` si el sistema no pudo abrir ninguna app.
  Future<bool> openDirections({
    required double latitude,
    required double longitude,
  });
}

class UrlMapsLauncher implements MapsLauncher {
  /// Inyectables para testear la eleccion de URL por plataforma.
  final TargetPlatform Function() _platform;
  final Future<bool> Function(Uri uri) _launch;

  UrlMapsLauncher({
    TargetPlatform Function()? platform,
    Future<bool> Function(Uri uri)? launch,
  })  : _platform = platform ?? (() => defaultTargetPlatform),
        _launch = launch ?? _launchExternally;

  @override
  Future<bool> openDirections({
    required double latitude,
    required double longitude,
  }) {
    return _launch(
      directionsUri(
        platform: _platform(),
        latitude: latitude,
        longitude: longitude,
      ),
    );
  }

  /// URL de indicaciones hasta el punto, segun la plataforma.
  ///
  /// - **iOS**: Apple Maps. Viene instalada en todos los iPhone, asi que
  ///   siempre abre una app nativa; Google Maps no esta garantizada.
  /// - **Resto**: la URL oficial de Google Maps. Abre la app si esta
  ///   instalada y el navegador si no, asi que nunca se queda sin destino.
  ///
  /// Ambas son `https`, no esquemas propios (`comgooglemaps://`): asi no
  /// hace falta declarar `LSApplicationQueriesSchemes` en iOS ni
  /// `<queries>` en Android.
  @visibleForTesting
  static Uri directionsUri({
    required TargetPlatform platform,
    required double latitude,
    required double longitude,
  }) {
    final destination = '$latitude,$longitude';
    if (platform == TargetPlatform.iOS) {
      return Uri.https('maps.apple.com', '/', {'daddr': destination});
    }
    return Uri.https('www.google.com', '/maps/dir/', {
      'api': '1',
      'destination': destination,
    });
  }

  static Future<bool> _launchExternally(Uri uri) async {
    try {
      // externalApplication: que la abra la app de mapas, no un webview
      // dentro de la nuestra.
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      // launchUrl lanza PlatformException si no hay nada que la abra.
      return false;
    }
  }
}
