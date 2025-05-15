import "package:freezed_annotation/freezed_annotation.dart";
import "package:kana_to_kanji/src/core/models/resources/resource_uid.dart";

part "pronunciation.freezed.dart";
part "pronunciation.g.dart";

@freezed
abstract class Pronunciation with _$Pronunciation {
  const factory Pronunciation({
    @JsonKey(readValue: Pronunciation.positionReadValue) required int position,

    /// Reading of the kanji.
    /// Contains conditions of the pronunciations "." and "-".
    ///   - ".": everything on the right of the point is a condition,
    ///           it's not part of the pronunciation
    ///   - "-": only at the beginning or end of the reading,
    ///           it's not part of the pronunciation
    required String reading,

    /// Meanings associated with this pronunciation. This is already localized
    @Default([]) List<String> meanings,

    /// List of the 5 most simpler examples that use this pronunciation.
    @Default([]) List<ResourceUid> examples,
  }) = _Pronunciation;

  factory Pronunciation.fromJson(Map<String, dynamic> json) =>
      _$PronunciationFromJson(json);

  static Object? positionReadValue(Map map, String _) =>
      map["index"] ?? map["position"];
}
