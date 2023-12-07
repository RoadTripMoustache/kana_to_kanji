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

  @JsonKey(name: "sort_key")
  final String sortKey; // TODO : Faire que cette information soit la clé pour faire le tri en japonais.
  // TODO : renommer jp_sort_key
  // TODO : Remplacer par un chiffre pour indiquer l'ordre du kana

  Kana(this.id, this.alphabet, this.groupId, this.kana, this.romaji,
      this.version, this.sortKey);

  factory Kana.fromJson(Map<String, dynamic> json) => _$KanaFromJson(json);
}
