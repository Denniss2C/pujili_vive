import 'core/flavors/flavor_config.dart';
import 'main.dart' as entrypoint;

/// Entrypoint del ambiente PROD. Compilar/correr con:
///   flutter run --flavor prod -t lib/main_prod.dart
Future<void> main() async {
  FlavorConfig.init(Flavor.prod);
  await entrypoint.main();
}
