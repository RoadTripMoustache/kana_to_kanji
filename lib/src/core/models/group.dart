import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';
import 'package:kana_to_kanji/src/core/constants/alphabets.dart';
import 'package:kana_to_kanji/src/core/constants/kana_type.dart';

part 'group.g.dart';

@collection
@Name("Groups")
@JsonSerializable()
class Group {
  final int id;

  @enumValue
  final Alphabets alphabet;

  final String name;

  @enumValue
  final KanaTypes kanaType;

  final String? localizedName;

  Group(this.id, this.alphabet, this.name, this.kanaType, this.localizedName);

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}
