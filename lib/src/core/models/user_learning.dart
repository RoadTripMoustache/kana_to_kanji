import "package:freezed_annotation/freezed_annotation.dart";
import "package:kana_to_kanji/src/core/constants/learning_mode.dart";

part "user_learning.freezed.dart";

part "user_learning.g.dart";

@freezed
abstract class UserLearning with _$UserLearning {
  const factory UserLearning({
    required String modeLastUpdate,
    required LearningMode mode,
    // required UserLearningProgression progression,
    @Default(0) int newResourcesIntroduced,
  }) = _UserLearning;

  factory UserLearning.fromJson(Map<String, dynamic> json) =>
      _$UserLearningFromJson(json);
}
