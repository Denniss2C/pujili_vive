import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pujili_vive/features/calendar/presentation/pages/festival_event_detail_page.dart';
import 'package:pujili_vive/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:pujili_vive/features/home/presentation/bloc/home_bloc.dart';
import 'package:pujili_vive/features/home/presentation/pages/home_page.dart';
import 'package:pujili_vive/features/home/presentation/widgets/next_event_card.dart';
import 'package:pujili_vive/features/settings/presentation/cubit/locale_cubit.dart';
import 'package:pujili_vive/features/settings/presentation/pages/settings_page.dart';
import 'package:pujili_vive/l10n/app_localizations.dart';
import 'package:pujili_vive/shell/shell_cubit.dart';

import '../../../../helpers/favorites_cubit_helper.dart';
import '../../../../helpers/fixtures/festival_event_fixtures.dart';

class _MockHomeBloc extends MockBloc<HomeEvent, HomeState>
    implements HomeBloc {}

class _MockLocaleCubit extends MockCubit<Locale?> implements LocaleCubit {}

void main() {
  late _MockHomeBloc bloc;
  late ShellCubit shell;
  late _MockLocaleCubit locale;
  late FavoritesCubit favorites;

  setUp(() {
    bloc = _MockHomeBloc();
    shell = ShellCubit();
    locale = _MockLocaleCubit();
    when(() => locale.state).thenReturn(null);
    favorites = buildFavoritesCubit();
  });

  tearDown(() {
    shell.close();
    favorites.close();
  });

  /// Los providers van ENCIMA del MaterialApp, como en `main.dart`. Si
  /// se cuelgan del `home`, una pantalla empujada con `Navigator.push`
  /// queda fuera de su alcance y el test falla por como esta montado,
  /// no por como se comporta la app.
  Widget wrap() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>.value(value: bloc),
        BlocProvider<ShellCubit>.value(value: shell),
        BlocProvider<LocaleCubit>.value(value: locale),
        BlocProvider<FavoritesCubit>.value(value: favorites),
      ],
      child: const MaterialApp(
        locale: Locale('es'),
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale('es'), Locale('en')],
        home: HomePage(),
      ),
    );
  }

  testWidgets('muestra el contador cuando hay una fiesta futura',
      (tester) async {
    // La fiesta se pone lejos para que el contador no dependa del reloj.
    final futura = buildEvent(
      id: 'futura',
      titleEs: 'Corpus Christi',
      startDate: DateTime.now().add(const Duration(days: 30)),
    );
    when(() => bloc.state).thenReturn(
      HomeLoaded(
        upcomingEvents: [futura],
        eventsFailed: false,
        attractions: const [],
        attractionsFailed: false,
      ),
    );

    await tester.pumpWidget(wrap());
    await tester.pump();

    expect(find.byType(NextEventCard), findsOneWidget);
    expect(find.text('Corpus Christi'), findsOneWidget);
  });

  testWidgets('sin fiestas futuras la tarjeta desaparece, no queda en cero',
      (tester) async {
    when(() => bloc.state).thenReturn(
      const HomeLoaded(
        upcomingEvents: [],
        eventsFailed: false,
        attractions: [],
        attractionsFailed: false,
      ),
    );

    await tester.pumpWidget(wrap());
    await tester.pump();

    expect(find.byType(NextEventCard), findsNothing);
    // Y la pantalla arranca directamente en "Que visitar".
    expect(find.text('Qué visitar'), findsOneWidget);
  });

  testWidgets('"Ver la fiesta" abre el detalle de esa fiesta', (tester) async {
    final futura = buildEvent(
      titleEs: 'Corpus Christi: Danzantes de Pujilí',
      startDate: DateTime.now().add(const Duration(days: 30)),
    );
    when(() => bloc.state).thenReturn(
      HomeLoaded(
        upcomingEvents: [futura],
        eventsFailed: false,
        attractions: const [],
        attractionsFailed: false,
      ),
    );

    await tester.pumpWidget(wrap());
    await tester.pump();

    await tester.tap(find.text('Ver la fiesta'));
    await tester.pumpAndSettle();

    // Va al detalle de LA fiesta que nombra la tarjeta, no a la lista
    // del calendario, donde habria que volver a buscarla (CONCEPTO §4.1).
    expect(find.byType(FestivalEventDetailPage), findsOneWidget);
    expect(find.text('Corpus Christi: Danzantes de Pujilí'), findsOneWidget);
    // Y no cambia de tab: el detalle se abre dentro de Inicio.
    expect(shell.state, ShellTab.home);
  });

  testWidgets('el fallo de una seccion no tumba el resto de la pantalla',
      (tester) async {
    when(() => bloc.state).thenReturn(
      const HomeLoaded(
        upcomingEvents: [],
        eventsFailed: true,
        attractions: [],
        attractionsFailed: false,
      ),
    );

    await tester.pumpWidget(wrap());
    await tester.pump();

    expect(find.text('No se pudo cargar esta sección.'), findsOneWidget);
    // "Que visitar" sigue ahi pese al error del calendario.
    expect(find.text('Qué visitar'), findsOneWidget);
  });

  testWidgets('el engranaje de la cabecera abre Ajustes', (tester) async {
    // Ajustes dejo de ser un tab: si no se llega desde aqui, no se llega.
    when(() => bloc.state).thenReturn(
      const HomeLoaded(
        upcomingEvents: [],
        eventsFailed: false,
        attractions: [],
        attractionsFailed: false,
      ),
    );

    await tester.pumpWidget(wrap());
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    expect(find.byType(SettingsPage), findsOneWidget);
  });

  // Telefono Android tipico (412 dp) con barra de estado alta, y uno
  // angosto (360 dp) con letra grande de accesibilidad.
  for (final (width, statusBar, textScale) in const [
    (412.0, 48.0, 1.0),
    (360.0, 24.0, 1.3),
  ]) {
    testWidgets(
        'en $width dp con letra x$textScale los iconos de la cabecera '
        'no tapan el titulo', (tester) async {
      // Bug real: el corazon y el engranaje se colocaban respecto al
      // titulo y no a la cabecera, y quedaban pintados encima del nombre.
      tester.view
        ..devicePixelRatio = 3
        ..physicalSize = Size(width * 3, 800 * 3)
        ..padding = FakeViewPadding(top: statusBar * 3);
      tester.platformDispatcher.textScaleFactorTestValue = textScale;
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      when(() => bloc.state).thenReturn(
        const HomeLoaded(
          upcomingEvents: [],
          eventsFailed: false,
          attractions: [],
          attractionsFailed: false,
        ),
      );

      await tester.pumpWidget(wrap());

      final title = tester.getRect(find.text('Pujilí Vive'));
      for (final icon in [Icons.favorite_border, Icons.settings_outlined]) {
        final button = tester.getRect(
          find.ancestor(
            of: find.byIcon(icon),
            matching: find.byType(IconButton),
          ),
        );
        expect(button.overlaps(title), isFalse, reason: '$icon tapa el titulo');
        expect(button.top, greaterThanOrEqualTo(statusBar));
      }
      // Y siguen en la esquina de la pantalla, no al lado del titulo.
      final gear = tester.getRect(find.byIcon(Icons.settings_outlined));
      expect(gear.right, greaterThan(width - 48));
      expect(tester.takeException(), isNull);
    });
  }
}
