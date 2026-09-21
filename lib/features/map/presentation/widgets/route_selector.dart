import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/thematic_route.dart';

/// Control segmentado de rutas temáticas, dentro de una píldora con
/// borde. La activa va en relleno sólido (`docs/MOCKS.html`, pantalla 5).
///
/// Se desplaza en horizontal porque "Ruta del artesano" y "Ruta
/// religiosa" juntas no caben en una pantalla estrecha, y partir las
/// etiquetas en dos líneas rompería la píldora.
class RouteSelector extends StatelessWidget {
  final ThematicRoute active;
  final ValueChanged<ThematicRoute> onChanged;

  const RouteSelector({
    super.key,
    required this.active,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.gold, width: 1.5),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final route in ThematicRoute.values)
                _Segment(
                  label: _labelOf(l, route),
                  selected: route == active,
                  onTap: () => onChanged(route),
                ),
            ],
          ),
        ),
      ),
    );
  }

  static String _labelOf(AppLocalizations l, ThematicRoute route) {
    switch (route) {
      case ThematicRoute.all:
        return l.routeAll;
      case ThematicRoute.artisan:
        return l.routeArtisan;
      case ThematicRoute.religious:
        return l.routeReligious;
      case ThematicRoute.nature:
        return l.routeNature;
    }
  }
}

class _Segment extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Segment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.terracotta : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            color: selected ? AppColors.textLight : AppColors.textDark,
          ),
        ),
      ),
    );
  }
}
