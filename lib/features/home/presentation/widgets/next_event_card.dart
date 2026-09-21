import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../calendar/domain/entities/event_status.dart';
import '../../../calendar/domain/entities/festival_event.dart';

/// Tarjeta de la proxima fiesta con cuenta regresiva en vivo.
///
/// Es la pieza mas prominente de Inicio: el calendario es el diferenciador
/// del producto y esta tarjeta es su escaparate (`docs/CONCEPTO.md` §8).
class NextEventCard extends StatefulWidget {
  final FestivalEvent event;
  final String languageCode;
  final VoidCallback onSeeFestival;

  const NextEventCard({
    super.key,
    required this.event,
    required this.languageCode,
    required this.onSeeFestival,
  });

  @override
  State<NextEventCard> createState() => _NextEventCardState();
}

class _NextEventCardState extends State<NextEventCard> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Se refresca cada minuto, no cada segundo: el contador solo muestra
    // dias / horas / minutos. Si mostrara segundos habria que repintar 60
    // veces mas, y si el contador lleva segundos sigue sin decidirse
    // (docs/MOCKS.html, pantalla 1).
    _timer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final live = widget.event.statusAt(now) == EventStatus.inProgress;
    final remaining = widget.event.startDate.difference(now);
    // Una fiesta que ya empezo hoy no muestra numeros negativos.
    final safe = remaining.isNegative ? Duration.zero : remaining;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.terracotta,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 10)],
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.gold,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              // Si la fiesta esta ocurriendo, llamarla "proximo evento"
              // seria mentir: lo proximo es que termine.
              live ? l.eventNow.toUpperCase() : l.nextEvent,
              style: const TextStyle(fontSize: 12, color: AppColors.deepGreen),
            ),
            const SizedBox(height: 2),
            Text(
              widget.event.title.resolve(widget.languageCode),
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                height: 1.2,
                color: AppColors.deepGreen,
              ),
            ),
            const SizedBox(height: 10),
            // Una cuenta regresiva en ceros no dice nada. Mientras la
            // fiesta ocurre, se enseña hasta cuando dura.
            if (live)
              _UntilBlock(endsAt: widget.event.endsAt)
            else
              Row(
                children: [
                  _CountBlock(value: safe.inDays, label: l.days),
                  const SizedBox(width: 6),
                  _CountBlock(value: safe.inHours % 24, label: l.hours),
                  const SizedBox(width: 6),
                  _CountBlock(value: safe.inMinutes % 60, label: l.minutes),
                ],
              ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: widget.onSeeFestival,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.deepGreen,
                  foregroundColor: AppColors.cream,
                ),
                child: Text(l.seeFestival),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reemplaza al contador mientras la fiesta ocurre: hasta que hora va.
///
/// En futuro, no en pasado: la fiesta no ha terminado, termina a esa hora.
class _UntilBlock extends StatelessWidget {
  final DateTime endsAt;

  const _UntilBlock({required this.endsAt});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toLanguageTag();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.deepGreen,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '${l.eventUntil} ${DateFormat.Hm(locale).format(endsAt)}',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColors.cream,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _CountBlock extends StatelessWidget {
  final int value;
  final String label;

  const _CountBlock({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.deepGreen,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              '$value',
              style: const TextStyle(
                color: AppColors.cream,
                fontSize: 17,
                height: 1.1,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: AppColors.cream, fontSize: 9),
            ),
          ],
        ),
      ),
    );
  }
}
