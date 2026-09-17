import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Configuracion global de tests: Flutter la aplica a TODOS los archivos de
/// `test/` automaticamente.
///
/// Vacia la cache de `rootBundle` despues de cada test. Sin esto, montar la
/// app real dos veces en el mismo archivo se cuelga en silencio:
///
/// `rootBundle` guarda el `Future` de cada asset. Ese futuro se crea dentro
/// de la zona asincrona FALSA del primer test, y un `Future` ya completado
/// agenda sus continuaciones en la zona donde nacio. En el segundo test esa
/// zona ya no avanza, asi que el `await` sobre el asset cacheado nunca
/// vuelve, el BLoC se queda cargando y `pumpAndSettle` expira con un spinner
/// girando para siempre.
///
/// No afecta a produccion: alli la app se monta una vez, en una zona real.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  tearDown(() => rootBundle.clear());
  await testMain();
}
