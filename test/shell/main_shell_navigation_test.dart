import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pujili_vive/core/di/injection.dart';
import 'package:pujili_vive/features/attractions/presentation/pages/attraction_detail_page.dart';
import 'package:pujili_vive/features/attractions/presentation/widgets/attraction_card.dart';
import 'package:pujili_vive/main.dart';
import 'package:pujili_vive/shell/main_shell.dart';
import 'package:pujili_vive/shell/shell_cubit.dart';

/// Navegacion anidada con la app REAL (DI y assets de verdad).
///
/// Verifica la regla `[DECIDIDO]` de `docs/CONCEPTO.md` §7.6: el detalle se
/// abre dentro del tab activo, la barra inferior sigue visible y el tab no
/// cambia. Con un solo navegador esto fallaria: el push taparia la barra.
void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initDependencies();
  });

  Future<void> abrirDetalleDesdeExplorar(WidgetTester tester) async {
    await tester.pumpWidget(const PujiliViveApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.explore_outlined));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(AttractionCard).first);
    await tester.pumpAndSettle();
  }

  ShellTab tabActivo(WidgetTester tester) =>
      BlocProvider.of<ShellCubit>(tester.element(find.byType(MainShell))).state;

  testWidgets('el detalle se abre dentro del tab, con la barra visible',
      (tester) async {
    await abrirDetalleDesdeExplorar(tester);

    expect(find.byType(AttractionDetailPage), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(tabActivo(tester), ShellTab.explore);
  });

  testWidgets('cambiar de tab y volver conserva el detalle abierto',
      (tester) async {
    await abrirDetalleDesdeExplorar(tester);

    await tester.tap(find.byIcon(Icons.calendar_today_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.explore_outlined));
    await tester.pumpAndSettle();

    // Cada tab tiene su propia pila: el detalle sigue ahi.
    expect(find.byType(AttractionDetailPage), findsOneWidget);
  });

  testWidgets('volver a tocar el tab activo regresa a su raiz', (tester) async {
    await abrirDetalleDesdeExplorar(tester);

    // Estando en Explorar el icono activo es el relleno.
    await tester.tap(find.byIcon(Icons.explore));
    await tester.pumpAndSettle();

    expect(find.byType(AttractionDetailPage), findsNothing);
    expect(find.byType(AttractionCard), findsWidgets);
  });

  testWidgets('el boton atras cierra el detalle sin salir del tab',
      (tester) async {
    await abrirDetalleDesdeExplorar(tester);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.byType(AttractionDetailPage), findsNothing);
    expect(tabActivo(tester), ShellTab.explore);
  });
}
