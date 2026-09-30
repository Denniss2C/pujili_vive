import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pujili_vive/core/services/maps_launcher.dart';
import 'package:pujili_vive/features/attractions/presentation/bloc/attractions_bloc.dart';
import 'package:pujili_vive/features/calendar/presentation/bloc/calendar_bloc.dart';
import 'package:pujili_vive/features/favorites/domain/entities/favorite_ref.dart';
import 'package:pujili_vive/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:pujili_vive/features/favorites/presentation/pages/favorites_page.dart';
import 'package:pujili_vive/l10n/app_localizations.dart';

import '../../../../helpers/favorites_cubit_helper.dart';
import '../../../../helpers/fixtures/attraction_fixtures.dart';
import '../../../../helpers/fixtures/festival_event_fixtures.dart';

class _MockAttractionsBloc extends MockBloc<AttractionsEvent, AttractionsState>
    implements AttractionsBloc {}

class _MockCalendarBloc extends MockBloc<CalendarEvent, CalendarState>
    implements CalendarBloc {}

class _MockMapsLauncher extends Mock implements MapsLauncher {}

void main() {
  late _MockAttractionsBloc attractions;
  late _MockCalendarBloc calendar;

  final isinche = buildAttraction(
    id: 'isinche',
    nameEs: 'Santuario del Niño de Isinche',
  );
  final quilotoa =
      buildAttraction(id: 'quilotoa', nameEs: 'Laguna del Quilotoa');
  final pregon = buildEvent(id: 'pregon', titleEs: 'Pregón de Fiestas');

  setUp(() {
    attractions = _MockAttractionsBloc();
    calendar = _MockCalendarBloc();
    when(() => attractions.state).thenReturn(
      AttractionsLoaded(
        all: [isinche, quilotoa],
        filtered: [isinche, quilotoa],
      ),
    );
    when(() => calendar.state)
        .thenReturn(CalendarLoaded(all: [pregon], filtered: [pregon]));
  });

  /// Da altura de sobra al lienzo. Con los 800x600 por defecto la
  /// seccion de fiestas cae bajo el pliegue y el `ListView` perezoso no
  /// llega a construirla.
  void pantallaAlta(WidgetTester tester) {
    tester.view.physicalSize = const Size(1000, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  Widget wrap(FavoritesCubit favorites) {
    return RepositoryProvider<MapsLauncher>(
      create: (_) => _MockMapsLauncher(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AttractionsBloc>.value(value: attractions),
          BlocProvider<CalendarBloc>.value(value: calendar),
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
          home: FavoritesPage(),
        ),
      ),
    );
  }

  testWidgets('sin nada guardado explica que hacer', (tester) async {
    final favorites = buildFavoritesCubit();
    await tester.pumpWidget(wrap(favorites));

    expect(find.text('Todavía no has guardado nada'), findsOneWidget);
    expect(find.textContaining('Toca el corazón'), findsOneWidget);
    await favorites.close();
  });

  testWidgets('separa atractivos de fiestas', (tester) async {
    final favorites = buildFavoritesCubit(
      initial: {
        const FavoriteRef.attraction('isinche'),
        const FavoriteRef.festival('pregon'),
      },
    );
    await favorites.load();
    pantallaAlta(tester);
    await tester.pumpWidget(wrap(favorites));

    expect(find.text('Atractivos'), findsOneWidget);
    expect(find.text('Fiestas'), findsOneWidget);
    expect(find.text('Santuario del Niño de Isinche'), findsOneWidget);
    expect(find.text('Pregón de Fiestas'), findsOneWidget);
    // Lo que no se guardo no aparece.
    expect(find.text('Laguna del Quilotoa'), findsNothing);
    await favorites.close();
  });

  testWidgets('una seccion sin nada guardado no se dibuja', (tester) async {
    final favorites = buildFavoritesCubit(
      initial: {const FavoriteRef.attraction('isinche')},
    );
    await favorites.load();
    pantallaAlta(tester);
    await tester.pumpWidget(wrap(favorites));

    expect(find.text('Atractivos'), findsOneWidget);
    expect(find.text('Fiestas'), findsNothing);
    await favorites.close();
  });

  testWidgets('un guardado que ya no existe en los datos no rompe nada',
      (tester) async {
    // Pasa si se retira un atractivo del JSON: el id guardado se queda
    // huerfano y no debe dejar una ficha rota ni tumbar la pantalla.
    final favorites = buildFavoritesCubit(
      initial: {const FavoriteRef.attraction('ya-no-existe')},
    );
    await favorites.load();
    pantallaAlta(tester);
    await tester.pumpWidget(wrap(favorites));

    expect(find.text('Todavía no has guardado nada'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await favorites.close();
  });
}
