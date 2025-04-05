import "package:freezed_annotation/freezed_annotation.dart";
import "package:kana_to_kanji/src/core/models/user_achievement.dart";
import "package:kana_to_kanji/src/core/models/user_learning.dart";
import "package:kana_to_kanji/src/core/models/user_preferences.dart";

part "user.freezed.dart";
part "user.g.dart";

@freezed
class User with _$User {
  const factory User({
    @Default("") String uuid,

    required String externalId,

    required String createdAt,

    required String lastUpdate,

    required String displayName,

    String? avatar,

    required UserPreferences preferences,

    String? streakStartDate,

    String? streakLastUpdate,

    UserLearning? learning,

    @Default([]) List<UserAchievement> achievements,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
