import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';
import 'package:kana_to_kanji/src/core/constants/alphabets.dart';
import 'package:kana_to_kanji/src/core/constants/kana_type.dart';

part 'vocabulary.g.dart';

@collection
@Name("Vocabulary")
@JsonSerializable()
class Vocabulary {
  final int id;

  final String kanji;
  final String kana;
  @JsonKey(name: "niveau_jlpt")
  final int niveauJLPT;
  @Default([])
  final List<String> significations;
  final String romaji;
  @Default([])
  @JsonKey(name: "related_kanjis")
  final List<int>? relatedKanjis;
  final String version;

  Vocabulary(this.id, this.kanji, this.kana, this.niveauJLPT,
      this.significations, this.romaji, this.relatedKanjis, this.version);

  factory Vocabulary.fromJson(Map<String, dynamic> json) =>
      _$VocabularyFromJson(json);
}
