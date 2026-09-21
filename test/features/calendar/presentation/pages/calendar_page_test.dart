import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pujili_vive/features/calendar/presentation/bloc/calendar_bloc.dart';
import 'package:pujili_vive/features/calendar/presentation/pages/calendar_page.dart';
import 'package:pujili_vive/features/calendar/presentation/pages/festival_event_detail_page.dart';
import 'package:pujili_vive/features/calendar/presentation/widgets/festival_event_card.dart';
import 'package:pujili_vive/features/calendar/presentation/widgets/month_header.dart';
import 'package:pujili_vive/l10n/app_localizations.dart';

import '../../../../helpers/fixtures/festival_event_fixtures.dart';

class _MockCalendarBloc extends MockBloc<CalendarEvent, CalendarState>
    implements CalendarBloc {}

void main() {
  late _MockCalendarBloc bloc;

  setUp(() => bloc = _MockCalendarBloc());

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
      home: BlocProvider<CalendarBloc>.value(
        value: bloc,
        child: const CalendarPage(),
      ),
    );
  }

  testWidgets('muestra un cargador mientras carga', (tester) async {
    when(() => bloc.state).thenReturn(CalendarLoading());

    await tester.pumpWidget(wrap());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('agrupa por mes e inserta un encabezado por cada uno',
      (tester) async {
    // Tres fiestas en tres meses distintos -> tres encabezados.
    final events = [corpusChristi, virgenDelCarmen, sanLorenzo];
    when(() => bloc.state)
        .thenReturn(CalendarLoaded(all: events, filtered: events));

    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    expect(find.byType(MonthHeader), findsNWidgets(3));
    expect(find.byType(FestivalEventCard), findsNWidgets(3));
    expect(find.text('Corpus Christi: Danzantes de Pujilí'), findsOneWidget);
  });

  testWidgets('tocar una tarjeta abre el detalle de esa fiesta',
      (tester) async {
    final events = [corpusChristi, sanLorenzo];
    when(() => bloc.state)
        .thenReturn(CalendarLoaded(all: events, filtered: events));

    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Fiesta de San Lorenzo'));
    await tester.pumpAndSettle();

    expect(find.byType(FestivalEventDetailPage), findsOneWidget);
    // La que se toco, no la primera de la lista.
    expect(find.text('Desfile cívico y comparsas.'), findsOneWidget);
  });

  testWidgets('una busqueda sin resultados explica que hacer', (tester) async {
    when(() => bloc.state).thenReturn(
      CalendarLoaded(all: [corpusChristi], filtered: const [], query: 'x'),
    );

    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    expect(find.text('No encontramos esa fiesta'), findsOneWidget);
    expect(find.byType(FestivalEventCard), findsNothing);
  });

  testWidgets('el error ofrece reintentar', (tester) async {
    when(() => bloc.state).thenReturn(const CalendarError('asset ausente'));

    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    expect(find.text('Reintentar'), findsOneWidget);
    await tester.tap(find.text('Reintentar'));

    verify(() => bloc.add(const LoadFestivalEvents())).called(1);
  });
}
