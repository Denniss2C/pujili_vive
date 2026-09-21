import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../attractions/domain/entities/attraction.dart';
import '../../../attractions/domain/entities/attraction_category.dart';
import '../../../attractions/presentation/pages/attraction_detail_page.dart';

/// Sheet arrastrable "Explorar lugares" (`docs/MOCKS.html`, pantalla 5).
///
/// Lee datos locales, asi que **sigue funcionando aunque el mapa no
/// cargue** —sin red o sin API key—, que es lo que pide el diseño
/// (`docs/CONCEPTO.md` §4.5, Estados).
///
/// **Sin distancias.** El diseño escribe "Artesanía · 0,5 km" en cada
/// fila, pero no existe el campo y calcularlo depende de si la app pide
/// geolocalizacion, que es la pregunta abierta nº 9. La fila enseña solo
/// la categoria: media linea de verdad antes que una distancia inventada.
class PlacesSheet extends StatelessWidget {
  final List<Attraction> places;

  const PlacesSheet({super.key, required this.places});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final lang = Localizations.localeOf(context).languageCode;

    return DraggableScrollableSheet(
      initialChildSize: 0.45,
      minChildSize: 0.12,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        // Material y no DecoratedBox: las filas son ListTile y pintan su
        // fondo y su ink sobre el Material mas cercano. Con un
        // DecoratedBox de por medio, el toque no se ve.
        return Material(
          color: AppColors.cream,
          elevation: 8,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          clipBehavior: Clip.antiAlias,
          child: ListView.separated(
            controller: scrollController,
            padding: EdgeInsets.zero,
            // Cabecera (asa + titulo) y, si no hay lugares, el aviso.
            itemCount: places.isEmpty ? 2 : places.length + 1,
            separatorBuilder: (_, i) =>
                i == 0 ? const SizedBox.shrink() : const Divider(height: 1),
            itemBuilder: (context, i) {
              if (i == 0) return _Header(title: l.explorePlaces);

              if (places.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                  child: Text(
                    l.mapRouteEmpty,
                    style: TextStyle(
                      color: AppColors.textDark.withValues(alpha: 0.7),
                    ),
                  ),
                );
              }

              final place = places[i - 1];
              return _PlaceRow(
                place: place,
                languageCode: lang,
                onTap: () => AttractionDetailPage.open(context, place),
              );
            },
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  final String title;

  const _Header({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Asa: la pista de que el sheet se arrastra.
        Container(
          width: 40,
          height: 4,
          margin: const EdgeInsets.only(top: 10, bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.textDark.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PlaceRow extends StatelessWidget {
  final Attraction place;
  final String languageCode;
  final VoidCallback onTap;

  const _PlaceRow({
    required this.place,
    required this.languageCode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return ListTile(
      onTap: onTap,
      leading: _Thumbnail(images: place.images),
      title: Text(
        place.name.resolve(languageCode),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 14.5,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
      ),
      subtitle: Text(
        _categoryLabel(l, place.category),
        style: TextStyle(
          fontSize: 12.5,
          color: AppColors.textDark.withValues(alpha: 0.7),
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.terracotta),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  final List<String> images;

  const _Thumbnail({required this.images});

  @override
  Widget build(BuildContext context) {
    final placeholder = ColoredBox(
      color: AppColors.gold.withValues(alpha: 0.25),
      child: const Icon(Icons.photo_outlined, size: 20),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 48,
        height: 48,
        child: images.isEmpty
            ? placeholder
            : Image.asset(
                images.first,
                fit: BoxFit.cover,
                cacheWidth: 96,
                errorBuilder: (_, __, ___) => placeholder,
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
