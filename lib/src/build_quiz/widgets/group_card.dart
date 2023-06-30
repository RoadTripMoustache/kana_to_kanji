import 'package:flutter/material.dart';
import 'package:kana_to_kanji/src/build_quiz/models/group.dart';

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
        selected: isChecked,
        onChanged: onChanged,
      ),
    );
  }
}
