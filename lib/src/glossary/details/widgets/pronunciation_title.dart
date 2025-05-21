import "package:flutter/material.dart";
import "package:flutter_rtm/flutter_rtm.dart";

class PronunciationTitle extends StatelessWidget {
  final String pronunciation;

  /// Minimum width of the box around the title excluding the padding.
  final double minWidth;

  const PronunciationTitle({
    required this.pronunciation,
    this.minWidth = 48,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(color: theme.bottomSheetTheme.backgroundColor),
      alignment: Alignment.center,
      constraints: BoxConstraints(minWidth: minWidth + 16), // Add the padding
      child: Padding(
        padding: const RTMPadding.horizontal8(),
        child: Title(pronunciation: pronunciation),
      ),
    );
  }
}

class Title extends StatelessWidget {
  final String pronunciation;

  const Title({required this.pronunciation, super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final textStyle = theme.textTheme.titleSmall?.copyWith(
      fontWeight: FontWeight.normal,
    );
    final bold = textStyle?.copyWith(fontWeight: FontWeight.bold);

    if (!pronunciation.contains("-") && !pronunciation.contains(".")) {
      return Text(pronunciation, style: bold);
    }
    final String remains = pronunciation.replaceAll("-", "");
    final List<TextSpan> parts = [];

    if (pronunciation.startsWith("-")) {
      parts.add(TextSpan(text: "-", style: textStyle));
    }
    if (pronunciation.contains(".")) {
      final split = remains.split(".");
      parts.addAll([
        TextSpan(text: split[0], style: bold),
        TextSpan(text: ".${split[1]}", style: textStyle),
      ]);
    } else {
      parts.add(TextSpan(text: remains, style: bold));
    }

    if (pronunciation.endsWith("-")) {
      parts.add(TextSpan(text: "-", style: textStyle));
    }

    return RichText(text: TextSpan(children: parts));
  }
}
