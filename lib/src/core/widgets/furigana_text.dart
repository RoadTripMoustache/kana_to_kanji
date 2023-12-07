import 'package:flutter/material.dart';
import 'package:kana_to_kanji/src/core/models/kanji.dart';

class FuriganaText extends StatelessWidget {
  final String text;

  final String? furigana;

  final bool showFurigana;

  final TextStyle? style;

  const FuriganaText(
      {super.key,
      required this.text,
      this.furigana,
      this.showFurigana = false,
      this.style});

  factory FuriganaText.kanji(
          {required Kanji kanji,
          String? furigana,
          TextStyle? style,
          bool showFurigana = false}) =>
      FuriganaText(
          text: kanji.kanji,
          furigana: furigana ??
              (kanji.kunReadings.isNotEmpty
                  ? kanji.kunReadings[0]
                  : kanji.onReadings[0]),
          showFurigana: showFurigana,
          style: style);

  // TODO Add Vocabulary factory constructor

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);

    if (showFurigana && furigana != null) {
      final fontSize = Theme.of(context).textTheme.bodySmall?.fontSize ?? 12;
      final TextStyle furiganaStyle =
          defaultTextStyle.style.merge(style).copyWith(fontSize: fontSize);

      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            furigana!,
            style: furiganaStyle,
            softWrap: true,
          ),
          Text(
            text,
            style: style,
            softWrap: true,
          )
        ],
      );
    }
    return Text(text, style: style);
  }
}
