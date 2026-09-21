import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pujili_vive/core/services/maps_launcher.dart';
import 'package:pujili_vive/features/attractions/domain/entities/attraction.dart';
import 'package:pujili_vive/features/attractions/presentation/pages/attraction_detail_page.dart';
import 'package:pujili_vive/l10n/app_localizations.dart';

import '../../../../helpers/fixtures/attraction_fixtures.dart';

class _MockMapsLauncher extends Mock implements MapsLauncher {}

void main() {
  late _MockMapsLauncher launcher;

  setUp(() => launcher = _MockMapsLauncher());

  Widget wrap(Attraction attraction) {
    return RepositoryProvider<MapsLauncher>.value(
      value: launcher,
      child: MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('es'), Locale('en')],
        home: AttractionDetailPage(attraction: attraction),
      ),
    );
  }

  testWidgets('muestra nombre, categoria y las tres columnas de datos',
      (tester) async {
    await tester.pumpWidget(wrap(buildAttraction()));

    expect(find.text('Santuario del Niño de Isinche'), findsOneWidget);
    expect(find.text('Religioso'), findsOneWidget);
    expect(find.text('Horario'), findsOneWidget);
    expect(find.text('Costo'), findsOneWidget);
    expect(find.text('Ubicación'), findsOneWidget);
  });

  testWidgets('sin horario se oculta la columna, no dice "No disponible"',
      (tester) async {
    await tester.pumpWidget(wrap(buildAttraction(schedule: null)));

    expect(find.text('Horario'), findsNothing);
    expect(find.text('Costo'), findsOneWidget);
    expect(find.textContaining('disponible'), findsNothing);
  });

  testWidgets('sin horario ni costo queda solo la ubicacion', (tester) async {
    await tester.pumpWidget(
      wrap(buildAttraction(schedule: null, cost: null)),
    );

    expect(find.text('Horario'), findsNothing);
    expect(find.text('Costo'), findsNothing);
    expect(find.text('Ubicación'), findsOneWidget);
    // Con una sola columna no queda ningun divisor colgando.
    expect(find.byType(VerticalDivider), findsNothing);
  });

  testWidgets('con una sola foto la galeria no se dibuja', (tester) async {
    // La primera foto es la portada; la galeria son las ADICIONALES.
    await tester.pumpWidget(
      wrap(buildAttraction(images: const ['assets/images/portada.jpg'])),
    );

    expect(find.byType(ListView), findsOneWidget); // solo el scroll principal
  });

  testWidgets('con fotos adicionales aparece la galeria', (tester) async {
    await tester.pumpWidget(
      wrap(
        buildAttraction(
          images: const [
            'assets/images/portada.jpg',
            'assets/images/extra_1.jpg',
            'assets/images/extra_2.jpg',
          ],
        ),
      ),
    );

    // El scroll principal mas la galeria horizontal.
    expect(find.byType(ListView), findsNWidgets(2));
  });

  testWidgets('"Cómo llegar" abre la ruta con las coordenadas del atractivo',
      (tester) async {
    when(
      () => launcher.openDirections(
        latitude: any(named: 'latitude'),
        longitude: any(named: 'longitude'),
      ),
    ).thenAnswer((_) async => true);

    await tester.pumpWidget(
      wrap(buildAttraction(latitude: -0.9667, longitude: -78.7)),
    );
    await tester.ensureVisible(find.text('Cómo llegar'));
    await tester.tap(find.text('Cómo llegar'));
    await tester.pump();

    verify(
      () => launcher.openDirections(latitude: -0.9667, longitude: -78.7),
    ).called(1);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('si no hay app de mapas, lo explica en vez de fallar callado',
      (tester) async {
    when(
      () => launcher.openDirections(
        latitude: any(named: 'latitude'),
        longitude: any(named: 'longitude'),
      ),
    ).thenAnswer((_) async => false);

    await tester.pumpWidget(wrap(buildAttraction()));
    await tester.ensureVisible(find.text('Cómo llegar'));
    await tester.tap(find.text('Cómo llegar'));
    await tester.pump();

    expect(
      find.text('No encontramos una app de mapas para abrir la ruta.'),
      findsOneWidget,
    );
  });
}
