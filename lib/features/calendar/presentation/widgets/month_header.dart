import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';

/// Encabezado que se repite a lo largo del scroll: mes en dorado, año en
/// terracota (ver `docs/MOCKS.html`, pantalla 4).
class MonthHeader extends StatelessWidget {
  final DateTime date;

  const MonthHeader({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final month = DateFormat.MMMM(locale).format(date);
    // El mes viene en minuscula en español ("junio") y capitalizado en
    // ingles. Se normaliza para que las dos versiones se vean igual.
    final label =
        month.isEmpty ? month : month[0].toUpperCase() + month.substring(1);

    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 12),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label ',
              style: const TextStyle(color: AppColors.gold),
            ),
            TextSpan(
              text: '${date.year}',
              style: const TextStyle(color: AppColors.terracotta),
            ),
          ],
        ),
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
      ),
    );
  }
}
