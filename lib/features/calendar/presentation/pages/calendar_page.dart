import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/festival_event.dart';
import '../bloc/calendar_bloc.dart';
import '../widgets/festival_event_card.dart';
import '../widgets/month_header.dart';
import 'festival_event_detail_page.dart';

/// El calendario de fiestas: el diferenciador del producto
/// (ver `docs/CONCEPTO.md` §8).
///
/// La lista **esta viva**: mira el reloj y va cambiando el aspecto de las
/// tarjetas segun avanza el dia. Ver [FestivalEventCard] para los tres
/// tratamientos.
class CalendarPage extends StatefulWidget {
  /// Inyectable para poder fijar "ahora" en los tests: de el depende que
  /// tarjeta sale blanca y cual atenuada.
  final DateTime Function() now;

  const CalendarPage({super.key, DateTime Function()? now})
      : now = now ?? DateTime.now;

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l.calendarTitle)),
      body: BlocBuilder<CalendarBloc, CalendarState>(
        builder: (context, state) {
          if (state is CalendarInitial || state is CalendarLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CalendarError) {
            return _Message(
              icon: Icons.error_outline,
              title: l.errorTitle,
              body: state.message,
              actionLabel: l.retry,
              onAction: () =>
                  context.read<CalendarBloc>().add(const LoadFestivalEvents()),
            );
          }

          if (state is CalendarLoaded) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 6),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => context
                        .read<CalendarBloc>()
                        .add(SearchFestivalEvents(value)),
                    decoration: InputDecoration(
                      hintText: l.searchEvents,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(99),
                      ),
                      isDense: true,
                    ),
                  ),
                ),
                Expanded(child: _Body(state: state, now: widget.now)),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final CalendarLoaded state;
  final DateTime Function() now;

  const _Body({required this.state, required this.now});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    // Un estado vacio dice que hacer a continuacion, no solo que no hay
    // nada. Y "no hay fiestas" y "tu busqueda no encontro nada" son dos
    // cosas distintas, asi que se explican distinto.
    if (state.isEmptySearch) {
      return _Message(
        icon: Icons.search_off,
        title: l.calendarNoResultsTitle,
        body: l.calendarNoResultsBody,
      );
    }
    if (state.filtered.isEmpty) {
      return _Message(
        icon: Icons.event_busy,
        title: l.calendarEmptyTitle,
        body: l.calendarEmptyBody,
      );
    }

    return _Timeline(events: state.filtered, now: now);
  }
}

/// Linea de tiempo vertical: recorre la lista **ya ordenada** e inserta un
/// encabezado cada vez que cambia el mes.
///
/// Es la que **mira el reloj**: se repinta sola para que una fiesta pase
/// a blanca cuando le llega la hora y se atenue cuando termina, sin que
/// el usuario toque nada.
class _Timeline extends StatefulWidget {
  final List<FestivalEvent> events;
  final DateTime Function() now;

  const _Timeline({required this.events, required this.now});

  @override
  State<_Timeline> createState() => _TimelineState();
}

class _TimelineState extends State<_Timeline> {
  /// Cada 30 s y no cada minuto: las fiestas empiezan y acaban en punto,
  /// asi que con un tick de un minuto la tarjeta podria tardar hasta 59 s
  /// en reaccionar. Repintar es barato: el `ListView` es perezoso y solo
  /// reconstruye lo que se ve.
  static const _tick = Duration(seconds: 30);

  late DateTime _now;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _now = widget.now();
    _timer = Timer.periodic(_tick, (_) {
      if (mounted) setState(() => _now = widget.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final events = widget.events;

    // Se aplana a una lista de filas (encabezado o tarjeta) para poder
    // usar un solo ListView perezoso en vez de anidar scrolls.
    final rows = <_Row>[];
    DateTime? lastMonth;
    for (final event in events) {
      final month = DateTime(event.startDate.year, event.startDate.month);
      if (lastMonth == null || month != lastMonth) {
        rows.add(_Row.header(month));
        lastMonth = month;
      }
      rows.add(_Row.event(event));
    }

    return Stack(
      children: [
        // La linea continua va detras de todo, por el borde izquierdo.
        Positioned(
          left: 31,
          top: 0,
          bottom: 24,
          child: Container(
            width: 2,
            color: AppColors.gold.withValues(alpha: 0.55),
          ),
        ),
        ListView.builder(
          padding: const EdgeInsets.fromLTRB(18, 4, 18, 20),
          itemCount: rows.length,
          itemBuilder: (context, i) {
            final row = rows[i];
            if (row.month != null) {
              return MonthHeader(date: row.month!);
            }
            return FestivalEventCard(
              event: row.event!,
              languageCode: lang,
              // El reloj se mira una vez por tick, no una por tarjeta.
              status: row.event!.statusAt(_now),
              // Se abre dentro del tab Calendario: el tab no cambia.
              onTap: () => FestivalEventDetailPage.open(context, row.event!),
            );
          },
        ),
      ],
    );
  }
}

/// Fila de la lista: o es encabezado de mes, o es una fiesta.
class _Row {
  final DateTime? month;
  final FestivalEvent? event;

  const _Row._(this.month, this.event);

  factory _Row.header(DateTime month) => _Row._(month, null);
  factory _Row.event(FestivalEvent event) => _Row._(null, event);
}

/// Mensaje a pantalla completa para vacios y errores.
class _Message extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _Message({
    required this.icon,
    required this.title,
    required this.body,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 44, color: AppColors.gold),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              body,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: AppColors.textDark),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
