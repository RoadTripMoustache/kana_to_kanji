import "package:freezed_annotation/freezed_annotation.dart";
import "package:kana_to_kanji/src/core/models/user/user_achievement.dart";
import "package:kana_to_kanji/src/core/models/user/user_learning.dart";
import "package:kana_to_kanji/src/core/models/user/user_preferences.dart";

part "user.freezed.dart";

part "user.g.dart";

@freezed
abstract class User with _$User {
  const User._();

  const factory User({
    required String externalId,
    required String createdAt,
    required String lastUpdate,
    required String displayName,
    required UserPreferences preferences,
    @Default("") String uuid,
    String? avatar,
    DateTime? streakStartDate,
    DateTime? streakLastUpdate,
    UserLearning? learning,
    @Default([]) List<UserAchievement> achievements,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Streak count
  int get streakCount {
    if (streakStartDate == null || streakLastUpdate == null) {
      return 0;
    }
    final start = DateTime.parse(streakStartDate.toString());
    final lastUpdate = DateTime.parse(streakLastUpdate.toString());
    return lastUpdate.difference(start).inDays + 1;
  }
}
