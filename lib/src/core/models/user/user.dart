import "package:freezed_annotation/freezed_annotation.dart";
import "package:kana_to_kanji/src/core/models/user/user_achievement.dart";
import "package:kana_to_kanji/src/core/models/user/user_learning.dart";
import "package:kana_to_kanji/src/core/models/user/user_preferences.dart";

part "user.freezed.dart";
part "user.g.dart";

@freezed
abstract class User with _$User {
  const factory User({
    required String externalId,
    required String createdAt,
    required String lastUpdate,
    required String displayName,
    required UserPreferences preferences,
    @Default("") String uuid,
    String? avatar,
    String? streakStartDate,
    String? streakLastUpdate,
    UserLearning? learning,
    @Default([]) List<UserAchievement> achievements,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
