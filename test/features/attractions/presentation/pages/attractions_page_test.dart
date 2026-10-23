import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pujili_vive/core/error/failures.dart';
import 'package:pujili_vive/core/usecases/usecase.dart';
import 'package:pujili_vive/features/attractions/domain/entities/attraction_category.dart';
import 'package:pujili_vive/features/attractions/domain/usecases/get_attractions.dart';
import 'package:pujili_vive/features/attractions/presentation/bloc/attractions_bloc.dart';
import 'package:pujili_vive/features/attractions/presentation/pages/attractions_page.dart';
import 'package:pujili_vive/l10n/app_localizations.dart';

import '../../../../helpers/fixtures/attraction_fixtures.dart';

class _MockGetAttractions extends Mock implements GetAttractions {}

class _FakeNoParams extends Fake implements NoParams {}

void main() {
  late _MockGetAttractions getAttractions;

  final attractions = [
    buildAttraction(id: 'santuario-nino-isinche'),
    buildAttraction(
      id: 'quilotoa',
      nameEs: 'Laguna del Quilotoa',
      category: AttractionCategory.nature,
    ),
  ];

  setUpAll(() => registerFallbackValue(_FakeNoParams()));

  setUp(() {
    getAttractions = _MockGetAttractions();
    when(() => getAttractions(any()))
        .thenAnswer((_) async => Right(attractions));
  });

  Future<void> pump(WidgetTester tester) async {
    // Bloc real con el usecase simulado: asi se prueba que el chip llega
    // de verdad al bloc y la lista se redibuja, no solo que se pinta.
    // Se crea aqui y no en setUp para que viva en la zona de reloj falso
    // de testWidgets; si no, sus eventos no avanzan con pumpAndSettle.
    final bloc = AttractionsBloc(getAttractions: getAttractions);
    addTearDown(bloc.close);

    await tester.pumpWidget(
      BlocProvider<AttractionsBloc>.value(
        value: bloc,
        child: const MaterialApp(
          locale: Locale('es'),
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [Locale('es'), Locale('en')],
          home: AttractionsPage(),
        ),
      ),
    );
    bloc.add(const LoadAttractions());
    await tester.pumpAndSettle();
  }

  bool isSelected(WidgetTester tester, String label) => tester
      .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, label))
      .selected;

  testWidgets('tocar un chip filtra la lista y lo marca', (tester) async {
    await pump(tester);
    expect(isSelected(tester, 'Todos'), isTrue);

    await tester.tap(find.text('Naturaleza'));
    await tester.pumpAndSettle();

    expect(find.text('Laguna del Quilotoa'), findsOneWidget);
    expect(find.text('Santuario del Niño de Isinche'), findsNothing);
    expect(isSelected(tester, 'Naturaleza'), isTrue);
    expect(isSelected(tester, 'Todos'), isFalse);
  });

  testWidgets('"Todos" devuelve la lista completa', (tester) async {
    await pump(tester);
    await tester.tap(find.text('Naturaleza'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Todos'));
    await tester.pumpAndSettle();

    expect(find.text('Santuario del Niño de Isinche'), findsOneWidget);
    expect(isSelected(tester, 'Todos'), isTrue);
  });

  testWidgets('si la carga falla muestra el motivo', (tester) async {
    when(() => getAttractions(any()))
        .thenAnswer((_) async => const Left(CacheFailure('sin datos')));

    await pump(tester);

    expect(find.text('sin datos'), findsOneWidget);
    expect(find.byType(ChoiceChip), findsNothing);
  });
}
