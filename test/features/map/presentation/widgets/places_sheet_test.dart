import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pujili_vive/core/services/maps_launcher.dart';
import 'package:pujili_vive/features/attractions/domain/entities/attraction.dart';
import 'package:pujili_vive/features/attractions/domain/entities/attraction_category.dart';
import 'package:pujili_vive/features/attractions/presentation/pages/attraction_detail_page.dart';
import 'package:pujili_vive/features/map/presentation/widgets/places_sheet.dart';
import 'package:pujili_vive/l10n/app_localizations.dart';

import '../../../../helpers/fixtures/attraction_fixtures.dart';

class _MockMapsLauncher extends Mock implements MapsLauncher {}

void main() {
  Widget wrap(List<Attraction> places) {
    return RepositoryProvider<MapsLauncher>(
      create: (_) => _MockMapsLauncher(),
      child: MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('es'), Locale('en')],
        home: Scaffold(
          body: Stack(children: [PlacesSheet(places: places)]),
        ),
      ),
    );
  }

  testWidgets('lista los lugares con su categoria', (tester) async {
    await tester.pumpWidget(
      wrap([
        buildAttraction(nameEs: 'Santuario del Niño de Isinche'),
        buildAttraction(
          id: 'ceramica',
          nameEs: 'Talleres de Cerámica',
          category: AttractionCategory.crafts,
        ),
      ]),
    );

    expect(find.text('Explorar Lugares'), findsOneWidget);
    expect(find.text('Santuario del Niño de Isinche'), findsOneWidget);
    expect(find.text('Religioso'), findsOneWidget);
    expect(find.text('Artesanía'), findsOneWidget);
  });

  testWidgets('no promete distancias que no existen', (tester) async {
    // El diseño escribe "Artesanía · 0,5 km", pero no hay campo de
    // distancia ni geolocalizacion (pregunta abierta nº 9).
    await tester.pumpWidget(wrap([buildAttraction()]));

    expect(find.textContaining('km'), findsNothing);
  });

  testWidgets('una ruta sin lugares lo dice, no deja la lista en blanco',
      (tester) async {
    await tester.pumpWidget(wrap(const []));

    expect(find.text('Esta ruta todavía no tiene lugares.'), findsOneWidget);
  });

  testWidgets('tocar una fila abre el detalle del atractivo', (tester) async {
    await tester.pumpWidget(
      wrap([buildAttraction(nameEs: 'Santuario del Niño de Isinche')]),
    );

    await tester.tap(find.text('Santuario del Niño de Isinche'));
    await tester.pumpAndSettle();

    expect(find.byType(AttractionDetailPage), findsOneWidget);
  });
}
