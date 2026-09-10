import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l.mapTitle)),
      body: Center(child: Text(l.mapTitle)),
      // TODO: Google Maps embebido con pines de atractivos agrupados por ruta
      //       (artesano / religiosa / natural).
    );
  }
}
