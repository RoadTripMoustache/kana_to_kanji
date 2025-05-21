import "package:freezed_annotation/freezed_annotation.dart";
import "package:kana_to_kanji/src/core/models/resources/kanji_reading.dart";
import "package:kana_to_kanji/src/core/models/resources/resource.dart";
import "package:kana_to_kanji/src/core/models/resources/resource_uid.dart";

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

    /// Translations and meaning of the word
    @Default([]) List<String> meanings,

    /// List the IDs of the kanji present in the vocabulary.
    /// Present when [kanji] isn't empty.
    @Default([]) List<ResourceUid> relatedKanjis,

    /// List of kanji which are in the vocabulary with their respective reading
    @Default([]) List<KanjiReading> kanjiReadings,

    /// Groups related to the vocabulary
    @Default([]) List<ResourceUid> groups,

    /// List of the 5 most simpler examples that use the vocabulary.
    @Default([]) List<ResourceUid> examples,
  }) = _Vocabulary;

  factory Vocabulary.fromJson(Map<String, dynamic> json) =>
      _$VocabularyFromJson(json);

  /// Retrieve the vocabulary word in Japanese.
  String get japanese => kanji.isNotEmpty ? kanji : kana;
}
