import "package:freezed_annotation/freezed_annotation.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";

part "kanji_reading.freezed.dart";

part "kanji_reading.g.dart";

@freezed
abstract class KanjiReading with _$KanjiReading {
  const factory KanjiReading({
    /// ID of the kanji
    @JsonKey(readValue: KanjiReading.uidReadingValue) required ResourceUid uid,
    required String kanji,
    required String reading,
  }) = _KanjiReading;

  static Object? uidReadingValue(Map map, String _) =>
      map["uid"] ?? map["kanji_uid"];

  factory KanjiReading.fromJson(Map<String, dynamic> json) =>
      _$KanjiReadingFromJson(json);
}
