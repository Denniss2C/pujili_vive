import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Chrome compartido por las pantallas de detalle.
///
/// Nacio con el detalle de atractivo. El concepto resuelve el detalle de
/// evento como "el mismo layout" (`docs/CONCEPTO.md` §9, pregunta 6), asi
/// que en vez de copiarlo se extrajo aqui: dos features lo usan y ninguna
/// es dueña de la otra, que es justo el criterio para que algo viva en
/// `core/` (`project_rules/08_folder_structure.md`).

/// Foto a sangre, panel que sube sobre ella y boton de retroceso.
class DetailScaffold extends StatelessWidget {
  final Widget cover;
  final Widget panel;

  const DetailScaffold({super.key, required this.cover, required this.panel});

  static const double _coverHeight = 250;

  /// Cuanto sube el panel sobre la foto.
  static const double _overlap = 26;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(
            children: [
              SizedBox(
                height: _coverHeight,
                width: double.infinity,
                child: cover,
              ),
              Padding(
                padding: const EdgeInsets.only(top: _coverHeight - _overlap),
                child: panel,
              ),
              const Positioned(top: 0, left: 0, child: _BackButton()),
            ],
          ),
        ],
      ),
    );
  }
}

/// Portada desde un asset, con marcador si no hay foto o si falla.
///
/// El marcador no es un caso raro: hoy **ninguna** fiesta tiene foto, asi
/// que es lo que se ve en todo el detalle de evento.
class DetailAssetCover extends StatelessWidget {
  final List<String> images;
  final IconData fallbackIcon;

  const DetailAssetCover({
    super.key,
    required this.images,
    required this.fallbackIcon,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final placeholder = ColoredBox(
      color: AppColors.gold.withValues(alpha: 0.25),
      child: Center(child: Icon(fallbackIcon, size: 48)),
    );

    if (images.isEmpty) return placeholder;

    return Image.asset(
      images.first,
      fit: BoxFit.cover,
      // A sangre: ocupa el ancho de la pantalla (11_performance_rules).
      cacheWidth: (media.size.width * media.devicePixelRatio).round(),
      errorBuilder: (_, __, ___) => placeholder,
    );
  }
}

/// Panel crema con esquinas redondeadas y la cinta del Danzante.
class DetailPanel extends StatelessWidget {
  final List<Widget> children;

  const DetailPanel({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
          decoration: const BoxDecoration(
            color: AppColors.cream,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
        // Unico adorno de la pantalla: cinta de cuatro tiras con la
        // paleta del Danzante (docs/MOCKS.html, notas transversales).
        const Positioned(top: -14, right: 22, child: _Ribbon()),
      ],
    );
  }
}

/// Un dato practico: icono, etiqueta y valor.
@immutable
class DetailFact {
  final IconData icon;
  final String label;
  final String value;

  const DetailFact({
    required this.icon,
    required this.label,
    required this.value,
  });
}

/// Fila de datos practicos.
///
/// Los datos que faltan **no se listan**: la pantalla que llama construye
/// la lista con los que tiene y aqui no se escribe "No disponible"
/// (`docs/CONCEPTO.md` §4.3). Los divisores van solo ENTRE columnas
/// visibles, para que ocultar una no deje un separador colgando al borde.
class DetailFactsRow extends StatelessWidget {
  final List<DetailFact> facts;

  const DetailFactsRow({super.key, required this.facts});

  @override
  Widget build(BuildContext context) {
    final line = AppColors.textDark.withValues(alpha: 0.12);

    final children = <Widget>[];
    for (var i = 0; i < facts.length; i++) {
      if (i > 0) {
        children.add(VerticalDivider(width: 1, thickness: 1, color: line));
      }
      children.add(Expanded(child: _Fact(fact: facts[i])));
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: Border.symmetric(horizontal: BorderSide(color: line)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  final DetailFact fact;

  const _Fact({required this.fact});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(fact.icon, size: 16, color: AppColors.terracotta),
          const SizedBox(height: 4),
          Text(
            fact.label,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          Text(
            fact.value,
            style: TextStyle(
              fontSize: 12.5,
              color: AppColors.textDark.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

/// Boton de retroceso circular y translucido sobre la foto.
///
/// Envuelve un [BackButton] real, no un icono suelto: asi hereda la
/// etiqueta de accesibilidad y el `maybePop` del navegador del tab.
class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.6),
          ),
          child: const BackButton(color: AppColors.textDark),
        ),
      ),
    );
  }
}

class _Ribbon extends StatelessWidget {
  const _Ribbon();

  @override
  Widget build(BuildContext context) {
    const colors = [
      AppColors.terracotta,
      AppColors.gold,
      AppColors.deepGreen,
      AppColors.terracotta,
    ];
    return Row(
      children: [
        for (final color in colors)
          Container(
            width: 9,
            height: 26,
            margin: const EdgeInsets.only(left: 3),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
      ],
    );
  }
}
