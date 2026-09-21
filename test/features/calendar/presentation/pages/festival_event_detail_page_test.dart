import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pujili_vive/core/widgets/detail_layout.dart';
import 'package:pujili_vive/features/calendar/domain/entities/festival_event.dart';
import 'package:pujili_vive/features/calendar/presentation/pages/festival_event_detail_page.dart';
import 'package:pujili_vive/l10n/app_localizations.dart';

import '../../../../helpers/fixtures/festival_event_fixtures.dart';

void main() {
  Widget wrap(FestivalEvent event, {Locale locale = const Locale('es')}) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('es'), Locale('en')],
      home: FestivalEventDetailPage(event: event),
    );
  }

  testWidgets('muestra titulo, descripcion y la fecha', (tester) async {
    await tester.pumpWidget(
      wrap(
        buildEvent(
          titleEs: 'Corpus Christi: Danzantes de Pujilí',
          descEs: 'La fiesta mayor del cantón.',
          startDate: DateTime(2027, 5, 27),
        ),
      ),
    );

    expect(find.text('Corpus Christi: Danzantes de Pujilí'), findsOneWidget);
    expect(find.text('La fiesta mayor del cantón.'), findsOneWidget);
    expect(find.text('Fecha'), findsOneWidget);
  });

  testWidgets('con ubicacion muestra las dos columnas', (tester) async {
    await tester.pumpWidget(
      wrap(buildEvent(locationEs: 'Plaza central, Pujilí')),
    );

    expect(find.text('Fecha'), findsOneWidget);
    expect(find.text('Ubicación'), findsOneWidget);
    expect(find.text('Plaza central, Pujilí'), findsOneWidget);
  });

  testWidgets('sin ubicacion se cae la columna, no dice "No disponible"',
      (tester) async {
    // Hoy la mitad de las fiestas del JSON no tiene sitio definido.
    await tester.pumpWidget(wrap(buildEvent()));

    expect(find.text('Ubicación'), findsNothing);
    expect(find.textContaining('disponible'), findsNothing);
    // Con una sola columna no queda un divisor colgando al borde.
    expect(find.byType(VerticalDivider), findsNothing);
  });

  testWidgets('una fiesta destacada se anuncia con palabras', (tester) async {
    await tester.pumpWidget(wrap(buildEvent(isHighlighted: true)));

    expect(find.text('Fiesta destacada'), findsOneWidget);
  });

  testWidgets('una fiesta normal no lleva la pildora', (tester) async {
    await tester.pumpWidget(wrap(buildEvent()));

    expect(find.text('Fiesta destacada'), findsNothing);
  });

  testWidgets('sin foto cae al marcador y no revienta', (tester) async {
    // Ninguna fiesta tiene foto todavia: este es el caso normal, no el raro.
    await tester.pumpWidget(wrap(buildEvent()));

    expect(find.byType(DetailAssetCover), findsOneWidget);
    expect(find.byIcon(Icons.celebration_outlined), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('no ofrece "Como llegar": la fiesta no tiene coordenadas',
      (tester) async {
    await tester.pumpWidget(
      wrap(buildEvent(locationEs: 'Plaza central, Pujilí')),
    );

    expect(find.text('Cómo llegar'), findsNothing);
  });

  group('formato de fecha', () {
    test('un solo dia lleva dia, mes y año', () {
      final texto = FestivalEventDetailPage.formatDate(
        buildEvent(startDate: DateTime(2027, 5, 27)),
        'es',
      );

      expect(texto, contains('27'));
      expect(texto, contains('2027'));
    });

    test('un rango lleva el año una sola vez, al final', () {
      final texto = FestivalEventDetailPage.formatDate(
        buildEvent(
          startDate: DateTime(2027, 5, 27),
          endDate: DateTime(2027, 6, 4),
        ),
        'es',
      );

      expect(texto, contains('27'));
      expect(texto, contains('4'));
      expect('2027'.allMatches(texto).length, 1);
    });
  });
}
