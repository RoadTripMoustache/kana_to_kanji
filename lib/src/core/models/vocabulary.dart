import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';

part 'vocabulary.g.dart';

@collection
@Name("Vocabularies")
@JsonSerializable()
class Vocabulary {
  final int id;

  /// Contains the vocabulary word entirely even if it is a mix of kana and kanji.
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
  final List<int>? relatedKanjis;
  final String version;

  /// List of syllables forming the word in kana. Use to facilitate vocabulary sorting.
  @JsonKey(name: "kana_syllables")
  final List<String> kanaSyllables;

  const Vocabulary(this.id, this.kanji, this.kana, this.jlptLevel, this.meanings,
      this.romaji, this.relatedKanjis, this.version, this.kanaSyllables);

  factory Vocabulary.fromJson(Map<String, dynamic> json) =>
      _$VocabularyFromJson(json);
}
