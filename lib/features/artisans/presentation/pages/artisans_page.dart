import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

class ArtisansPage extends StatelessWidget {
  const ArtisansPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l.artisansTitle)),
      body: Center(child: Text(l.artisansTitle)),
      // TODO: talleres y gastronomía (alfarería, máscaras, hornado, cuy,
      //       tejidos, etc.).
    );
  }
}
