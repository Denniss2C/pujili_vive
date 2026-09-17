import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../attractions/domain/entities/attraction.dart';

/// Tarjeta pequeña de los carruseles de Inicio: foto arriba y nombre sobre
/// un pie de color. El color distingue la seccion sin repetir un titulo de
/// categoria (`docs/MOCKS.html`, pantalla 1).
class AttractionMiniCard extends StatelessWidget {
  final Attraction attraction;
  final String languageCode;
  final VoidCallback? onTap;

  const AttractionMiniCard({
    super.key,
    required this.attraction,
    required this.languageCode,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    // Se decodifica al ancho real de la tarjeta, no al de la foto: son
    // 128 dp, no la pantalla entera (project_rules/11_performance_rules).
    final cacheWidth = (128 * media.devicePixelRatio).round();

    final placeholder = ColoredBox(
      color: AppColors.gold.withValues(alpha: 0.25),
      child: const Center(child: Icon(Icons.image_outlined, size: 28)),
    );

    return SizedBox(
      width: 128,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
              ),
              child: SizedBox(
                height: 86,
                child: attraction.images.isEmpty
                    ? placeholder
                    : Image.asset(
                        attraction.images.first,
                        fit: BoxFit.cover,
                        cacheWidth: cacheWidth,
                        errorBuilder: (_, __, ___) => placeholder,
                      ),
              ),
            ),
            // Expanded y no una altura fija: los nombres largos ocupan
            // tres lineas ("Santuario del Niño de Isinche") y con alto
            // fijo la columna desbordaba.
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.deepGreen,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(14),
                  ),
                ),
                child: Text(
                  attraction.name.resolve(languageCode),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.cream,
                    fontSize: 12,
                    height: 1.25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
