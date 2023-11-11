import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';

part 'kanji.g.dart';

@collection
@Name("Kanjis")
@JsonSerializable()
class Kanji {
  final int id;

  final String kanji;
  /// Number of strokes necessary to draw the kanji
  final int? numberOfStrokes;
  /// Class in which kanji is taught
  final int? grade;
  @JsonKey(name: "niveau_jlpt")
  final int jlptLevel;
  @Default([])
  final List<String> translations;
  /// Pronunciations in sino-Japanese
  @Default([])
  @JsonKey(name: "lectures_on")
  final List<String> onPronunciations;
  /// Pronunciations in Japanese
  @Default([])
  @JsonKey(name: "lectures_kun")
  final List<String> kunPronunciations;
  final String version;
  /// List of vocabulary word ids that use the kanji
  @Default([])
  @JsonKey(name: "vocabulary_ids")
  final List<int>? vocabularyIds;

  Kanji(
      this.id,
      this.kanji,
      this.numberOfStrokes,
      this.grade,
      this.jlptLevel,
      this.translations,
      this.onPronunciations,
      this.kunPronunciations,
      this.version,
      this.vocabularyIds);

  factory Kanji.fromJson(Map<String, dynamic> json) => _$KanjiFromJson(json);
}
