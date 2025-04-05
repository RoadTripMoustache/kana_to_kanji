import "package:freezed_annotation/freezed_annotation.dart";
import "package:kana_to_kanji/src/core/constants/resource_type.dart";

part "resource_uid.freezed.dart";

part "resource_uid.g.dart";

@freezed
class ResourceUid with _$ResourceUid {
  const factory ResourceUid(String uid, ResourceType resourceType) =
      _ResourceUid;

  factory ResourceUid.fromJson(Map<String, dynamic> json) =>
      _$ResourceUidFromJson(json);

  factory ResourceUid.fromString(String uid) => ResourceUid(
    uid,
    ResourceType.values.firstWhere(
      (element) => element.name == uid.split("-")[0],
    ),
  );
}
