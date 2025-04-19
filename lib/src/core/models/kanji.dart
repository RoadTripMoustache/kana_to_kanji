import "package:freezed_annotation/freezed_annotation.dart";
import "package:kana_to_kanji/src/core/models/example.dart";
import "package:kana_to_kanji/src/core/models/pronunciation.dart";
import "package:kana_to_kanji/src/core/models/resource.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";

part "kanji.freezed.dart";
part "kanji.g.dart";

@freezed
abstract class Kanji extends Resource with _$Kanji {
  const Kanji._() : super();

  const factory Kanji({
    required ResourceUid uid,
    required String kanji,
    required int jlptLevel,

    /// Number of strokes necessary to draw the kanji
    int? numberOfStrokes,

    /// Class in which kanji is taught
    int? grade,

    /// TODO :  To delete once migrated to "pronunciations"
    @Default([]) List<String> meanings,

    /// Pronunciations in sino-Japanese
    ///
    /// TODO : To delete once migrated to "pronunciations"
    @Default([]) List<String> onReadings,

    /// Pronunciations in Japanese
    ///
    /// TODO : To delete once migrated to "pronunciations"
    @Default([]) List<String> kunReadings,

    /// Pronunciations of the kanji
    @Default([]) List<Pronunciation> pronunciations,

    required String version,

    /// List of vocabulary words that use the kanji
    @Default([]) List<ResourceUid>? relatedVocabulary,

    /// List of syllables of the first kanji Kun reading
    /// to facilitate the kanji sorting
    required List<int> jpSortSyllables,

    /// Usage examples of the kanji
    @Default([]) List<Example>? examples,

    /// Groups related to the kanji
    @Default([]) List<ResourceUid> groups,

    String? mainMeaning,
  }) = _Kanji;

  factory Kanji.fromJson(Map<String, dynamic> json) => _$KanjiFromJson(json);

  const Kanji._();

  List<String> get readings => [
    ...kunReadings,
    ...onReadings,
  ]; // TODO : To delete
}
