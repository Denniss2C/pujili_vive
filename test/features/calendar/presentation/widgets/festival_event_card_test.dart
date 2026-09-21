import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pujili_vive/core/theme/app_colors.dart';
import 'package:pujili_vive/features/calendar/domain/entities/event_status.dart';
import 'package:pujili_vive/features/calendar/domain/entities/festival_event.dart';
import 'package:pujili_vive/features/calendar/presentation/widgets/festival_event_card.dart';
import 'package:pujili_vive/l10n/app_localizations.dart';

import '../../../../helpers/fixtures/festival_event_fixtures.dart';

void main() {
  Widget wrap(FestivalEvent event, EventStatus status) {
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
        body: FestivalEventCard(
          event: event,
          languageCode: 'es',
          status: status,
          onTap: () {},
        ),
      ),
    );
  }

  /// El relleno de la tarjeta, que es lo que distingue los tratamientos.
  Color? fillOf(WidgetTester tester) {
    final container = tester.widgetList<Container>(find.byType(Container));
    for (final c in container) {
      final decoration = c.decoration;
      if (decoration is BoxDecoration && decoration.borderRadius != null) {
        return decoration.color;
      }
    }
    return null;
  }

  testWidgets('la que no ha empezado es simple: sin relleno ni etiqueta',
      (tester) async {
    await tester.pumpWidget(wrap(buildEvent(), EventStatus.upcoming));

    expect(find.text('Ahora'), findsNothing);
    expect(fillOf(tester), isNot(AppColors.cardBackground));
  });

  testWidgets('la que esta ocurriendo se pinta blanca y lo dice',
      (tester) async {
    // Es el corazon de la pantalla: el blanco significa "esto esta
    // pasando ahora", no una marca fija del JSON.
    await tester.pumpWidget(wrap(buildEvent(), EventStatus.inProgress));

    expect(find.text('AHORA'), findsOneWidget);
    expect(fillOf(tester), AppColors.cardBackground);
  });

  testWidgets('la destacada que aun no empieza NO se pinta blanca',
      (tester) async {
    // Destacada y en curso son dos cosas distintas y no pueden verse
    // igual, o el blanco deja de significar nada.
    await tester.pumpWidget(
      wrap(buildEvent(isHighlighted: true), EventStatus.upcoming),
    );

    expect(find.text('AHORA'), findsNothing);
    expect(fillOf(tester), isNot(AppColors.cardBackground));
  });

  testWidgets('una destacada que esta ocurriendo gana el blanco',
      (tester) async {
    await tester.pumpWidget(
      wrap(buildEvent(isHighlighted: true), EventStatus.inProgress),
    );

    expect(find.text('AHORA'), findsOneWidget);
    expect(fillOf(tester), AppColors.cardBackground);
  });

  testWidgets('la que ya paso se atenua, pero sigue ahi', (tester) async {
    await tester.pumpWidget(
      wrap(buildEvent(titleEs: 'Misa de fiesta'), EventStatus.past),
    );

    // Se puede seguir consultando lo que ya paso (pregunta n 4).
    expect(find.text('Misa de fiesta'), findsOneWidget);
    expect(tester.widget<Opacity>(find.byType(Opacity)).opacity, lessThan(1));
  });

  testWidgets('una destacada que ya paso no se anuncia como destacada',
      (tester) async {
    await tester.pumpWidget(
      wrap(buildEvent(isHighlighted: true), EventStatus.past),
    );

    expect(fillOf(tester), isNot(AppColors.cardBackground));
    expect(find.byType(Opacity), findsOneWidget);
  });

  testWidgets('la tarjeta muestra la hora, no solo el dia', (tester) async {
    // Hay dos fiestas por dia: el dia solo ya no las distingue.
    await tester.pumpWidget(
      wrap(
        buildEvent(startDate: DateTime(2026, 9, 21, 19, 30)),
        EventStatus.upcoming,
      ),
    );

    expect(find.text('19:30'), findsOneWidget);
    expect(find.text('21'), findsOneWidget);
  });
}
