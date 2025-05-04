import "package:freezed_annotation/freezed_annotation.dart";
import "package:kana_to_kanji/src/core/constants/alphabets.dart";
import "package:kana_to_kanji/src/core/constants/kana_type.dart";
import "package:kana_to_kanji/src/core/models/resources/resource.dart";
import "package:kana_to_kanji/src/core/models/resources/resource_uid.dart";

part "kana.freezed.dart";

part "kana.g.dart";

@freezed
abstract class Kana extends Resource with _$Kana {
  const Kana._() : super();

  const factory Kana({
    required ResourceUid uid,
    required Alphabets alphabet,
    required ResourceUid groupUid,
    required String kana,
    required String romaji,
    required String version,
    required int position,
  }) = _Kana;

  factory Kana.fromJson(Map<String, dynamic> json) => _$KanaFromJson(json);

  KanaTypes get type {
    if (position < 46) {
      return KanaTypes.main;
    } else if (position < 71) {
      return KanaTypes.dakuten;
    }
    return KanaTypes.combination;
  }
}
