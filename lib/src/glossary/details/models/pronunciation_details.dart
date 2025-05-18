import "package:freezed_annotation/freezed_annotation.dart";
import "package:kana_to_kanji/src/core/models/resources/example.dart";
import "package:kana_to_kanji/src/core/models/resources/resource_uid.dart";

part "pronunciation_details.freezed.dart";

@Freezed(makeCollectionsUnmodifiable: false)
class PronunciationDetails with _$PronunciationDetails {
  @override
  final String reading;

  @override
  final List<String> meanings;

  @override
  final List<Example> examples;

  @override
  final List<ResourceUid> exampleUids;

  PronunciationDetails({
    required this.reading,
    required this.meanings,
    this.exampleUids = const [],
    List<Example>? examples,
  }) : examples = examples ?? [];
}
