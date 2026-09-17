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
/// **Cada tab tiene su propio `Navigator`.** Es lo que permite que un
/// detalle se abra *dentro* del tab activo, con la barra inferior visible
/// y sin cambiar de tab (`docs/CONCEPTO.md` §7.6, `[DECIDIDO]`). Con un
/// solo navegador, cualquier `push` taparia la barra entera.
///
/// El tab activo lo lleva [ShellCubit], no un `setState`: otras pantallas
/// necesitan cambiarlo (Inicio manda al Calendario).
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
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

  /// Una clave por tab, estable durante toda la vida del shell: cada
  /// navegador conserva su pila aunque se cambie de tab.
  final _navigatorKeys = List.generate(
    _pages.length,
    (_) => GlobalKey<NavigatorState>(),
  );

  NavigatorState? _navigatorOf(ShellTab tab) =>
      _navigatorKeys[tab.index].currentState;

  void _onTabTapped(ShellTab current, ShellTab tapped) {
    if (tapped == current) {
      // Volver a tocar el tab activo regresa a su raiz: es la convencion
      // de las barras inferiores en iOS y en Material.
      _navigatorOf(tapped)?.popUntil((route) => route.isFirst);
      return;
    }
    context.read<ShellCubit>().select(tapped);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return BlocBuilder<ShellCubit, ShellTab>(
      builder: (context, tab) {
        // El boton "atras" de Android cierra primero el detalle abierto
        // en el tab activo, y solo si esta en su raiz sale de la app.
        return NavigatorPopHandler<Object?>(
          onPopWithResult: (_) => _navigatorOf(tab)?.maybePop(),
          child: Scaffold(
            body: IndexedStack(
              index: tab.index,
              children: [
                for (var i = 0; i < _pages.length; i++)
                  Navigator(
                    key: _navigatorKeys[i],
                    onGenerateRoute: (settings) => MaterialPageRoute<void>(
                      settings: settings,
                      builder: (_) => _pages[i],
                    ),
                  ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: tab.index,
              onTap: (i) => _onTabTapped(tab, ShellTab.values[i]),
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
          ),
        );
      },
    );
  }
}
