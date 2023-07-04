import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:kana_to_kanji/src/core/widgets/app_scaffold.dart';
import 'package:kana_to_kanji/src/build_quiz/build_quiz_view_model.dart';
import 'package:kana_to_kanji/src/core/constants/alphabets.dart';
import 'package:kana_to_kanji/src/build_quiz/widgets/alphabet_groups_expansion_tile.dart';
import 'package:kana_to_kanji/src/core/widgets/chip_list.dart';
import 'package:stacked/stacked.dart';

class BuildQuizView extends StatelessWidget {
  static const routeName = "/quiz/build";

  const BuildQuizView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ViewModelBuilder<BuildQuizViewModel>.reactive(
      viewModelBuilder: () => BuildQuizViewModel(GoRouter.of(context)),
      builder: (context, viewModel, _) => AppScaffold(
          appBar: AppBar(
            title: Text(l10n.quiz_build_title),
            actions: [
              if (viewModel.selectedGroups.isNotEmpty)
                IconButton(
                    onPressed: viewModel.resetSelected,
                    icon: const Icon(Icons.clear_all))
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                ChipList(
                  emptyListLabel: Text(l10n.quiz_build_nothing_selected),
                  children: List.generate(
                      viewModel.selectedGroups.length,
                      (index) => Chip(
                            label: Text(viewModel.selectedGroups[index].name),
                            onDeleted: () => viewModel.onGroupCardTapped(
                                viewModel.selectedGroups[index]),
                          )),
                ),
                Card(
                  child: Column(
                    children: [
                      AlphabetGroupsExpansionTile(
                        alphabet: Alphabets.hiragana,
                        groups: viewModel.getGroup(Alphabets.hiragana),
                        selectedGroups: viewModel.selectedGroups,
                        onGroupTapped: viewModel.onGroupCardTapped,
                        onSelectAllTapped: viewModel.onSelectAllTapped,
                        initiallyExpanded: true,
                      ),
                      const Divider(height: 0),
                      AlphabetGroupsExpansionTile(
                        alphabet: Alphabets.katakana,
                        groups: viewModel.getGroup(Alphabets.katakana),
                        selectedGroups: viewModel.selectedGroups,
                        onGroupTapped: viewModel.onGroupCardTapped,
                        onSelectAllTapped: viewModel.onSelectAllTapped,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          fabPosition: FloatingActionButtonLocation.centerFloat,
          fab: viewModel.readyToStart
              ? FloatingActionButton.extended(
                  onPressed: viewModel.startQuiz,
                  label: Text(l10n.quiz_build_ready),
                )
              : null),
    );
  }
}
