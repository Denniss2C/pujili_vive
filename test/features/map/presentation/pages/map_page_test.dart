import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pujili_vive/core/services/maps_launcher.dart';
import 'package:pujili_vive/features/attractions/domain/entities/attraction_category.dart';
import 'package:pujili_vive/features/attractions/presentation/bloc/attractions_bloc.dart';
import 'package:pujili_vive/features/attractions/presentation/pages/attraction_detail_page.dart';
import 'package:pujili_vive/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:pujili_vive/features/map/presentation/pages/map_page.dart';
import 'package:pujili_vive/l10n/app_localizations.dart';

import '../../../../helpers/favorites_cubit_helper.dart';
import '../../../../helpers/fixtures/attraction_fixtures.dart';

class _MockAttractionsBloc extends MockBloc<AttractionsEvent, AttractionsState>
    implements AttractionsBloc {}

class _MockMapsLauncher extends Mock implements MapsLauncher {}

/// Esta pantalla no se podia probar con Google Maps: `GoogleMap` es una
/// *platform view* y en un test de widget no pinta nada. `FlutterMap` es
/// Flutter puro, asi que el mapa entra por fin en la suite.
///
/// **El bloque `[flutter_map]` que aparece en la salida no es un fallo.**
/// Es el paquete recordando la politica de teselas de OpenStreetMap; lo
/// imprime siempre que la URL sea la del servidor publico y no se puede
/// silenciar. Solo ocurre en debug (`kDebugMode`), nunca en release.
void main() {
  late _MockAttractionsBloc bloc;
  late FavoritesCubit favorites;

  final plaza = buildAttraction(
    id: 'plaza-matriz',
    nameEs: 'Plaza e Iglesia Matriz',
    category: AttractionCategory.cultural,
    latitude: -0.9578,
    longitude: -78.6967,
  );
  final taller = buildAttraction(
    id: 'ceramica',
    nameEs: 'Talleres de Cerámica',
    category: AttractionCategory.crafts,
    latitude: -0.9601,
    longitude: -78.6999,
  );

  setUp(() {
    bloc = _MockAttractionsBloc();
    when(() => bloc.state).thenReturn(
      AttractionsLoaded(all: [plaza, taller], filtered: [plaza, taller]),
    );
    favorites = buildFavoritesCubit();
  });

  tearDown(() => favorites.close());

  /// Los providers van encima del `MaterialApp`, como en `main.dart`: el
  /// detalle se empuja con `Navigator.push` y si cuelgan del `home` queda
  /// fuera de su alcance.
  Widget wrap() {
    return RepositoryProvider<MapsLauncher>(
      create: (_) => _MockMapsLauncher(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AttractionsBloc>.value(value: bloc),
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
          home: MapPage(),
        ),
      ),
    );
  }

  testWidgets('pone un pin por cada lugar de la ruta', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pump();

    expect(find.byKey(const Key('map-pin-plaza-matriz')), findsOneWidget);
    expect(find.byKey(const Key('map-pin-ceramica')), findsOneWidget);
  });

  testWidgets('tocar un pin abre el detalle de ese lugar', (tester) async {
    // Reemplaza a la `InfoWindow` de Google, que no existe en flutter_map
    // (`docs/CONCEPTO.md` §9, decision 12). Lleva a la misma pantalla que
    // las filas del sheet y las tarjetas de Explorar.
    await tester.pumpWidget(wrap());
    await tester.pump();

    await tester.tap(find.byKey(const Key('map-pin-ceramica')));
    await tester.pumpAndSettle();

    expect(find.byType(AttractionDetailPage), findsOneWidget);
    expect(find.text('Talleres de Cerámica'), findsWidgets);
  });

  testWidgets('acredita a OpenStreetMap, que la licencia lo exige',
      (tester) async {
    // Las teselas son de la OSMF bajo ODbL: el credito tiene que verse.
    // Si alguien lo borra por limpiar la pantalla, este test lo para.
    await tester.pumpWidget(wrap());
    await tester.pump();

    expect(find.textContaining('OpenStreetMap'), findsOneWidget);
  });
}
