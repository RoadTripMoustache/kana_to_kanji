import "package:freezed_annotation/freezed_annotation.dart";
import "package:kana_to_kanji/src/core/constants/alphabets.dart";
import "package:kana_to_kanji/src/core/constants/kana_type.dart";
import "package:kana_to_kanji/src/core/models/resource.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";

part "group.freezed.dart";
part "group.g.dart";

@freezed
class Group extends Resource with _$Group {
  const factory Group({
    required ResourceUid uid,
    required Alphabets alphabet,
    required String name,
    required KanaTypes kanaType,
    required String version,
    String? localizedName,
  }) = _Group;

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}
