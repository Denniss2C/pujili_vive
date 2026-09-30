import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/favorite_ref.dart';
import '../cubit/favorites_cubit.dart';

/// Corazon para guardar y dejar de guardar.
///
/// Va sobre la foto de las pantallas de detalle, al lado del boton de
/// retroceso, con el mismo circulo translucido: son los dos controles que
/// flotan sobre la portada y tienen que leerse igual.
class FavoriteButton extends StatelessWidget {
  final FavoriteRef favorite;

  const FavoriteButton({super.key, required this.favorite});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return BlocBuilder<FavoritesCubit, Set<FavoriteRef>>(
      builder: (context, favorites) {
        final saved = favorites.contains(favorite);

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.6),
              ),
              child: IconButton(
                onPressed: () =>
                    context.read<FavoritesCubit>().toggle(favorite),
                icon: Icon(saved ? Icons.favorite : Icons.favorite_border),
                color: AppColors.terracotta,
                tooltip: saved ? l.unsaveAction : l.saveAction,
              ),
            ),
          ),
        );
      },
    );
  }
}
