import "package:flutter/material.dart";

class HeadingItem extends StatelessWidget {
  final String title;

  const HeadingItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(title, style: Theme.of(context).textTheme.headlineSmall),
      );
}
