import "package:freezed_annotation/freezed_annotation.dart";
import "package:kana_to_kanji/src/core/models/resources/example.dart";

part "pronunciation_details.freezed.dart";

@Freezed(makeCollectionsUnmodifiable: false)
class PronunciationDetails with _$PronunciationDetails {
  @override
  final String reading;

  @override
  final List<String> meanings;

  @override
  final List<Example> examples;

  PronunciationDetails({
    required this.reading,
    required this.meanings,
    List<Example>? examples,
  }) : examples = examples ?? [];
}
