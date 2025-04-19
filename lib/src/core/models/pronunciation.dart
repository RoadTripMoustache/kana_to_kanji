import "package:freezed_annotation/freezed_annotation.dart";

part "pronunciation.freezed.dart";
part "pronunciation.g.dart";

@freezed
abstract class Pronunciation with _$Pronunciation {
  const factory Pronunciation({
    required int index,
    @Default([]) List<String> meanings,
    @Default([]) List<String> readings,
  }) = _Pronunciation;

  factory Pronunciation.fromJson(Map<String, dynamic> json) =>
      _$PronunciationFromJson(json);
}
