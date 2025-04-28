import "package:freezed_annotation/freezed_annotation.dart";
import "package:kana_to_kanji/src/core/constants/learning_mode.dart";
import "package:kana_to_kanji/src/core/models/user_learning_progression.dart";

part "user_learning.freezed.dart";
part "user_learning.g.dart";

@freezed
abstract class UserLearning with _$UserLearning {
  const factory UserLearning({
    required LearningMode mode,
    required String modeLastUpdate,
    required int newResourcesIntroduced,

    required UserLearningProgression progression,
  }) = _UserLearning;

  factory UserLearning.fromJson(Map<String, dynamic> json) =>
      _$UserLearningFromJson(json);
}
