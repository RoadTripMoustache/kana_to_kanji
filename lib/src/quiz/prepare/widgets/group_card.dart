import "package:flutter/material.dart";
import "package:kana_to_kanji/src/core/models/group.dart";

class GroupCard extends StatelessWidget {
  final Group group;
  final Function(Group)? onTap;
  final bool isChecked;

  const GroupCard(
      {required this.group, super.key, this.onTap, this.isChecked = false});

  // ignore: avoid_positional_boolean_parameters
  void onChanged(bool? value) {
    onTap?.call(group);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => onChanged(!isChecked),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 8.0),
            child: Row(

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
