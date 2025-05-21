import "package:flutter/material.dart";
import "package:flutter_rtm/flutter_rtm.dart";

class SectionTitle extends StatelessWidget {
  final String title;

  final TextStyle? style;

  const SectionTitle({required this.title, super.key, this.style});

  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.titleLarge;

    return Padding(
      padding: const RTMPadding.vertical8(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text(title, style: style ?? defaultStyle),
          const Divider(height: 0, endIndent: 100),
        ],
      ),
    );
  }
}
