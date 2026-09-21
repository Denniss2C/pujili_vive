import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pujili_vive/core/constants/app_info.dart';
import 'package:pujili_vive/features/settings/presentation/cubit/locale_cubit.dart';
import 'package:pujili_vive/features/settings/presentation/pages/settings_page.dart';
import 'package:pujili_vive/l10n/app_localizations.dart';

class _MockLocaleCubit extends MockCubit<Locale?> implements LocaleCubit {}

void main() {
  late _MockLocaleCubit cubit;

  setUp(() => cubit = _MockLocaleCubit());

  Widget wrap({Locale locale = const Locale('es')}) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('es'), Locale('en')],
      home: BlocProvider<LocaleCubit>.value(
        value: cubit,
        child: const SettingsPage(),
      ),
    );
  }

  testWidgets('ofrece las tres opciones de idioma', (tester) async {
    when(() => cubit.state).thenReturn(null);

    await tester.pumpWidget(wrap());

    expect(find.text('El del teléfono'), findsOneWidget);
    expect(find.text('Español'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
  });

  testWidgets('sin preferencia marca "el del teléfono"', (tester) async {
    when(() => cubit.state).thenReturn(null);

    await tester.pumpWidget(wrap());

    final tiles = tester
        .widgetList<RadioListTile<String?>>(find.byType(RadioListTile<String?>))
        .toList();
    expect(tiles.first.value, isNull);
    expect(find.byType(RadioListTile<String?>), findsNWidgets(3));
  });

  testWidgets('elegir un idioma se lo pide al cubit', (tester) async {
    when(() => cubit.state).thenReturn(null);
    when(() => cubit.change(any())).thenAnswer((_) async {});

    await tester.pumpWidget(wrap());
    await tester.tap(find.text('English'));
    await tester.pump();

    verify(() => cubit.change('en')).called(1);
  });

  testWidgets('muestra la version de la app', (tester) async {
    when(() => cubit.state).thenReturn(null);

    await tester.pumpWidget(wrap());

    expect(find.text('Versión'), findsOneWidget);
    expect(find.text(AppInfo.version), findsOneWidget);
  });

  testWidgets('no ofrece "contacto": no hay una direccion real',
      (tester) async {
    when(() => cubit.state).thenReturn(null);

    await tester.pumpWidget(wrap());

    expect(find.textContaining('ontacto'), findsNothing);
  });
}
