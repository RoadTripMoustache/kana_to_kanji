import "package:flutter/material.dart";
import "package:flutter_rtm/flutter_rtm.dart";

class HeadingItem extends StatelessWidget {
  final String title;

  const HeadingItem({required this.title, super.key});

  @override
  Widget build(BuildContext context) => RTMListTile(
    title: Text(title, style: Theme.of(context).textTheme.headlineSmall),
  );
}
