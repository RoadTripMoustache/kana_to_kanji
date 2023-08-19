import 'package:flutter/material.dart';
import 'package:kana_to_kanji/src/core/constants/kana_type.dart';
import 'package:kana_to_kanji/src/core/models/group.dart';
import 'package:kana_to_kanji/src/quiz/prepare/widgets/kana_groups_section.dart';

class KanaGroups extends StatelessWidget {
  final List<Group> groups;

  final List<Group> selectedGroups;

  final Function(Group) onGroupTapped;

  final Function(List<Group> groups, bool toAdd) onSelectAllTapped;

  const KanaGroups(
      {super.key,
      required this.groups,
      required this.selectedGroups,
      required this.onGroupTapped,
      required this.onSelectAllTapped});

  @override
  Widget build(BuildContext context) {
    final mainKana = groups
        .where((group) => group.kanaType == KanaTypes.main)
        .toList(growable: false);
    final dakutenKana = groups
        .where((group) => group.kanaType == KanaTypes.dakuten)
        .toList(growable: false);
    final combinationKana = groups
        .where((group) => group.kanaType == KanaTypes.combination)
        .toList(growable: false);

    return Column(mainAxisSize: MainAxisSize.min, children: [
      KanaGroupsSection(
          type: KanaTypes.main,
          groups: mainKana,
          selectedGroups: selectedGroups,
          onGroupTapped: onGroupTapped,
          onSelectAllTapped: onSelectAllTapped),
      KanaGroupsSection(
          type: KanaTypes.dakuten,
          groups: dakutenKana,
          selectedGroups: selectedGroups,
          onGroupTapped: onGroupTapped,
          onSelectAllTapped: onSelectAllTapped),
      KanaGroupsSection(
          type: KanaTypes.combination,
          groups: combinationKana,
          selectedGroups: selectedGroups,
          onGroupTapped: onGroupTapped,
          onSelectAllTapped: onSelectAllTapped),
    ]);
  }
}
