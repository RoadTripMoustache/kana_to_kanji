import "package:freezed_annotation/freezed_annotation.dart";
import "package:isar/isar.dart";
import "package:kana_to_kanji/src/core/constants/resource_type.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";

part "user_learning_progression.g.dart";

@embedded
@JsonSerializable()
class UserLearningProgression {
  /// Uid of the current learning stage
  @Default(ResourceUid("", ResourceType.stage))
  final ResourceUid stage;

  /// Uid of the current learning level
  @Default(ResourceUid("", ResourceType.level))
  final ResourceUid level;

  /// Index of the last resource shown in the current level
  final int resource;

  const UserLearningProgression(this.stage, this.level, this.resource);

  factory UserLearningProgression.fromJson(Map<String, dynamic> json) =>
      _$UserLearningProgressionFromJson(json);
}
