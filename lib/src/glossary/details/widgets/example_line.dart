import "package:flutter/material.dart";

// TODO refactor once Example is here
class ExampleLine extends StatelessWidget {
  final String sentence;

  final String toBold;

  final String translation;

  const ExampleLine({
    required this.sentence,
    required this.toBold,
    required this.translation,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bold = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold);

    final List<TextSpan> splitted =
        sentence
            .split("**")
            .map<TextSpan>(
              (value) =>
                  TextSpan(text: value, style: value == toBold ? bold : null),
            )
            .toList();

    return Row(
      spacing: 16,
      children: [Text.rich(TextSpan(children: splitted)), Text(translation)],
    );
  }
}
