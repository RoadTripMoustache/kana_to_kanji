import "package:flutter/material.dart";
import "package:flutter_rtm/flutter_rtm.dart";
import "package:kana_to_kanji/src/core/models/resources/group.dart";

class GroupChip extends StatelessWidget {
  final Group group;

  final Color? color;

  const GroupChip({required this.group, this.color, super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // TODO generate a color from the group name
    final color = this.color ?? Theme.of(context).colorScheme.primary;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Padding(
        padding: const RTMPadding.vertical4().add(RTMPadding.horizontal8()),
        child: Text(group.name, style: textTheme.labelMedium),
      ),
    );
  }
}
