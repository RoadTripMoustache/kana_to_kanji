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
  final List<String> onReadings;

  /// Pronunciations in Japanese
  @Default([])
  @JsonKey(name: "kun_readings")
  final List<String> kunReadings;
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
      this.meanings,
      this.onReadings,
      this.kunReadings,
      this.version,
      this.vocabularyIds);

  factory Kanji.fromJson(Map<String, dynamic> json) => _$KanjiFromJson(json);
}
