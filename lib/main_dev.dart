import 'core/flavors/flavor_config.dart';
import 'main.dart' as entrypoint;

/// Entrypoint del ambiente DEV. Compilar/correr con:
///   flutter run --flavor dev -t lib/main_dev.dart
Future<void> main() async {
  FlavorConfig.init(Flavor.dev);
  await entrypoint.main();
}
