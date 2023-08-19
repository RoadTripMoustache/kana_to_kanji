import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kana_to_kanji/src/core/constants/kana_type.dart';
import 'package:kana_to_kanji/src/core/models/group.dart';
import 'package:kana_to_kanji/src/quiz/prepare/widgets/group_card.dart';

class KanaGroupsSection extends StatelessWidget {
  final KanaTypes type;

  final List<Group> groups;

  final List<Group> selectedGroups;

  final Function(Group) onGroupTapped;

  final Function(List<Group> groups, bool toAdd) onSelectAllTapped;

  const KanaGroupsSection(
      {super.key,
      required this.type,
      required this.groups,
      required this.selectedGroups,
      required this.onGroupTapped,
      required this.onSelectAllTapped});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    String sectionTitle;

    switch (type) {
      case KanaTypes.main:
        sectionTitle = l10n.main_kana;
        break;
      case KanaTypes.dakuten:
        sectionTitle = l10n.dakuten_kana;
        break;
      case KanaTypes.combination:
        sectionTitle = l10n.combination_kana;
        break;
    }

    final areAllSelected =
        selectedGroups.where((group) => group.kanaType == type).length ==
            groups.length;

    return Column(mainAxisSize: MainAxisSize.min, children: [
      ListTile(
        title: Text(sectionTitle),
        trailing: TextButton(
            onPressed: () => onSelectAllTapped(groups, !areAllSelected),
            child: Text(areAllSelected ? l10n.unselect_all : l10n.select_all)),
      ),
      const Padding(
        padding: EdgeInsets.only(bottom: 8.0),
        child: Divider(height: 0),
      ),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 3.5, crossAxisCount: 2),
        itemCount: groups.length,
        itemBuilder: (context, index) => GroupCard(
            isChecked: selectedGroups.contains(groups[index]),
            onTap: onGroupTapped,
            group: groups[index]),
      )
    ]);
  }
}
