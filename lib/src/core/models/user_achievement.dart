import "package:freezed_annotation/freezed_annotation.dart";
import "package:isar/isar.dart";
import "package:kana_to_kanji/src/core/models/user_achievement_level_unlocked.dart";

part "user_achievement.g.dart";

@embedded
@JsonSerializable()
class UserAchievement {
  final int id;

  @JsonKey(name: "current_progress")
  final double currentProgress;
  @Default([])
  @JsonKey(name: "levels_unlocked")
  final List<UserAchievementLevelUnlocked> levelsUnlocked;

  const UserAchievement(this.id, this.currentProgress, this.levelsUnlocked);

  factory UserAchievement.fromJson(Map<String, dynamic> json) =>
      _$UserAchievementFromJson(json);
}
