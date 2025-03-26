import "package:flutter/material.dart";
import "package:kana_to_kanji/l10n/app_localizations.dart";
import "package:kana_to_kanji/src/core/constants/alphabets.dart";
import "package:kana_to_kanji/src/core/models/group.dart";
import "package:kana_to_kanji/src/quiz/prepare/widgets/group_card.dart";
import "package:kana_to_kanji/src/quiz/prepare/widgets/kana_groups.dart";

class AlphabetGroupsExpansionTile extends StatelessWidget {
  final Alphabets alphabet;

  final bool initiallyExpanded;

  final List<Group> groups;

  final List<Group> selectedGroups;

  final Function(Group) onGroupTapped;

  final Function(List<Group> groups, {bool toAdd}) onSelectAllTapped;

  const AlphabetGroupsExpansionTile({
    required this.alphabet,
    required this.groups,
    required this.selectedGroups,
    required this.onGroupTapped,
    required this.onSelectAllTapped,
    super.key,
    this.initiallyExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final areAllSelected =
        selectedGroups
            .where((element) => element.alphabet == alphabet)
            .length ==
        groups.length;

    String title;
    String multiselectButtonText =
        areAllSelected
            ? l10n.quiz_build_unselect_all("kana")
            : l10n.quiz_build_select_all("kana");

    switch (alphabet) {
      case Alphabets.hiragana:
        title = l10n.hiragana;
      case Alphabets.katakana:
        title = l10n.katakana;
      case Alphabets.kanji:
        title = l10n.kanji;
        multiselectButtonText =
            areAllSelected
                ? l10n.quiz_build_unselect_all("kanji")
                : l10n.quiz_build_select_all("kanji");
    }

    return ExpansionTile(
      title: Text(title),
      initiallyExpanded: initiallyExpanded,
      shape: const Border(),
      childrenPadding: const EdgeInsets.all(8.0),
      children: [
        ElevatedButton(
          onPressed: () => onSelectAllTapped(groups, toAdd: !areAllSelected),
          child: Text(multiselectButtonText),
        ),
        if (alphabet != Alphabets.kanji)
          KanaGroups(
            groups: groups,
            selectedGroups: selectedGroups,
            onGroupTapped: onGroupTapped,
            onSelectAllTapped: onSelectAllTapped,
          )
        else
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 3.5,
              crossAxisCount: 2,
            ),
            itemCount: groups.length,
            itemBuilder:
                (context, index) => GroupCard(
                  isChecked: selectedGroups.contains(groups[index]),
                  onTap: onGroupTapped,
                  group: groups[index],
                ),
          ),
      ],
    );
  }
}
