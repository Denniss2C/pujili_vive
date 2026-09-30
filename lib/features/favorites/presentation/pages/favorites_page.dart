import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../attractions/domain/entities/attraction.dart';
import '../../../attractions/presentation/bloc/attractions_bloc.dart';
import '../../../attractions/presentation/pages/attraction_detail_page.dart';
import '../../../attractions/presentation/widgets/attraction_card.dart';
import '../../../calendar/domain/entities/festival_event.dart';
import '../../../calendar/presentation/bloc/calendar_bloc.dart';
import '../../../calendar/presentation/pages/festival_event_detail_page.dart';
import '../../domain/entities/favorite_ref.dart';
import '../cubit/favorites_cubit.dart';

/// Guardados: los atractivos y las fiestas que el usuario marco.
///
/// **No tiene capas domain ni data propias de contenido.** Guarda ids, no
/// copias: los objetos se resuelven contra los bloc de `attractions` y
/// `calendar` que ya provee la raiz. Asi un guardado nunca enseña datos
/// viejos, y si un atractivo desaparece del JSON su guardado simplemente
/// deja de aparecer en vez de quedar como una ficha rota.
///
/// No es un tab: se abre desde el corazon de la cabecera de Inicio, igual
/// que Ajustes desde el engranaje. Los cinco tabs estan tomados.
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  static Future<void> open(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const FavoritesPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final lang = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(l.savedTitle)),
      body: BlocBuilder<FavoritesCubit, Set<FavoriteRef>>(
        builder: (context, favorites) {
          if (favorites.isEmpty) return _Empty(l: l);

          final attractions = _resolveAttractions(context, favorites);
          final festivals = _resolveFestivals(context, favorites);

          // Puede haber guardados cuyos objetos ya no existen en los
          // datos: entonces la pantalla queda vacia aunque el conjunto no
          // lo este, y hay que decirlo igual.
          if (attractions.isEmpty && festivals.isEmpty) return _Empty(l: l);

          return ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              if (attractions.isNotEmpty) ...[
                _SectionTitle(l.savedAttractions),
                for (final attraction in attractions)
                  AttractionCard(
                    attraction: attraction,
                    languageCode: lang,
                    onTap: () => AttractionDetailPage.open(context, attraction),
                  ),
              ],
              if (festivals.isNotEmpty) ...[
                _SectionTitle(l.savedFestivals),
                for (final event in festivals)
                  _FestivalRow(
                    event: event,
                    languageCode: lang,
                    onTap: () => FestivalEventDetailPage.open(context, event),
                  ),
              ],
            ],
          );
        },
      ),
    );
  }

  static List<Attraction> _resolveAttractions(
    BuildContext context,
    Set<FavoriteRef> favorites,
  ) {
    final state = context.watch<AttractionsBloc>().state;
    if (state is! AttractionsLoaded) return const [];

    final ids = favorites
        .where((f) => f.kind == FavoriteKind.attraction)
        .map((f) => f.id)
        .toSet();

    return state.all.where((a) => ids.contains(a.id)).toList();
  }

  static List<FestivalEvent> _resolveFestivals(
    BuildContext context,
    Set<FavoriteRef> favorites,
  ) {
    final state = context.watch<CalendarBloc>().state;
    if (state is! CalendarLoaded) return const [];

    final ids = favorites
        .where((f) => f.kind == FavoriteKind.festival)
        .map((f) => f.id)
        .toSet();

    return state.all.where((e) => ids.contains(e.id)).toList();
  }
}

class _Empty extends StatelessWidget {
  final AppLocalizations l;

  const _Empty({required this.l});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 54,
              color: AppColors.terracotta.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 14),
            Text(
              l.savedEmptyTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            // Un vacio dice que hacer a continuacion, no solo que no hay
            // nada (docs/MOCKS.html, notas transversales).
            Text(
              l.savedEmptyBody,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: AppColors.textDark.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Fila de fiesta guardada.
///
/// No se reutiliza la tarjeta del calendario: aquella va enganchada a la
/// linea de tiempo y arrastra el nodo y el estado en vivo, que aqui no
/// tienen donde apoyarse.
class _FestivalRow extends StatelessWidget {
  final FestivalEvent event;
  final String languageCode;
  final VoidCallback onTap;

  const _FestivalRow({
    required this.event,
    required this.languageCode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();

    return ListTile(
      onTap: onTap,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 48,
          height: 48,
          child: ColoredBox(
            color: AppColors.gold.withValues(alpha: 0.25),
            child: const Icon(Icons.celebration_outlined, size: 22),
          ),
        ),
      ),
      title: Text(
        event.title.resolve(languageCode),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 14.5,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
      ),
      subtitle: Text(
        DateFormat.yMMMd(locale).add_Hm().format(event.startDate),
        style: TextStyle(
          fontSize: 12.5,
          color: AppColors.textDark.withValues(alpha: 0.7),
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.terracotta),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.4,
          color: AppColors.terracotta,
        ),
      ),
    );
  }
}
