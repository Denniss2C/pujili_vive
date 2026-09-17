import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/attraction.dart';

class AttractionCard extends StatelessWidget {
  final Attraction attraction;
  final String languageCode;
  final VoidCallback? onTap;

  const AttractionCard({
    super.key,
    required this.attraction,
    required this.languageCode,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ColoredBox(
                color: AppColors.gold.withValues(alpha: 0.25),
                child: attraction.images.isNotEmpty
                    ? Image.asset(
                        attraction.images.first,
                        fit: BoxFit.cover,
                        // Sin cacheWidth, Flutter decodifica la foto a su
                        // tamaño original y la deja entera en memoria: una
                        // imagen de 2554 px ocupa ~19 MB de RAM para
                        // pintarse en una tarjeta de 360 dp. Se acota al
                        // ancho real del dispositivo en pixeles fisicos.
                        cacheWidth: _cacheWidth(context),
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.image_outlined, size: 40),
                        ),
                      )
                    : const Center(child: Icon(Icons.image_outlined, size: 40)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    attraction.name.resolve(languageCode),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.terracotta,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    attraction.shortDescription.resolve(languageCode),
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.place_outlined,
                        size: 16,
                        color: AppColors.gold,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          attraction.location.resolve(languageCode),
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.gold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Ancho al que decodificar la foto: el de la pantalla en pixeles
  /// fisicos. La tarjeta ocupa el ancho completo menos los margenes, asi
  /// que decodificar mas es tirar memoria.
  int _cacheWidth(BuildContext context) {
    final media = MediaQuery.of(context);
    return (media.size.width * media.devicePixelRatio).round();
  }
}
