import "package:flutter/material.dart";
import "package:kana_to_kanji/src/core/widgets/app_spacer.dart";

class SectionTitle extends StatelessWidget {
  final String title;

  final TextStyle? style;

  const SectionTitle({required this.title, super.key, this.style});

  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.titleLarge;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSpacer.p8(),
        Text(title, style: style ?? defaultStyle),
        const Divider(height: 0, endIndent: 150),
        AppSpacer.p8(),
      ],
    );
  }
}
