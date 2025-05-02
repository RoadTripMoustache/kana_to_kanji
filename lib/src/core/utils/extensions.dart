import "package:kana_to_kanji/src/core/constants/alphabets.dart";
import "package:kana_to_kanji/src/core/constants/jlpt_levels.dart";
import "package:kana_to_kanji/src/core/services/resources/kanji_service.dart";

extension AlphabetsExtension on Alphabets {
  bool isKana() => this == Alphabets.hiragana || this == Alphabets.katakana;
}

extension JlPTSqlExtension on List<JLPTLevel> {
  String? toSql() {
    if (isEmpty) {
      return null;
    }
    return "$sqlJlptLevelColumn IN (${map((level) => "?").join(",")})";
  }
}
