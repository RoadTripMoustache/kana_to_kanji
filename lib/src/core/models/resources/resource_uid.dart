import "package:freezed_annotation/freezed_annotation.dart";
import "package:kana_to_kanji/src/core/constants/resource_type.dart";

part "resource_uid.freezed.dart";

@Freezed(fromJson: false, toJson: false, toStringOverride: false)
abstract class ResourceUid with _$ResourceUid {
  const ResourceUid._();

  const factory ResourceUid(String uid, ResourceType resourceType) =
      _ResourceUid;

  factory ResourceUid.fromJson(String uid) => ResourceUid(
    uid,
    ResourceType.values.firstWhere(
      (element) => element.name == uid.split("-")[0],
    ),
  );

  String toJson() => uid;

  @override
  String toString() => uid;
}
