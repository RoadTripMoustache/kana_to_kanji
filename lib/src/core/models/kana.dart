import 'package:isar/isar.dart';
import 'package:kana_to_kanji/src/core/constants/alphabets.dart';

part 'kana.g.dart';

@collection
@Name("Kanas")
class Kana {
  final int id;

  @enumValue
  final Alphabets alphabet;

  final int groupId;

  final String kana;

  final String romaji;

  Kana(this.id, this.alphabet, this.groupId, this.kana, this.romaji);

  factory Kana.fromJson(Map<String, Object?> json) => Kana(
      json['id'] as int,
      Alphabets.values.where((element) => element.value == json['alphabet']).first,
      json['group_id'] as int,
      json['kana'] as String,
      json['romaji'] as String
  );
}
