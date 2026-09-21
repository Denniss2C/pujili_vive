import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pujili_vive/features/map/domain/entities/thematic_route.dart';
import 'package:pujili_vive/features/map/presentation/widgets/route_selector.dart';
import 'package:pujili_vive/l10n/app_localizations.dart';

void main() {
  Widget wrap({
    required ThematicRoute active,
    required ValueChanged<ThematicRoute> onChanged,
  }) {
    return MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('es'), Locale('en')],
      home: Scaffold(
        body: RouteSelector(active: active, onChanged: onChanged),
      ),
    );
  }

  testWidgets('ofrece las tres rutas del diseño mas "Todas"', (tester) async {
    await tester.pumpWidget(
      wrap(active: ThematicRoute.all, onChanged: (_) {}),
    );

    expect(find.text('Todas'), findsOneWidget);
    expect(find.text('Ruta del artesano'), findsOneWidget);
    expect(find.text('Ruta religiosa'), findsOneWidget);
    expect(find.text('Ruta natural'), findsOneWidget);
  });

  testWidgets('tocar una ruta la comunica hacia arriba', (tester) async {
    ThematicRoute? elegida;
    await tester.pumpWidget(
      wrap(active: ThematicRoute.all, onChanged: (r) => elegida = r),
    );

    await tester.tap(find.text('Ruta religiosa'));
    await tester.pump();

    expect(elegida, ThematicRoute.religious);
  });
}
