import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/festival_event.dart';

/// Tarjeta de una fiesta, enganchada a la linea de tiempo.
///
/// Tiene **dos jerarquias visuales** (ver `docs/MOCKS.html`, pantalla 4):
/// la destacada lleva doble marco y nodo grande; la normal, nodo pequeño
/// y foto circular. Solo cambia el tratamiento, nunca el orden.
class FestivalEventCard extends StatelessWidget {
  final FestivalEvent event;
  final String languageCode;

  /// Abre el detalle de la fiesta. Obligatorio: una tarjeta que no lleva
  /// a ningun sitio fue el hueco que dejo esta pantalla al nacer.
  final VoidCallback onTap;

  const FestivalEventCard({
    super.key,
    required this.event,
    required this.languageCode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final highlighted = event.isHighlighted;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TimelineNode(highlighted: highlighted),
          const SizedBox(width: 12),
          Expanded(
            // Pulsable la tarjeta, no el nodo de la linea de tiempo: el
            // nodo es adorno de la linea y pertenece a la lista entera.
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: EdgeInsets.all(highlighted ? 10 : 0),
                decoration: highlighted
                    ? BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.gold, width: 2),
                        boxShadow: const [
                          BoxShadow(color: AppColors.shadow, blurRadius: 10),
                        ],
                      )
                    : null,
                child: Row(
                  children: [
                    _Photo(event: event, highlighted: highlighted),
                    const SizedBox(width: 12),
                    _DateBlock(date: event.startDate),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
  }
}

/// El punto sobre la linea vertical. Grande y terracota si destaca.
class _TimelineNode extends StatelessWidget {
  final bool highlighted;
  const _TimelineNode({required this.highlighted});

  @override
  Widget build(BuildContext context) {
    final size = highlighted ? 28.0 : 10.0;
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
              color: highlighted ? AppColors.terracotta : AppColors.gold,
              border: Border.all(
                color: highlighted ? AppColors.gold : AppColors.cream,
                width: highlighted ? 3 : 2,
              ),
            ),
            child: highlighted
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

/// Foto de la fiesta: rectangular si destaca, circular si no.
/// Aun no hay fotos reales, asi que cae a un marcador por color.
class _Photo extends StatelessWidget {
  final FestivalEvent event;
  final bool highlighted;

  const _Photo({required this.event, required this.highlighted});

  @override
  Widget build(BuildContext context) {
    final side = highlighted ? 74.0 : 66.0;
    final radius = highlighted
        ? BorderRadius.circular(8)
        : BorderRadius.circular(side / 2);

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

/// Bloque de fecha en terracota: dia grande, mes abreviado debajo.
class _DateBlock extends StatelessWidget {
  final DateTime date;
  const _DateBlock({required this.date});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final month = DateFormat.MMM(locale).format(date).toUpperCase();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.terracotta,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${date.day}',
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
        ],
      ),
    );
  }
}
