import "package:freezed_annotation/freezed_annotation.dart";
import "package:isar/isar.dart";

part "user_achievement_level_unlocked.g.dart";

@embedded
@JsonSerializable()
class UserAchievementLevelUnlocked {
  final int level;

  @JsonKey(name: "unlocked_at")
  final String unlockedAt;

  const UserAchievementLevelUnlocked(this.level, this.unlockedAt);

  factory UserAchievementLevelUnlocked.fromJson(Map<String, dynamic> json) =>
      _$UserAchievementLevelUnlockedFromJson(json);
}
