import "package:flutter/material.dart";
import "package:kana_to_kanji/src/core/models/resources/example.dart";

class ExampleLine extends StatelessWidget {
  final Example example;

  /// Reading to bold
  final String toBold;

  const ExampleLine({required this.example, required this.toBold, super.key});

  @override
  Widget build(BuildContext context) {
    final TextStyle? defaultStyle = Theme.of(context).textTheme.bodyMedium;
    final bold = defaultStyle?.copyWith(fontWeight: FontWeight.bold);

    final List<String> parts = example.sentence.split(toBold);
    final List<TextSpan> text =
        parts
            .expand(
              (item) => [
                TextSpan(text: item),
                TextSpan(text: toBold, style: bold),
              ],
            )
            .toList()
          ..removeLast();

    return Wrap(
      spacing: 16,
      children: [
        RichText(text: TextSpan(children: text, style: defaultStyle)),
        Text(example.translation),
      ],
    );
  }
}
