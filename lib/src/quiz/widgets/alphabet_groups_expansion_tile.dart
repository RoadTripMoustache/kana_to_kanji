import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kana_to_kanji/src/quiz/constants/alphabets.dart';
import 'package:kana_to_kanji/src/quiz/models/group.dart';
import 'package:kana_to_kanji/src/quiz/widgets/group_card.dart';

class AlphabetGroupsExpansionTile extends StatelessWidget {
  final Alphabets alphabet;

  final bool initiallyExpanded;

  final List<Group> groups;

  final List<Group> selectedGroups;

  final Function(Group) onGroupTapped;

  const AlphabetGroupsExpansionTile(
      {super.key,
      required this.alphabet,
      required this.groups,
      required this.selectedGroups,
      required this.onGroupTapped,
      this.initiallyExpanded = false});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    String title;

    switch (alphabet) {
      case Alphabets.hiragana:
        title = l10n.hiragana;
        break;
      case Alphabets.katakana:
        title = l10n.katakana;
        break;
      case Alphabets.kanji:
        title = l10n.kanji;
        break;
    }

    return ExpansionTile(
      title: Text(title),
      initiallyExpanded: initiallyExpanded,
      children: [
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 3.5, crossAxisCount: 2),
          itemCount: groups.length,
          itemBuilder: (context, index) => GroupCard(
              isChecked: selectedGroups.contains(groups[index]),
              onTap: onGroupTapped,
              group: groups[index]),
        )
      ],
    );
  }
}
