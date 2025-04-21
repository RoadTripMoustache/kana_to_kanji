import "package:freezed_annotation/freezed_annotation.dart";
import "package:kana_to_kanji/src/core/constants/resource_type.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";

part "user_learning_progression.freezed.dart";
part "user_learning_progression.g.dart";

@freezed
abstract class UserLearningProgression with _$UserLearningProgression {
  const factory UserLearningProgression({
    /// Index of the last resource shown in the current level
    required int resource,

    /// Uid of the current learning stage
    @Default(ResourceUid("", ResourceType.stage)) ResourceUid stage,

    /// Uid of the current learning level
    @Default(ResourceUid("", ResourceType.level)) ResourceUid level,
  }) = _UserLearningProgression;

  factory UserLearningProgression.fromJson(Map<String, dynamic> json) =>
      _$UserLearningProgressionFromJson(json);
}
