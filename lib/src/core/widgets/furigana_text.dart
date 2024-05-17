import "package:flutter/material.dart";
import "package:kana_to_kanji/src/core/models/kanji.dart";
import "package:kana_to_kanji/src/core/models/vocabulary.dart";

class FuriganaText extends StatelessWidget {
  final String text;

  final String? furigana;

  final bool showFurigana;

  final TextStyle? style;

  /// Widget used to display [furigana] in top of [text] when
  /// [showFurigana] is true. Please note that no logic of verification
  /// are done, meaning that you can display any text on top of [text].
  const FuriganaText(
      {required this.text,
      super.key,
      this.furigana,
      this.showFurigana = false,
      this.style});

  factory FuriganaText.kanji(Kanji kanji,
          {String? furigana, TextStyle? style, bool showFurigana = false}) =>
      FuriganaText(
          text: kanji.kanji,
          furigana: furigana ??
              (kanji.kunReadings.isNotEmpty
                  ? kanji.kunReadings[0]
                  : kanji.onReadings[0]),
          showFurigana: showFurigana,
          style: style);

  factory FuriganaText.vocabulary(Vocabulary vocabulary, {TextStyle? style}) {
    if (vocabulary.kanji.isEmpty) {
      return FuriganaText(text: vocabulary.kana, style: style);
    }

    return FuriganaText(
        text: vocabulary.kanji,
        furigana: vocabulary.kana,
        showFurigana: true,
        style: style);
  }

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);

    if (showFurigana && furigana != null) {
      final fontSize = Theme.of(context).textTheme.bodySmall?.fontSize ?? 12;
      final TextStyle furiganaStyle =
          defaultTextStyle.style.merge(style).copyWith(fontSize: fontSize);

      return Column(
        mainAxisSize: MainAxisSize.min,
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
