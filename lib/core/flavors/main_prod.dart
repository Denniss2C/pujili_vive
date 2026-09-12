import '../../main.dart' as entrypoint;
import 'flavor_config.dart';

/// Entrypoint del ambiente PROD. Compilar/correr con:
///   flutter run --flavor prod -t lib/main_prod.dart
Future<void> main() async {
  FlavorConfig.init(Flavor.prod);
  await entrypoint.main();
}
