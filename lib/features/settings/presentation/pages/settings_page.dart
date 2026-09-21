import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_info.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/locale_cubit.dart';

/// Ajustes: idioma y "acerca de".
///
/// Sustituye al tab Perfil, que se quedo sin contenido al no haber
/// cuentas de usuario (`docs/CONCEPTO.md` §4.7). No es un tab: se abre
/// desde el engranaje de la cabecera de Inicio, dentro de ese tab.
///
/// **Por que no hay "contacto":** no existe una direccion ni un telefono
/// reales a los que escribir. Inventar uno, o poner el del desarrollador
/// como si fuera el del canton, es peor que no ofrecer la fila.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static Future<void> open(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const SettingsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l.settingsTitle)),
      body: ListView(
        children: [
          _SectionTitle(l.settingsLanguage),
          const _LanguageOptions(),
          const Divider(height: 32),
          _SectionTitle(l.settingsAbout),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Text(
              l.settingsAboutBody,
              style: const TextStyle(
                fontSize: 14,
                height: 1.45,
                color: AppColors.textDark,
              ),
            ),
          ),
          ListTile(
            dense: true,
            title: Text(l.settingsVersion),
            trailing: Text(
              AppInfo.version,
              style: TextStyle(
                color: AppColors.textDark.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Las tres opciones de idioma. "El del telefono" es `null`: no se guarda
/// un idioma, se borra la preferencia.
class _LanguageOptions extends StatelessWidget {
  const _LanguageOptions();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return BlocBuilder<LocaleCubit, Locale?>(
      builder: (context, locale) {
        final selected = locale?.languageCode;

        return RadioGroup<String?>(
          groupValue: selected,
          onChanged: (code) => context.read<LocaleCubit>().change(code),
          child: Column(
            children: [
              for (final option in <({String? code, String label})>[
                (code: null, label: l.settingsLanguageSystem),
                (code: 'es', label: l.settingsLanguageEs),
                (code: 'en', label: l.settingsLanguageEn),
              ])
                RadioListTile<String?>(
                  value: option.code,
                  title: Text(option.label),
                  activeColor: AppColors.terracotta,
                ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
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
