import "package:freezed_annotation/freezed_annotation.dart";
import "package:isar/isar.dart";
import "package:kana_to_kanji/src/core/constants/resource_type.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";
import "package:kana_to_kanji/src/core/utils/isar_utils.dart";

part "kanji_reading.g.dart";

@JsonSerializable()
@embedded

/// Reading of a kanji in a word.
class KanjiReading {
  /// ID of the kanji
  @Default(ResourceUid("", ResourceType.kanji))
  final ResourceUid uid;
  int get id => fastHash(uid.uid);

  final String kanji;
  final String reading;

  const KanjiReading(this.uid, this.kanji, this.reading);

  factory KanjiReading.fromJson(Map<String, dynamic> json) =>
      _$KanjiReadingFromJson(json);
}
