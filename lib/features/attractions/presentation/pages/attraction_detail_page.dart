import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/maps_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/attraction.dart';
import '../../domain/entities/attraction_category.dart';

/// Detalle de un atractivo (`docs/MOCKS.html`, pantalla 3).
///
/// Es el **nodo de convergencia** de la app: se llega desde Inicio,
/// Explorar y, mas adelante, el Mapa (`docs/CONCEPTO.md` §5). Por eso hay
/// una sola forma de abrirlo, [open], y no tres implementaciones.
///
/// Se le pasa el atractivo ya cargado en vez de un id: todas las entradas
/// lo tienen a mano y no hay enlaces profundos que obliguen a resolverlo.
class AttractionDetailPage extends StatelessWidget {
  final Attraction attraction;

  const AttractionDetailPage({super.key, required this.attraction});

  /// Empuja el detalle **dentro del tab activo**: la barra inferior sigue
  /// visible y el tab no cambia (`docs/CONCEPTO.md` §7.6, `[DECIDIDO]`).
  /// Funciona porque cada tab tiene su propio `Navigator` en `MainShell`.
  static Future<void> open(BuildContext context, Attraction attraction) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AttractionDetailPage(attraction: attraction),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(
            children: [
              SizedBox(
                height: 250,
                width: double.infinity,
                child: _Cover(attraction: attraction),
              ),
              // El panel sube 26 px sobre la foto.
              Padding(
                padding: const EdgeInsets.only(top: 224),
                child: _Panel(attraction: attraction, languageCode: lang),
              ),
              const Positioned(top: 0, left: 0, child: _BackButton()),
            ],
          ),
        ],
      ),
    );
  }
}

class _Cover extends StatelessWidget {
  final Attraction attraction;
  const _Cover({required this.attraction});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final placeholder = ColoredBox(
      color: AppColors.gold.withValues(alpha: 0.25),
      child: const Center(child: Icon(Icons.image_outlined, size: 48)),
    );

    if (attraction.images.isEmpty) return placeholder;

    return Image.asset(
      attraction.images.first,
      fit: BoxFit.cover,
      // A sangre: ocupa el ancho de la pantalla (11_performance_rules).
      cacheWidth: (media.size.width * media.devicePixelRatio).round(),
      errorBuilder: (_, __, ___) => placeholder,
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

class _Panel extends StatelessWidget {
  final Attraction attraction;
  final String languageCode;

  const _Panel({required this.attraction, required this.languageCode});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final gallery = attraction.images.skip(1).toList();

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
            children: [
              Text(
                attraction.name.resolve(languageCode),
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _categoryLabel(l, attraction.category),
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textDark.withValues(alpha: 0.65),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                attraction.shortDescription.resolve(languageCode),
                style: const TextStyle(
                  fontSize: 14.5,
                  height: 1.45,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 18),
              _FactsRow(attraction: attraction, languageCode: languageCode),
              const SizedBox(height: 18),
              _HowToGetButton(attraction: attraction),
              // Sin fotos adicionales la galeria NO se dibuja: no se deja
              // el hueco (docs/CONCEPTO.md §4.3).
              if (gallery.isNotEmpty) ...[
                const SizedBox(height: 18),
                _Gallery(images: gallery),
              ],
            ],
          ),
        ),
        // Unico adorno de la pantalla: cinta de cuatro tiras con la
        // paleta del Danzante (docs/MOCKS.html, notas transversales).
        const Positioned(top: -14, right: 22, child: _Ribbon()),
      ],
    );
  }
}

/// Fila de datos practicos: horario, costo y ubicacion.
///
/// Horario y costo son **opcionales**: si falta el dato se oculta la
/// columna entera, no se escribe "No disponible" (`CONCEPTO.md` §4.3).
class _FactsRow extends StatelessWidget {
  final Attraction attraction;
  final String languageCode;

  const _FactsRow({required this.attraction, required this.languageCode});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final line = AppColors.textDark.withValues(alpha: 0.12);

    final facts = <Widget>[
      if (attraction.schedule != null)
        _Fact(
          icon: Icons.schedule,
          label: l.detailSchedule,
          value: attraction.schedule!.resolve(languageCode),
        ),
      if (attraction.cost != null)
        _Fact(
          icon: Icons.payments_outlined,
          label: l.detailCost,
          value: attraction.cost!.resolve(languageCode),
        ),
      _Fact(
        icon: Icons.place_outlined,
        label: l.detailLocation,
        value: attraction.location.resolve(languageCode),
      ),
    ];

    // Divisores solo ENTRE columnas visibles, para que ocultar una no
    // deje un separador colgando al borde.
    final children = <Widget>[];
    for (var i = 0; i < facts.length; i++) {
      if (i > 0) {
        children.add(VerticalDivider(width: 1, thickness: 1, color: line));
      }
      children.add(Expanded(child: facts[i]));
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
  final IconData icon;
  final String label;
  final String value;

  const _Fact({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.terracotta),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          Text(
            value,
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

class _HowToGetButton extends StatelessWidget {
  final Attraction attraction;
  const _HowToGetButton({required this.attraction});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () => _open(context),
        icon: const Icon(Icons.directions),
        label: Text(l.detailHowToGet),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.terracotta,
          foregroundColor: AppColors.textLight,
          padding: const EdgeInsets.symmetric(vertical: 15),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  Future<void> _open(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final l = AppLocalizations.of(context)!;

    final opened = await context.read<MapsLauncher>().openDirections(
          latitude: attraction.latitude,
          longitude: attraction.longitude,
        );

    // Un error dice que paso, no se disculpa (MOCKS.html, notas
    // transversales). Pasa en un emulador sin app de mapas ni navegador.
    if (!opened) {
      messenger.showSnackBar(SnackBar(content: Text(l.mapsOpenFailed)));
    }
  }
}

/// Galeria horizontal de las fotos adicionales. No son pulsables: si abren
/// un visor a pantalla completa sigue sin decidirse (MOCKS.html, pantalla 3).
class _Gallery extends StatelessWidget {
  final List<String> images;
  const _Gallery({required this.images});

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.of(context).devicePixelRatio;

    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) => ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 104,
            child: Image.asset(
              images[i],
              fit: BoxFit.cover,
              cacheWidth: (104 * dpr).round(),
              errorBuilder: (_, __, ___) => ColoredBox(
                color: AppColors.gold.withValues(alpha: 0.25),
              ),
            ),
          ),
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

String _categoryLabel(AppLocalizations l, AttractionCategory category) {
  switch (category) {
    case AttractionCategory.cultural:
      return l.filterCultural;
    case AttractionCategory.religious:
      return l.filterReligious;
    case AttractionCategory.nature:
      return l.filterNature;
    case AttractionCategory.crafts:
      return l.filterCrafts;
  }
}
