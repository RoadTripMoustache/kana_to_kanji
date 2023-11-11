import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';

part 'kanji.g.dart';

@collection
@Name("Kanjis")
@JsonSerializable()
class Kanji {
  final int id;

  final String kanji;
  final int? nbrTraits;
  final int? grade;
  @JsonKey(name: "niveau_jlpt")
  final int niveauJLPT;
  @Default([])
  final List<String> traductions;
  @Default([])
  @JsonKey(name: "lectures_on")
  final List<String> lecturesOn;
  @Default([])
  @JsonKey(name: "lectures_kun")
  final List<String> lecturesKun;
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
