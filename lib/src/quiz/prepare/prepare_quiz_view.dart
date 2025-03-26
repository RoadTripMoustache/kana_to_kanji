import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/l10n/app_localizations.dart";
import "package:kana_to_kanji/src/core/constants/alphabets.dart";
import "package:kana_to_kanji/src/core/widgets/app_scaffold.dart";
import "package:kana_to_kanji/src/core/widgets/chip_list.dart";
import "package:kana_to_kanji/src/quiz/prepare/prepare_quiz_view_model.dart";
import "package:kana_to_kanji/src/quiz/prepare/widgets/alphabet_groups_expansion_tile.dart";
import "package:stacked/stacked.dart";

class PrepareQuizView extends StatelessWidget {
  static const routeName = "/quiz";

  const PrepareQuizView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ViewModelBuilder<PrepareQuizViewModel>.reactive(
      viewModelBuilder: () => PrepareQuizViewModel(GoRouter.of(context)),
      builder:
          (context, viewModel, _) => AppScaffold(
            showBottomBar: true,
            appBar: AppBar(
              title: Text(l10n.quiz_build_title),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              actions: [
                if (viewModel.selectedGroups.isNotEmpty)
                  IconButton(
                    onPressed: viewModel.resetSelected,
                    icon: const Icon(Icons.clear_all_rounded),
                  ),
                IconButton(
                  onPressed: viewModel.onSettingsTapped,
                  icon: const Icon(Icons.settings_rounded),
                ),
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
                        onDeleted:
                            () => viewModel.onGroupCardTapped(
                              viewModel.selectedGroups[index],
                            ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
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
                    ),
                  ),
                ],
              ),
            ),
            fabPosition: FloatingActionButtonLocation.centerFloat,
            fab:
                viewModel.readyToStart
                    ? FloatingActionButton.extended(
                      onPressed: viewModel.startQuiz,
                      label: Text(l10n.quiz_build_ready),
                    )
                    : null,
          ),
    );
  }
}
