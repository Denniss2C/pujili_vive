import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/di/injection.dart';
import 'core/flavors/flavor_config.dart';
import 'core/services/maps_launcher.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'features/attractions/presentation/bloc/attractions_bloc.dart';
import 'features/calendar/presentation/bloc/calendar_bloc.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/settings/presentation/cubit/locale_cubit.dart';
import 'l10n/app_localizations.dart';
import 'shell/main_shell.dart';
import 'shell/shell_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const PujiliViveApp());
}

class PujiliViveApp extends StatelessWidget {
  const PujiliViveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<MapsLauncher>(
      create: (_) => sl<MapsLauncher>(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => sl<AttractionsBloc>()..add(const LoadAttractions()),
          ),
          BlocProvider(
            create: (_) => sl<CalendarBloc>()..add(const LoadFestivalEvents()),
          ),
          BlocProvider(create: (_) => sl<HomeBloc>()..add(const LoadHome())),
          BlocProvider(create: (_) => sl<ShellCubit>()),
          // `load()` lee el idioma guardado. Va en el create y no en un
          // await del arranque para no retrasar el primer frame: mientras
          // resuelve, la app usa el idioma del telefono, que es el mismo
          // valor por defecto que si no hubiera preferencia.
          BlocProvider(create: (_) => sl<LocaleCubit>()..load()),
        ],
        child: BlocBuilder<LocaleCubit, Locale?>(
          builder: (context, locale) => MaterialApp(
            // `null` deja que Flutter resuelva con el idioma del
            // telefono; un valor lo fuerza (Ajustes).
            locale: locale,
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
        ),
      ),
    );
  }
}
