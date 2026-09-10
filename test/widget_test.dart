import 'package:flutter_test/flutter_test.dart';
import 'package:pujili_vive/core/di/injection.dart';
import 'package:pujili_vive/main.dart';
import 'package:pujili_vive/shell/main_shell.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initDependencies();
  });

  testWidgets('La app arranca y muestra el shell principal', (tester) async {
    await tester.pumpWidget(const PujiliViveApp());
    await tester.pumpAndSettle();

    expect(find.byType(MainShell), findsOneWidget);
  });
}
