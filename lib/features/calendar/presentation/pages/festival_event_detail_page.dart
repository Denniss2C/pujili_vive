import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/detail_layout.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/event_status.dart';
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

  /// Inyectable para fijar "ahora" en los tests, igual que en el
  /// calendario. Aqui se lee una vez al pintar y no hay temporizador: el
  /// efecto en vivo es de la lista, que es donde se mira el programa.
  final DateTime Function() now;

  const FestivalEventDetailPage({
    super.key,
    required this.event,
    DateTime Function()? now,
  }) : now = now ?? DateTime.now;

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
    final status = event.statusAt(now());

    return DetailScaffold(
      cover: DetailAssetCover(
        images: event.images,
        // El mismo icono que la tarjeta del calendario, para que la
        // fiesta no cambie de cara al abrirla.
        fallbackIcon: Icons.celebration_outlined,
      ),
      panel: DetailPanel(
        children: [
          // Que este ocurriendo pesa mas que que sea destacada: si las
          // dos cosas son ciertas, se anuncia la que caduca.
          if (status == EventStatus.inProgress) ...[
            _Badge(
              label: l.eventNow,
              background: AppColors.terracotta,
              foreground: AppColors.textLight,
              icon: Icons.play_circle_fill,
            ),
            const SizedBox(height: 10),
          ] else if (event.isHighlighted) ...[
            _Badge(
              label: l.eventHighlighted,
              background: AppColors.gold,
              foreground: AppColors.deepGreen,
              icon: Icons.auto_awesome,
            ),
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

  /// Cuando es la fiesta.
  ///
  /// Tres formas, segun lo que haya:
  /// - Sin hora de fin: solo la fecha.
  /// - Empieza y acaba el mismo dia: fecha y franja horaria, que es el
  ///   caso normal ahora que hay dos fiestas por dia y el dia solo ya no
  ///   las distingue.
  /// - Varios dias: el rango, con el año una sola vez al final ("27 may
  ///   – 4 jun 2027"); las fiestas del canton no cruzan de año.
  @visibleForTesting
  static String formatDate(FestivalEvent event, String locale) {
    final start = event.startDate;
    final end = event.endDate;

    if (end == null) return DateFormat.yMMMd(locale).format(start);

    final sameDay = start.year == end.year &&
        start.month == end.month &&
        start.day == end.day;

    if (sameDay) {
      return '${DateFormat.yMMMd(locale).format(start)} · '
          '${DateFormat.Hm(locale).format(start)} – '
          '${DateFormat.Hm(locale).format(end)}';
    }

    return '${DateFormat.MMMd(locale).format(start)} – '
        '${DateFormat.yMMMd(locale).format(end)}';
  }
}

/// Pildora que dice en que estado esta la fiesta: en curso o destacada.
class _Badge extends StatelessWidget {
  final String label;
  final Color background;
  final Color foreground;
  final IconData icon;

  const _Badge({
    required this.label,
    required this.background,
    required this.foreground,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: foreground),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}
