import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/maps_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/detail_layout.dart';
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
///
/// El armazon (portada, panel, cinta, fila de datos) vive en
/// `core/widgets/detail_layout.dart`, compartido con el detalle de evento.
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
    final l = AppLocalizations.of(context)!;
    final lang = Localizations.localeOf(context).languageCode;
    final gallery = attraction.images.skip(1).toList();

    return DetailScaffold(
      cover: DetailAssetCover(
        images: attraction.images,
        fallbackIcon: Icons.image_outlined,
      ),
      panel: DetailPanel(
        children: [
          Text(
            attraction.name.resolve(lang),
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
            attraction.shortDescription.resolve(lang),
            style: const TextStyle(
              fontSize: 14.5,
              height: 1.45,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 18),
          // Horario y costo son opcionales: si falta el dato se oculta la
          // columna entera, no se escribe "No disponible" (§4.3).
          DetailFactsRow(
            facts: [
              if (attraction.schedule != null)
                DetailFact(
                  icon: Icons.schedule,
                  label: l.detailSchedule,
                  value: attraction.schedule!.resolve(lang),
                ),
              if (attraction.cost != null)
                DetailFact(
                  icon: Icons.payments_outlined,
                  label: l.detailCost,
                  value: attraction.cost!.resolve(lang),
                ),
              DetailFact(
                icon: Icons.place_outlined,
                label: l.detailLocation,
                value: attraction.location.resolve(lang),
              ),
            ],
          ),
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
