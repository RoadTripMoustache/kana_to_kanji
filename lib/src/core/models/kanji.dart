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
  /// List of vocabulary words that use the kanji
  @Default([])
  @JsonKey(name: "vocabulaire_ids")
  final List<int>? vocabularyIds;

  Kanji(
      this.id,
      this.kanji,
      this.nbrTraits,
      this.grade,
      this.niveauJLPT,
      this.traductions,
      this.lecturesOn,
      this.lecturesKun,
      this.version,
      this.vocabulaireIds);

  factory Kanji.fromJson(Map<String, dynamic> json) => _$KanjiFromJson(json);
}
