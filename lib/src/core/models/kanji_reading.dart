import "package:freezed_annotation/freezed_annotation.dart";
import "package:kana_to_kanji/src/core/constants/resource_type.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";

part "kanji_reading.freezed.dart";
part "kanji_reading.g.dart";

@freezed
class KanjiReading with _$KanjiReading {
  const factory KanjiReading({
    /// ID of the kanji
    @Default(ResourceUid("", ResourceType.kanji)) ResourceUid uid,
    required String kanji,
    required String reading,
  }) = _KanjiReading;

  factory KanjiReading.fromJson(Map<String, dynamic> json) =>
      _$KanjiReadingFromJson(json);
}
