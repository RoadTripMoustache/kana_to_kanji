import "package:freezed_annotation/freezed_annotation.dart";
import "package:isar/isar.dart";
import "package:kana_to_kanji/src/core/constants/resource_type.dart";

part "resource_uid.g.dart";

@embedded
@JsonSerializable()
@immutable
class ResourceUid {
  final String uid;

  @enumValue
  final ResourceType resourceType;

  const ResourceUid(this.uid, this.resourceType);

  factory ResourceUid.fromJson(String uid) => ResourceUid.fromString(uid);

  factory ResourceUid.fromString(String uid) => ResourceUid(
      uid,
      ResourceType.values
          .firstWhere((element) => element.name == uid.split("-")[0]));

  @override
  bool operator ==(covariant ResourceUid other) =>
      identical(this, other) ||
      (other.uid == uid && other.resourceType == resourceType);

  @override
  int get hashCode => uid.hashCode + resourceType.hashCode;
}
