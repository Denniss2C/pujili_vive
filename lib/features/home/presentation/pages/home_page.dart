import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shell/shell_cubit.dart';
import '../bloc/home_bloc.dart';
import '../widgets/attraction_mini_card.dart';
import '../widgets/next_event_card.dart';

/// Inicio: el escaparate del calendario.
///
/// Dos cosas del diseño **no** se implementan a proposito:
///
/// - El **buscador** del hero. Que indexa y como se ven los resultados es
///   la pregunta abierta nº 3; dibujar un campo que no busca nada es peor
///   que no ponerlo.
/// - El carrusel **"Ruta artesanal"**. Necesita `ArtisanItem`, que no
///   existe, y su contenido esta bloqueado hasta levantar fotos y datos
///   en campo (`docs/CONCEPTO.md` §6.5).
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final lang = Localizations.localeOf(context).languageCode;

    return Scaffold(
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeInitial || state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is! HomeLoaded) {
            return const SizedBox.shrink();
          }

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              const _Hero(),

              // Sin fiestas futuras la tarjeta DESAPARECE y la pantalla
              // arranca en "Que visitar". No se deja un contador en cero.
              if (state.nextEvent != null)
                NextEventCard(
                  event: state.nextEvent!,
                  languageCode: lang,
                  onSeeFestival: () =>
                      context.read<ShellCubit>().select(ShellTab.calendar),
                )
              else if (state.eventsFailed)
                _SectionError(message: l.loadFailed),

              _SectionTitle(l.whatToVisit),
              if (state.attractionsFailed)
                _SectionError(message: l.loadFailed)
              else
                SizedBox(
                  height: 152,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    itemCount: state.attractions.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, i) => AttractionMiniCard(
                      attraction: state.attractions[i],
                      languageCode: lang,
                      // El detalle de atractivo no existe todavia, asi que
                      // se lleva al tab Explorar en vez de no hacer nada.
                      onTap: () =>
                          context.read<ShellCubit>().select(ShellTab.explore),
                    ),
                  ),
                ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}

/// Cabecera con el nombre de la app.
///
/// El diseño pide una foto panoramica de Pujilí y todavia no hay ninguna
/// levantada, asi que se usa un degradado de la paleta en vez de reciclar
/// la foto de otro atractivo, que daria a entender un sitio que no es.
class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Container(
      height: 150,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.deepGreen, AppColors.terracotta],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Text(
          l.appName,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: AppColors.gold,
            letterSpacing: -0.5,
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.deepGreen,
        ),
      ),
    );
  }
}

/// Error acotado a una seccion: el resto de Inicio sigue en pie.
class _SectionError extends StatelessWidget {
  final String message;
  const _SectionError({required this.message});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
      child: Row(
        children: [
          const Icon(Icons.error_outline, size: 18, color: AppColors.gold),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 13, color: AppColors.textDark),
            ),
          ),
          TextButton(
            onPressed: () => context.read<HomeBloc>().add(const LoadHome()),
            child: Text(l.retry),
          ),
        ],
      ),
    );
  }
}
