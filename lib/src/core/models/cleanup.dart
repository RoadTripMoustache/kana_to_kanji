import "package:freezed_annotation/freezed_annotation.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";

part "cleanup.freezed.dart";

part "cleanup.g.dart";

@freezed
class CleanUpData with _$CleanUpData {
  const factory CleanUpData({@Default([]) List<ResourceUid> deletedResources}) =
      _CleanUpData;

  factory CleanUpData.fromJson(Map<String, dynamic> json) =>
      _$CleanUpDataFromJson(json);
}
