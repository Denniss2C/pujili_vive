import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l.calendarTitle)),
      body: Center(child: Text(l.calendarTitle)),
      // TODO: timeline de fiestas (Corpus Christi, Octava, Virgen del Carmen,
      //       San Lorenzo). Este es el diferenciador clave del MVP.
    );
  }
}
