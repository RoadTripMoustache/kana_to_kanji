import "package:flutter/material.dart";
import "package:kana_to_kanji/src/core/models/resources/example.dart";

class ExampleLine extends StatelessWidget {
  final Example example;

  /// Reading to bold
  final String toBold;

  const ExampleLine({required this.example, required this.toBold, super.key});

  @override
  Widget build(BuildContext context) {
    final bold = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold);

    final List<String> parts = example.sentence.split(toBold);
    final List<TextSpan> text =
        parts.map((item) => TextSpan(text: item)).toList();

    for (int i = 0; i < (parts.length - 1); i++) {
      text.insert(i, TextSpan(text: toBold, style: bold));
    }

    return Wrap(
      spacing: 16,
      children: [
        Text.rich(TextSpan(children: text)),
        Text(example.translation),
      ],
    );
  }
}
