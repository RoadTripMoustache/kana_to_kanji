import "package:freezed_annotation/freezed_annotation.dart";
import "package:isar/isar.dart";
import "package:kana_to_kanji/src/core/constants/alphabets.dart";
import "package:kana_to_kanji/src/core/constants/resource_type.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";
import "package:kana_to_kanji/src/core/utils/isar_utils.dart";

part "kana.g.dart";

@collection
@Name("Kanas")
@JsonSerializable()
class Kana {
  @Default(ResourceUid("", ResourceType.kana))
  final ResourceUid uid;
  int get id => fastHash(uid.uid);

  @enumValue
  final Alphabets alphabet;

  @JsonKey(name: "group_uid")
  final ResourceUid groupUid;

  final String kana;

  final String romaji;

  final String version;

  final int position;

  const Kana(this.uid, this.alphabet, this.groupUid, this.kana, this.romaji,
      this.version, this.position);

  factory Kana.fromJson(Map<String, dynamic> json) => _$KanaFromJson(json);
}
