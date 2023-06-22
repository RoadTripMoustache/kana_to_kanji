import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kana_to_kanji/src/core/widgets/app_scaffold.dart';
import 'package:kana_to_kanji/src/quiz/build_quiz_view_model.dart';
import 'package:kana_to_kanji/src/quiz/constants/alphabets.dart';
import 'package:kana_to_kanji/src/quiz/widgets/group_card.dart';
import 'package:stacked/stacked.dart';

class BuildQuizView extends StatelessWidget {
  static const routeName = "/quiz";

  const BuildQuizView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ViewModelBuilder<BuildQuizViewModel>.reactive(
      viewModelBuilder: () => BuildQuizViewModel(),
      builder: (context, viewModel, _) => AppScaffold(
          appBar: AppBar(
            title: Text(l10n.quiz_build_title),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Wrap(
                  spacing: 6.0,
                  runSpacing: 4.0,
                  children: List.generate(
                      viewModel.selectedGroups.length,
                      (index) => Chip(
                            label: Text(viewModel.selectedGroups[index].name),
                            onDeleted: () => viewModel.onGroupCardTapped(
                                viewModel.selectedGroups[index]),
                          )),
                ),
                ExpansionTile(
                  title: Text(l10n.hiragana),
                  initiallyExpanded: true,
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 3.5, crossAxisCount: 2),
                      itemCount: viewModel.getGroup(Alphabets.hiragana).length,
                      itemBuilder: (context, index) => GroupCard(
                          isChecked: viewModel.selectedGroups.contains(
                              viewModel.getGroup(Alphabets.hiragana)[index]),
                          onTap: viewModel.onGroupCardTapped,
                          group: viewModel.getGroup(Alphabets.hiragana)[index]),
                    )
                  ],
                ),
                ExpansionTile(
                  title: Text(l10n.katakana),
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 3.5, crossAxisCount: 2),
                      itemCount: viewModel.getGroup(Alphabets.katakana).length,
                      itemBuilder: (context, index) => GroupCard(
                          isChecked: viewModel.selectedGroups.contains(
                              viewModel.getGroup(Alphabets.katakana)[index]),
                          onTap: viewModel.onGroupCardTapped,
                          group: viewModel.getGroup(Alphabets.katakana)[index]),
                    )
                  ],
                )
              ],
            ),
          ),
          fabPosition: FloatingActionButtonLocation.centerFloat,
          fab: viewModel.readyToStart
              ? FloatingActionButton.extended(
                  onPressed: () {},
                  label: Text(l10n.quiz_build_ready),
                )
              : null),
    );
  }
}
