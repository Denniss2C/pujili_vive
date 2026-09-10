import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/attractions/presentation/pages/attractions_page.dart';
import '../features/calendar/presentation/pages/calendar_page.dart';
import '../features/map/presentation/pages/map_page.dart';
import '../features/artisans/presentation/pages/artisans_page.dart';

/// Contenedor principal con la barra de navegación inferior UNIFICADA.
/// Los 5 tabs son idénticos en toda la app (Inicio, Explorar, Calendario,
/// Mapa, Perfil), resolviendo la inconsistencia del diseño original.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final _pages = const [
    HomePage(),
    AttractionsPage(),
    CalendarPage(),
    MapPage(),
    ArtisansPage(), // Perfil placeholder -> reemplazar cuando exista feature perfil
  ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
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
  }
}
