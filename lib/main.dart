import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/di/injection.dart';
import 'core/flavors/flavor_config.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'features/attractions/presentation/bloc/attractions_bloc.dart';
import 'l10n/app_localizations.dart';
import 'shell/main_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const PujiliViveApp());
}

class PujiliViveApp extends StatelessWidget {
  const PujiliViveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<AttractionsBloc>()..add(const LoadAttractions()),
        ),
      ],
      child: MaterialApp(
        // El titulo viene del flavor: en dev aparece "(Dev)" en el
        // selector de apps recientes de Android.
        title: FlavorConfig.instance.appTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('es'),
          Locale('en'),
        ],
        // Señal visual de ambiente: una cinta "DEV" sobre la esquina.
        // Sin ella, dev y prod son indistinguibles en pantalla y es
        // facil creer que se esta probando una build que no es.
        builder: (context, child) => FlavorConfig.isProd
            ? (child ?? const SizedBox.shrink())
            : Banner(
                location: BannerLocation.topEnd,
                message: FlavorConfig.instance.name,
                color: AppColors.terracotta,
                child: child ?? const SizedBox.shrink(),
              ),
        home: const MainShell(),
      ),
    );
  }
}
