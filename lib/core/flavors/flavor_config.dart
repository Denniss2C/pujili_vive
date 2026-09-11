/// Ambiente de ejecución de la app.
///
/// Se selecciona en los entrypoints [main_dev.dart] / [main_prod.dart].
/// `main.dart` (sin flavor, p. ej. en tests) cae a [Flavor.prod].
enum Flavor { dev, prod }

/// Configuración por ambiente. Singleton perezoso: el primer
/// [FlavorConfig.init] fija el valor para toda la sesión.
class FlavorConfig {
  final Flavor flavor;
  final String name;
  final String appTitle;

  const FlavorConfig._(this.flavor, this.name, this.appTitle);

  static FlavorConfig? _instance;

  /// Inicializa el flavor. Llamar una sola vez, antes de `runApp`.
  factory FlavorConfig.init(Flavor flavor) {
    _instance ??= FlavorConfig._(
      flavor,
      flavor == Flavor.dev ? 'DEV' : 'PROD',
      flavor == Flavor.dev ? 'Pujilí Vive (Dev)' : 'Pujilí Vive',
    );
    return _instance!;
  }

  /// Config activa. Si nadie llamó a [FlavorConfig.init], usa prod.
  static FlavorConfig get instance =>
      _instance ??= const FlavorConfig._(Flavor.prod, 'PROD', 'Pujilí Vive');

  static bool get isDev => instance.flavor == Flavor.dev;
  static bool get isProd => instance.flavor == Flavor.prod;
}
