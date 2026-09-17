import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pujili_vive/features/home/presentation/bloc/home_bloc.dart';
import 'package:pujili_vive/features/home/presentation/pages/home_page.dart';
import 'package:pujili_vive/features/home/presentation/widgets/next_event_card.dart';
import 'package:pujili_vive/l10n/app_localizations.dart';
import 'package:pujili_vive/shell/shell_cubit.dart';

import '../../../../helpers/fixtures/festival_event_fixtures.dart';

class _MockHomeBloc extends MockBloc<HomeEvent, HomeState>
    implements HomeBloc {}

void main() {
  late _MockHomeBloc bloc;
  late ShellCubit shell;

  setUp(() {
    bloc = _MockHomeBloc();
    shell = ShellCubit();
  });

  tearDown(() => shell.close());

  Widget wrap() {
    return MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('es'), Locale('en')],
      home: MultiBlocProvider(
        providers: [
          BlocProvider<HomeBloc>.value(value: bloc),
          BlocProvider<ShellCubit>.value(value: shell),
        ],
        child: const HomePage(),
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

  testWidgets('"Ver la fiesta" cambia al tab Calendario', (tester) async {
    final futura = buildEvent(
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

    expect(shell.state, ShellTab.home);
    await tester.tap(find.text('Ver la fiesta'));
    await tester.pump();

    expect(shell.state, ShellTab.calendar);
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
}
