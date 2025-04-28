import "package:freezed_annotation/freezed_annotation.dart";
import "package:kana_to_kanji/src/core/models/example.dart";
import "package:kana_to_kanji/src/core/models/kanji_reading.dart";
import "package:kana_to_kanji/src/core/models/resource.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";

part "vocabulary.freezed.dart";
part "vocabulary.g.dart";

@freezed
abstract class Vocabulary extends Resource with _$Vocabulary {
  const Vocabulary._() : super();

  const factory Vocabulary({
    required ResourceUid uid,

    /// Contains the vocabulary word entirely even
    /// if it is a mix of kana and kanji.
    required String kanji,

    /// Full kana version of the word
    required String kana,
    required int jlptLevel,
    required String romaji,
    required String version,

    /// List of syllables forming the word in kana.
    /// Use to facilitate vocabulary sorting.
    ///
    /// TODO: To remove once migrated to "kanjiReadings"
    required List<int> kanaSyllables,

    /// Translations and meaning of the word
    @Default([]) List<String> meanings,

    /// List the IDs of the kanji present in the vocabulary.
    /// Present when [kanji] isn't empty.
    @Default([]) List<ResourceUid> relatedKanjis,

    /// List of kanji which are in the vocabulary with their respective reading
    @Default([]) List<KanjiReading> kanjiReadings,

    /// List of [Example] that use the vocabulary
    @Default([]) List<ResourceUid> examples,

    /// Groups related to the vocabulary
    @Default([]) List<ResourceUid> groups,
  }) = _Vocabulary;

  factory Vocabulary.fromJson(Map<String, dynamic> json) =>
      _$VocabularyFromJson(json);
}
