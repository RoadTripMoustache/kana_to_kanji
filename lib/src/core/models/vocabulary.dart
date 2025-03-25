import "package:freezed_annotation/freezed_annotation.dart";
import "package:isar/isar.dart";
import "package:kana_to_kanji/src/core/constants/resource_type.dart";
import "package:kana_to_kanji/src/core/models/example.dart";
import "package:kana_to_kanji/src/core/models/kanji_reading.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";
import "package:kana_to_kanji/src/core/utils/isar_utils.dart";

part "vocabulary.g.dart";

@collection
@Name("Vocabularies")
@JsonSerializable()
class Vocabulary {
  @Default(ResourceUid("", ResourceType.kanji))
  final ResourceUid uid;
  int get id => fastHash(uid.uid);

  /// Contains the vocabulary word entirely even
  /// if it is a mix of kana and kanji.
  final String kanji;

  /// Full kana version of the word
  final String kana;
  @JsonKey(name: "jlpt_level")
  final int jlptLevel;

  /// Translations and meaning of the word
  @Default([])
  final List<String> meanings;
  final String romaji;

  /// List the IDs of the kanji present in the vocabulary.
  /// Present when [kanji] isn't empty.
  @Default([])
  @JsonKey(name: "related_kanjis")
  final List<ResourceUid>? relatedKanjis;
  final String version;

  /// List of syllables forming the word in kana.
  /// Use to facilitate vocabulary sorting.
  ///
  /// TODO: To remove once migrated to "kanjiReadings"
  @JsonKey(name: "kana_syllables")
  final List<int> kanaSyllables;

  /// List of kanji which are in the vocabulary with their respective reading
  @Default([])
  @JsonKey(name: "kanji_readings")
  final List<KanjiReading> kanjiReadings;

  /// Usage examples of the vocabulary
  @Default([])
  final List<Example>? examples;

  /// Groups related to the vocabulary
  @Default([])
  @JsonKey(name: "groups")
  final List<ResourceUid> groupList;

  const Vocabulary(
    this.uid,
    this.kanji,
    this.kana,
    this.jlptLevel,
    this.meanings,
    this.romaji,
    this.relatedKanjis,
    this.version,
    this.kanaSyllables,
    this.kanjiReadings,
    this.examples,
    this.groupList,
  );

  factory Vocabulary.fromJson(Map<String, dynamic> json) =>
      _$VocabularyFromJson(json);
}
