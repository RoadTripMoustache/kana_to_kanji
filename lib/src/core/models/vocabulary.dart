import "package:freezed_annotation/freezed_annotation.dart";
import "package:kana_to_kanji/src/core/constants/resource_type.dart";
import "package:kana_to_kanji/src/core/models/example.dart";
import "package:kana_to_kanji/src/core/models/kanji_reading.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";

part "vocabulary.freezed.dart";
part "vocabulary.g.dart";

@freezed
class Vocabulary with _$Vocabulary {
  const factory Vocabulary({
    @Default(ResourceUid("", ResourceType.kanji)) ResourceUid uid,

    /// Contains the vocabulary word entirely even
    /// if it is a mix of kana and kanji.
    required String kanji,

    /// Full kana version of the word
    required String kana,

    required int jlptLevel,

    /// Translations and meaning of the word
    @Default([]) List<String> meanings,

    required String romaji,

    /// List the IDs of the kanji present in the vocabulary.
    /// Present when [kanji] isn't empty.
    @Default([]) List<ResourceUid>? relatedKanjis,

    required String version,

    /// List of syllables forming the word in kana.
    /// Use to facilitate vocabulary sorting.
    ///
    /// TODO: To remove once migrated to "kanjiReadings"
    required List<int> kanaSyllables,

    /// List of kanji which are in the vocabulary with their respective reading
    @Default([]) List<KanjiReading> kanjiReadings,

    /// Usage examples of the vocabulary
    @Default([]) List<Example>? examples,

    /// Groups related to the vocabulary
    @Default([]) @JsonKey(name: "groups") List<ResourceUid> groupList,
  }) = _Vocabulary;

  factory Vocabulary.fromJson(Map<String, dynamic> json) =>
      _$VocabularyFromJson(json);
}
