import "package:flutter/material.dart";
import "package:kana_to_kanji/src/core/models/group.dart";

class GroupCard extends StatelessWidget {
  final Group group;
  final Function(Group)? onTap;
  final bool isChecked;

  const GroupCard(
      {super.key, required this.group, this.onTap, this.isChecked = false});

  onChanged(bool? value) {
    if (onTap != null) {
      onTap!(group);
    }
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => onChanged(!isChecked),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(group.localizedName ?? group.name,
                    style: Theme.of(context).textTheme.bodyLarge),
                Checkbox(value: isChecked, onChanged: onChanged)
              ],
            ),
          ),
        ),
      );
}
