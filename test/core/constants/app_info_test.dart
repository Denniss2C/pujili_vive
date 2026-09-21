import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pujili_vive/core/constants/app_info.dart';

void main() {
  test('la version de Ajustes es la misma que la de pubspec.yaml', () {
    // AppInfo.version esta escrita a mano para no depender de un plugin
    // nativo solo por una linea de texto. Este test es lo que impide que
    // se quede vieja: si alguien sube la version en pubspec y no aqui,
    // el CI lo dice.
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final match =
        RegExp(r'^version:\s*([0-9]+\.[0-9]+\.[0-9]+)', multiLine: true)
            .firstMatch(pubspec);

    expect(match, isNotNull, reason: 'no encontre la version en pubspec.yaml');
    expect(AppInfo.version, match!.group(1));
  });
}
