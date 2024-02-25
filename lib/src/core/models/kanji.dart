import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';
import 'package:kana_to_kanji/src/core/models/pronunciations.dart';

part 'kanji.g.dart';

@collection
@Name("Kanjis")
@JsonSerializable()
class Kanji {
  final int id;

  final String kanji;

  /// Number of strokes necessary to draw the kanji
  @JsonKey(name: "nbr_strokes")
  final int? numberOfStrokes;

  /// Class in which kanji is taught
  final int? grade;
  @JsonKey(name: "jlpt_level")
  final int jlptLevel;
  @Default([])
  final List<String> meanings;

  /// Pronunciations in sino-Japanese
  @Default([])
  @JsonKey(name: "on_readings")
  final List<String> onReadings; // TODO : To delete once migrated to "pronunciations"

  /// Pronunciations in Japanese
  @Default([])
  @JsonKey(name: "kun_readings")
  final List<String> kunReadings; // TODO : To delete once migrated to "pronunciations"

  /// Pronunciations of the kanji
  @Default([])
  final List<Pronunciation> pronunciations;

  final String version;

  /// List of vocabulary word ids that use the kanji
  @Default([])
  @JsonKey(name: "vocabulary_ids")
  final List<int>? vocabularyIds; // TODO : To delete once migrated to "relatedVocabulary"

  /// List of vocabulary words that use the kanji
  @Default([])
  @JsonKey(name: "related_vocabulary")
  final List<int>? relatedVocabulary;

  /// List of syllables of the first kanji Kun reading to facilitate the kanji sorting
  @JsonKey(name: "jp_sort_syllables")
  final List<String> jpSortSyllables;

  const Kanji(
      this.id,
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
      this.jpSortSyllables);

  factory Kanji.fromJson(Map<String, dynamic> json) => _$KanjiFromJson(json);

  List<String> get readings => [...kunReadings, ...onReadings];
}
