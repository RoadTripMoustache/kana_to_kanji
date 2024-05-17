import "package:kana_to_kanji/src/core/constants/alphabets.dart";

extension AlphabetsExtension on Alphabets {
  bool isKana() => this == Alphabets.hiragana || this == Alphabets.katakana;
}
