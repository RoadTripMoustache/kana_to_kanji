import "package:freezed_annotation/freezed_annotation.dart";
import "package:isar/isar.dart";
import "package:kana_to_kanji/src/core/constants/languages.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";
import "package:kana_to_kanji/src/core/models/user_achievement.dart";
import "package:kana_to_kanji/src/core/models/user_achievement_level_unlocked.dart";
import "package:kana_to_kanji/src/core/models/user_learning.dart";
import "package:kana_to_kanji/src/core/models/user_learning_progression.dart";
import "package:kana_to_kanji/src/core/models/user_preferences.dart";
import "package:kana_to_kanji/src/core/utils/isar_utils.dart";

part "user.g.dart";

@collection
@Name("Users")
@JsonSerializable()
class User {
  @Default("")
  final String uuid;
  int get id => fastHash(uuid);

  @JsonKey(name: "external_id")
  final String externalId;

  @JsonKey(name: "created_at")
  final String createdAt;

  @JsonKey(name: "last_update")
  final String lastUpdate;

  @JsonKey(name: "display_name")
  final String displayName;

  @JsonKey(name: "avatar")
  final String? avatar;

  final UserPreferences preferences;

  @JsonKey(name: "streak_start_date")
  final String? streakStartDate;

  @JsonKey(name: "streak_last_update")
  final String? streakLastUpdate;

  final UserLearning? learning;

  @Default([])
  final List<UserAchievement> achievements;

  const User(
    this.uuid,
    this.externalId,
    this.createdAt,
    this.lastUpdate,
    this.displayName,
    this.avatar,
    this.preferences,
    this.streakStartDate,
    this.streakLastUpdate,
    this.learning,
    this.achievements,
  );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
