import "package:freezed_annotation/freezed_annotation.dart";
import "package:isar/isar.dart";
import "package:kana_to_kanji/src/core/constants/resource_type.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";

part "cleanup.g.dart";

@embedded
@JsonSerializable()
class CleanUpData {
  @Default([])
  @JsonKey(name: "deleted_resources")
  final List<ResourceUid> deletedResources;

  const CleanUpData(this.deletedResources);

  factory CleanUpData.fromJson(Map<String, dynamic> json) =>
      _$CleanUpDataFromJson(json);
}
