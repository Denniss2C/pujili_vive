import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/artisans/presentation/pages/artisans_page.dart';
import '../features/attractions/presentation/pages/attractions_page.dart';
import '../features/calendar/presentation/pages/calendar_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/map/presentation/pages/map_page.dart';
import '../l10n/app_localizations.dart';
import 'shell_cubit.dart';

/// Contenedor principal con la barra de navegación inferior UNIFICADA.
/// Los 5 tabs son idénticos en toda la app (Inicio, Explorar, Calendario,
/// Mapa, Perfil), resolviendo la inconsistencia del diseño original.
///
/// El tab activo lo lleva [ShellCubit], no un `setState`: otras pantallas
/// necesitan cambiarlo (Inicio manda al Calendario y a Explorar).
class MainShell extends StatelessWidget {
  const MainShell({super.key});

  static const _pages = [
    HomePage(),
    AttractionsPage(),
    CalendarPage(),
    MapPage(),
    // Perfil apunta a Artesanos como parche del scaffold. Es provisional
    // y hay que deshacerlo: ni el tab Perfil esta definido ni Artesanos
    // tiene tab propio (docs/CONCEPTO.md, preguntas abiertas 1 y 8).
    ArtisansPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return BlocBuilder<ShellCubit, ShellTab>(
      builder: (context, tab) {
        return Scaffold(
          body: IndexedStack(index: tab.index, children: _pages),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: tab.index,
            onTap: (i) => context.read<ShellCubit>().select(ShellTab.values[i]),
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                activeIcon: const Icon(Icons.home),
                label: l.navHome,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.explore_outlined),
                activeIcon: const Icon(Icons.explore),
                label: l.navExplore,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.calendar_today_outlined),
                activeIcon: const Icon(Icons.calendar_today),
                label: l.navCalendar,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.map_outlined),
                activeIcon: const Icon(Icons.map),
                label: l.navMap,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_outline),
                activeIcon: const Icon(Icons.person),
                label: l.navProfile,
              ),
            ],
          ),
        );
      },
    );
  }
}
