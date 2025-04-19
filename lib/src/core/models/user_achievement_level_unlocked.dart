import "package:freezed_annotation/freezed_annotation.dart";

part "user_achievement_level_unlocked.freezed.dart";
part "user_achievement_level_unlocked.g.dart";

@freezed
abstract class UserAchievementLevelUnlocked
    with _$UserAchievementLevelUnlocked {
  const factory UserAchievementLevelUnlocked({
    required int level,
    required String unlockedAt,
  }) = _UserAchievementLevelUnlocked;

  factory UserAchievementLevelUnlocked.fromJson(Map<String, dynamic> json) =>
      _$UserAchievementLevelUnlockedFromJson(json);
}
