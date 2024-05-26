import "package:freezed_annotation/freezed_annotation.dart";
import "package:isar/isar.dart";
import "package:kana_to_kanji/src/core/constants/learning_mode.dart";
import "package:kana_to_kanji/src/core/constants/resource_type.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";
import "package:kana_to_kanji/src/core/models/user_learning_progression.dart";

part "user_learning.g.dart";

@embedded
@JsonSerializable()
class UserLearning {
  @enumValue
  final LearningMode mode;

  @JsonKey(name: "mode_last_update")
  final String modeLastUpdate;

  @JsonKey(name: "new_resources_introduced")
  final int newResourcesIntroduced;

  final UserLearningProgression progression;

  const UserLearning(
    this.mode,
    this.modeLastUpdate,
    this.newResourcesIntroduced,
    this.progression,
  );

  factory UserLearning.fromJson(Map<String, dynamic> json) =>
      _$UserLearningFromJson(json);
}
