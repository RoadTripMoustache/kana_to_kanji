import "package:freezed_annotation/freezed_annotation.dart";
import "package:kana_to_kanji/src/core/models/user_achievement_level_unlocked.dart";

part "user_achievement.freezed.dart";
part "user_achievement.g.dart";

@freezed
abstract class UserAchievement with _$UserAchievement {
  const factory UserAchievement({
    required int id,
    required double currentProgress,
    @Default([]) List<UserAchievementLevelUnlocked> levelsUnlocked,
  }) = _UserAchievement;

  factory UserAchievement.fromJson(Map<String, dynamic> json) =>
      _$UserAchievementFromJson(json);
}
