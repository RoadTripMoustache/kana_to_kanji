import "package:freezed_annotation/freezed_annotation.dart";
import "package:kana_to_kanji/src/core/models/resources/pronunciation.dart";
import "package:kana_to_kanji/src/core/models/resources/resource.dart";
import "package:kana_to_kanji/src/core/models/resources/resource_uid.dart";

part "kanji.freezed.dart";
part "kanji.g.dart";

@freezed
abstract class Kanji extends Resource with _$Kanji {
  const Kanji._() : super();

  const factory Kanji({
    required ResourceUid uid,
    required String kanji,
    required int jlptLevel,

    required String version,

    /// Pronunciations of the kanji
    required List<Pronunciation> pronunciations,

    required String mainMeaning,

    /// Number of strokes necessary to draw the kanji
    int? numberOfStrokes,

    /// Class in which kanji is taught
    int? grade,

    /// List of vocabulary words that use the kanji
    @Default([]) List<ResourceUid> relatedVocabulary,

    /// Groups related to the kanji
    @Default([]) List<ResourceUid> groups,
  }) = _Kanji;

  factory Kanji.fromJson(Map<String, dynamic> json) => _$KanjiFromJson(json);

  // TODO : Clean up when glossary is refactored
  List<String> get meanings => pronunciations
      .map((p) => p.meanings)
      .fold<List<String>>([], (prev, element) {
        prev.addAll(element);
        return prev;
      });

  // TODO : Clean up when glossary is refactored
  List<String> get readings => pronunciations.map((p) => p.reading).toList();
}
