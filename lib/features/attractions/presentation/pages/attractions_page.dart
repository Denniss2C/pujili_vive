import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/attraction_category.dart';
import '../bloc/attractions_bloc.dart';
import '../widgets/attraction_card.dart';
import 'attraction_detail_page.dart';

class AttractionsPage extends StatelessWidget {
  const AttractionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final lang = Localizations.localeOf(context).languageCode;

    final filters = <MapEntry<String, AttractionCategory?>>[
      MapEntry(l.filterAll, null),
      MapEntry(l.filterCultural, AttractionCategory.cultural),
      MapEntry(l.filterReligious, AttractionCategory.religious),
      MapEntry(l.filterNature, AttractionCategory.nature),
      MapEntry(l.filterCrafts, AttractionCategory.crafts),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l.attractionsTitle)),
      body: BlocBuilder<AttractionsBloc, AttractionsState>(
        builder: (context, state) {
          if (state is AttractionsLoading || state is AttractionsInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AttractionsError) {
            return Center(child: Text(state.message));
          }
          if (state is AttractionsLoaded) {
            return Column(
              children: [
                SizedBox(
                  height: 48,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filters.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final entry = filters[i];
                      final selected = state.activeFilter == entry.value;
                      return ChoiceChip(
                        label: Text(entry.key),
                        selected: selected,
                        onSelected: (_) => context
                            .read<AttractionsBloc>()
                            .add(FilterAttractions(entry.value)),
                        selectedColor: AppColors.terracotta,
                        labelStyle: TextStyle(
                          color: selected
                              ? AppColors.textLight
                              : AppColors.textDark,
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.filtered.length,
                    itemBuilder: (context, i) => AttractionCard(
                      attraction: state.filtered[i],
                      languageCode: lang,
                      onTap: () => AttractionDetailPage.open(
                        context,
                        state.filtered[i],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
