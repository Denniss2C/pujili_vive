import '../../main.dart' as entrypoint;
import 'flavor_config.dart';

/// Entrypoint del ambiente DEV. Compilar/correr con:
///   flutter run --flavor dev -t lib/core/flavors/main_dev.dart
Future<void> main() async {
  FlavorConfig.init(Flavor.dev);
  await entrypoint.main();
}
