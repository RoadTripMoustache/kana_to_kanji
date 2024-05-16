import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';
import 'package:kana_to_kanji/src/core/constants/alphabets.dart';
import 'package:kana_to_kanji/src/core/constants/kana_type.dart';
import 'package:kana_to_kanji/src/core/constants/resource_type.dart';
import 'package:kana_to_kanji/src/core/models/resource_uid.dart';
import 'package:kana_to_kanji/src/core/utils/isar_utils.dart';

part 'group.g.dart';

@collection
@Name("Groups")
@JsonSerializable()
class Group {
  @Default(ResourceUid("", ResourceType.group))
  final ResourceUid uid;
  int get id => fastHash(uid.uid);

  @enumValue
  final Alphabets alphabet;

  final String name;

  @enumValue
  final KanaTypes kanaType;

  final String? localizedName;

  final String version;

  Group(this.uid, this.alphabet, this.name, this.kanaType, this.localizedName,
      this.version);

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}
