import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/event_status.dart';
import '../../domain/entities/festival_event.dart';

/// Tarjeta de una fiesta, enganchada a la linea de tiempo.
///
/// Tiene **tres tratamientos**, y el que manda es el reloj:
///
/// | Estado | Aspecto |
/// | --- | --- |
/// | [EventStatus.inProgress] | Blanca, con marco dorado, sombra y la etiqueta "Ahora" |
/// | Destacada y aun no empieza | Marco dorado sin relleno |
/// | [EventStatus.past] | Atenuada |
/// | El resto | Simple |
///
/// El blanco **ya no sale del JSON**: antes lo ponia `isHighlighted` y
/// era fijo. Ahora significa "esto esta pasando ahora mismo" y la
/// pantalla cambia sola segun avanza el dia. `isHighlighted` se queda
/// para lo que siempre quiso decir —esta fiesta importa mas que las
/// otras— con un tratamiento propio que no se confunde con el otro.
///
/// El estado llega de fuera y no se calcula aqui: quien pinta la lista
/// mira el reloj una vez por tick, no una vez por tarjeta.
class FestivalEventCard extends StatelessWidget {
  final FestivalEvent event;
  final String languageCode;
  final EventStatus status;

  /// Abre el detalle de la fiesta. Obligatorio: una tarjeta que no lleva
  /// a ningun sitio fue el hueco que dejo esta pantalla al nacer.
  final VoidCallback onTap;

  const FestivalEventCard({
    super.key,
    required this.event,
    required this.languageCode,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final live = status == EventStatus.inProgress;
    final past = status == EventStatus.past;
    // Una fiesta que ya paso no se anuncia como destacada: lo que
    // importa de ella es que termino.
    final featured = event.isHighlighted && !live && !past;

    final card = IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TimelineNode(live: live, featured: featured, past: past),
          const SizedBox(width: 12),
          Expanded(
            // Pulsable la tarjeta, no el nodo de la linea de tiempo: el
            // nodo es adorno de la linea y pertenece a la lista entera.
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: EdgeInsets.all(live || featured ? 10 : 0),
                decoration: _decorationFor(live: live, featured: featured),
                child: Row(
                  children: [
                    _Photo(event: event, live: live),
                    const SizedBox(width: 12),
                    _TimeBlock(event: event, live: live),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (live) ...[
                            _NowBadge(label: l.eventNow),
                            const SizedBox(height: 5),
                          ],
                          Text(
                            event.title.resolve(languageCode),
                            style: const TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            event.shortDescription.resolve(languageCode),
                            style: const TextStyle(
                              fontSize: 12.5,
                              height: 1.35,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    // Atenuada y no oculta: se ve por donde va el programa y se puede
    // seguir consultando lo que ya paso (`CONCEPTO.md` §9, pregunta 4).
    return past ? Opacity(opacity: 0.45, child: card) : card;
  }

  static BoxDecoration? _decorationFor({
    required bool live,
    required bool featured,
  }) {
    if (live) {
      return BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gold, width: 2),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 10),
        ],
      );
    }
    if (featured) {
      // Marco dorado SIN relleno: se distingue de la tarjeta en curso,
      // que es la unica blanca.
      return BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gold, width: 1.5),
      );
    }
    return null;
  }
}

/// La etiqueta que dice, con palabras, por que la tarjeta esta blanca.
class _NowBadge extends StatelessWidget {
  final String label;

  const _NowBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.terracotta,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 9.5,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.6,
          color: AppColors.textLight,
        ),
      ),
    );
  }
}

/// El punto sobre la linea vertical. Grande y terracota si esta en curso.
class _TimelineNode extends StatelessWidget {
  final bool live;
  final bool featured;
  final bool past;

  const _TimelineNode({
    required this.live,
    required this.featured,
    required this.past,
  });

  @override
  Widget build(BuildContext context) {
    final size = live
        ? 28.0
        : featured
            ? 16.0
            : 10.0;

    return SizedBox(
      width: 28,
      child: Column(
        children: [
          const SizedBox(height: 24),
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: live
                  ? AppColors.terracotta
                  : past
                      ? AppColors.textDark.withValues(alpha: 0.3)
                      : AppColors.gold,
              border: Border.all(
                color: live ? AppColors.gold : AppColors.cream,
                width: live ? 3 : 2,
              ),
            ),
            child: live
                ? const Icon(
                    Icons.auto_awesome,
                    size: 12,
                    color: AppColors.gold,
                  )
                : null,
          ),
        ],
      ),
    );
  }
}

/// Foto de la fiesta: rectangular si esta en curso, circular si no.
/// Aun no hay fotos reales, asi que cae a un marcador por color.
class _Photo extends StatelessWidget {
  final FestivalEvent event;
  final bool live;

  const _Photo({required this.event, required this.live});

  @override
  Widget build(BuildContext context) {
    final side = live ? 74.0 : 66.0;
    final radius =
        live ? BorderRadius.circular(8) : BorderRadius.circular(side / 2);

    final placeholder = ColoredBox(
      color: AppColors.gold.withValues(alpha: 0.25),
      child: const Center(
        child: Icon(Icons.celebration_outlined, size: 26),
      ),
    );

    return ClipRRect(
      borderRadius: radius,
      child: SizedBox(
        width: side,
        height: side,
        child: event.images.isEmpty
            ? placeholder
            : Image.asset(
                event.images.first,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => placeholder,
              ),
      ),
    );
  }
}

/// Bloque de fecha en terracota: dia grande, mes y hora debajo.
///
/// Lleva la hora porque ahora hay **dos fiestas por dia** y el dia solo
/// ya no las distingue.
class _TimeBlock extends StatelessWidget {
  final FestivalEvent event;
  final bool live;

  const _TimeBlock({required this.event, required this.live});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final month = DateFormat.MMM(locale).format(event.startDate).toUpperCase();
    final time = DateFormat.Hm(locale).format(event.startDate);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: live ? AppColors.deepGreen : AppColors.terracotta,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${event.startDate.day}',
            style: const TextStyle(
              color: AppColors.textLight,
              fontSize: 17,
              height: 1,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            month,
            style: const TextStyle(
              color: AppColors.textLight,
              fontSize: 9.5,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            time,
            style: const TextStyle(
              color: AppColors.textLight,
              fontSize: 10.5,
              height: 1,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
