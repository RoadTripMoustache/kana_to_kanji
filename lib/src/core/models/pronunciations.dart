import "package:freezed_annotation/freezed_annotation.dart";

part "pronunciations.freezed.dart";
part "pronunciations.g.dart";

@freezed
class Pronunciation with _$Pronunciation {
  const factory Pronunciation({
    @JsonKey(name: "index") required int pronounciationIndex,
    @Default([]) List<String> meanings,
    @Default([]) List<String> readings,
  }) = _Pronunciation;

  factory Pronunciation.fromJson(Map<String, dynamic> json) =>
      _$PronunciationFromJson(json);
}
