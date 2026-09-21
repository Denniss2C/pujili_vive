/// Datos de la propia app que se enseñan en Ajustes.
///
/// La version esta duplicada respecto a `pubspec.yaml` a proposito: leerla
/// en tiempo de ejecucion obligaria a añadir `package_info_plus`, un
/// plugin nativo, para mostrar una linea de texto. El riesgo de que las
/// dos se desincronicen lo cubre un test que las compara
/// (`test/core/constants/app_info_test.dart`).
class AppInfo {
  AppInfo._();

  static const String version = '1.0.0';
}
