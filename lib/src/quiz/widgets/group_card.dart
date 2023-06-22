import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kana_to_kanji/src/quiz/constants/alphabets.dart';
import 'package:kana_to_kanji/src/quiz/models/group.dart';

class GroupCard extends StatelessWidget {
  final Group group;
  final Function(Group)? onTap;
  final bool isChecked;

  const GroupCard(
      {super.key,
      required this.group,
      this.onTap,
      this.isChecked = false});

  onChanged(bool? value) {
    if (onTap != null) {
      onTap!(group);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: CheckboxListTile(
        title: Text(group.localizedName ?? group.name),
        value: isChecked,
        onChanged: onChanged,
      ),
    );
  }
}
