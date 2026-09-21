import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/detail_layout.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/festival_event.dart';

/// Detalle de una fiesta.
///
/// Cierra el flujo del diferenciador del producto: se llega desde el
/// Calendario y desde la tarjeta de cuenta regresiva de Inicio
/// (`docs/CONCEPTO.md` §4.1 y §4.4), y hasta ahora ninguna de las dos
/// llevaba a ningun sitio.
///
/// **Por que se parece tanto al detalle de atractivo:** la pantalla no
/// estaba diseñada (pregunta abierta nº 6) y la respuesta acordada fue
/// reutilizar ese layout. El armazon comun vive en
/// `core/widgets/detail_layout.dart`, asi que aqui solo esta lo que
/// cambia: que datos se muestran y como se formatean.
///
/// **Por que no hay boton "Como llegar":** [FestivalEvent] no tiene
/// coordenadas, solo una etiqueta de sitio en texto. `MapsLauncher` pide
/// latitud y longitud, y abrir la ruta hacia un punto inventado seria
/// peor que no ofrecerla. Vuelve cuando la entidad tenga el dato.
class FestivalEventDetailPage extends StatelessWidget {
  final FestivalEvent event;

  const FestivalEventDetailPage({super.key, required this.event});

  /// Empuja el detalle **dentro del tab activo**, igual que el de
  /// atractivo: la barra inferior sigue visible y el tab no cambia.
  static Future<void> open(BuildContext context, FestivalEvent event) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => FestivalEventDetailPage(event: event),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final lang = Localizations.localeOf(context).languageCode;
    final locale = Localizations.localeOf(context).toLanguageTag();

    return DetailScaffold(
      cover: DetailAssetCover(
        images: event.images,
        // El mismo icono que la tarjeta del calendario, para que la
        // fiesta no cambie de cara al abrirla.
        fallbackIcon: Icons.celebration_outlined,
      ),
      panel: DetailPanel(
        children: [
          // `isHighlighted` ya distingue la tarjeta en la linea de
          // tiempo; aqui se dice con palabras para que no se pierda.
          if (event.isHighlighted) ...[
            _HighlightBadge(label: l.eventHighlighted),
            const SizedBox(height: 10),
          ],
          Text(
            event.title.resolve(lang),
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
              height: 1.15,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            event.shortDescription.resolve(lang),
            style: const TextStyle(
              fontSize: 14.5,
              height: 1.45,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 18),
          // La ubicacion es opcional y hoy falta en la mitad de las
          // fiestas: si no esta, se cae la columna y queda solo la fecha.
          DetailFactsRow(
            facts: [
              DetailFact(
                icon: Icons.event,
                label: l.detailDate,
                value: formatDate(event, locale),
              ),
              if (event.location != null)
                DetailFact(
                  icon: Icons.place_outlined,
                  label: l.detailLocation,
                  value: event.location!.resolve(lang),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// Fecha de la fiesta, o el rango si dura varios dias.
  ///
  /// En un rango el año va solo al final ("27 may – 4 jun 2027"): las
  /// fiestas del canton no cruzan de un año al siguiente.
  @visibleForTesting
  static String formatDate(FestivalEvent event, String locale) {
    final start = event.startDate;
    final end = event.endDate;

    if (end == null) return DateFormat.yMMMd(locale).format(start);

    return '${DateFormat.MMMd(locale).format(start)} – '
        '${DateFormat.yMMMd(locale).format(end)}';
  }
}

/// Pildora dorada que marca las fiestas destacadas.
class _HighlightBadge extends StatelessWidget {
  final String label;

  const _HighlightBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.gold,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.auto_awesome, size: 13, color: AppColors.deepGreen),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.deepGreen,
            ),
          ),
        ],
      ),
    );
  }
}
