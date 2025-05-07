import "package:freezed_annotation/freezed_annotation.dart";
import "package:kana_to_kanji/src/core/models/resources/resource.dart";
import "package:kana_to_kanji/src/core/models/resources/resource_uid.dart";

part "example.freezed.dart";
part "example.g.dart";

@freezed
abstract class Example extends Resource with _$Example {
  const Example._() : super();

  const factory Example({
    required ResourceUid uid,
    required String sentence,
    required String translation,

    /// Tokenized version of [sentence]
    required List<String> kanji,

    /// Readings of each token present in [kanji]
    required List<String> reading,

    /// Temporary set the version to empty string until
    @Default("") String version,
  }) = _Example;

  factory Example.fromJson(Map<String, dynamic> json) =>
      _$ExampleFromJson(json);
}
