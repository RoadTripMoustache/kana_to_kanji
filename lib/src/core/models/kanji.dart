import "package:freezed_annotation/freezed_annotation.dart";
import "package:isar/isar.dart";
import "package:kana_to_kanji/src/core/constants/resource_type.dart";
import "package:kana_to_kanji/src/core/models/example.dart";
import "package:kana_to_kanji/src/core/models/pronunciations.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";
import "package:kana_to_kanji/src/core/utils/isar_utils.dart";

part "kanji.g.dart";

@collection
@Name("Kanjis")
@JsonSerializable()
class Kanji {
  @Default(ResourceUid("", ResourceType.kanji))
  final ResourceUid uid;
  int get id => fastHash(uid.uid);

  final String kanji;

  /// Number of strokes necessary to draw the kanji
  @JsonKey(name: "nbr_strokes")
  final int? numberOfStrokes;

  /// Class in which kanji is taught
  final int? grade;
  @JsonKey(name: "jlpt_level")
  final int jlptLevel;
  @Default([])
  final List<String> meanings; // TODO : To delete

  /// Pronunciations in sino-Japanese
  ///
  /// TODO : To delete once migrated to "pronunciations"
  @Default([])
  @JsonKey(name: "on_readings")
  final List<String> onReadings;

  /// Pronunciations in Japanese
  ///
  /// TODO : To delete once migrated to "pronunciations"
  @Default([])
  @JsonKey(name: "kun_readings")
  final List<String> kunReadings;

  /// Pronunciations of the kanji
  @Default([])
  final List<Pronunciation> pronunciations;

  final String version;

  /// List of vocabulary word ids that use the kanji
  ///
  /// TODO : To delete once migrated to "relatedVocabulary"
  @Default([])
  @JsonKey(name: "vocabulary_ids")
  final List<int>? vocabularyIds;

  /// List of vocabulary words that use the kanji
  @Default([])
  @JsonKey(name: "related_vocabulary")
  final List<int>? relatedVocabulary;

  /// List of syllables of the first kanji Kun reading
  /// to facilitate the kanji sorting
  @JsonKey(name: "jp_sort_syllables")
  final List<int> jpSortSyllables;

  /// Usage examples of the kanji
  @Default([])
  final List<Example>? examples;

  /// Groups related to the kanji
  @Default([])
  @JsonKey(name: "groups")
  final List<ResourceUid> groupList;

  @JsonKey(name: "main_meaning")
  final String? mainMeaning;

  const Kanji(
    this.uid,
    this.kanji,
    this.numberOfStrokes,
    this.grade,
    this.jlptLevel,
    this.meanings,
    this.onReadings,
    this.kunReadings,
    this.pronunciations,
    this.version,
    this.vocabularyIds,
    this.relatedVocabulary,
    this.jpSortSyllables,
    this.examples,
    this.groupList,
    this.mainMeaning,
  );

  factory Kanji.fromJson(Map<String, dynamic> json) => _$KanjiFromJson(json);

  List<String> get readings => [
    ...kunReadings,
    ...onReadings,
  ]; // TODO : To delete
}
