import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';
import 'package:kana_to_kanji/src/core/constants/alphabets.dart';

part 'kana.g.dart';

@collection
@Name("Kanas")
@JsonSerializable()
class Kana {
  final int id;

  @enumValue
  final Alphabets alphabet;

  @JsonKey(name: "group_id")
  final int groupId;

  final String kana;

  final String romaji;

  final String version;

  Kana(this.id, this.alphabet, this.groupId, this.kana, this.romaji, this.version);

  factory Kana.fromJson(Map<String, dynamic> json) => _$KanaFromJson(json);
}
