import "package:freezed_annotation/freezed_annotation.dart";
import "package:kana_to_kanji/src/core/constants/languages.dart";

part "user_preferences.freezed.dart";
part "user_preferences.g.dart";

@freezed
class UserPreferences with _$UserPreferences {
  const factory UserPreferences({required Languages language}) =
      _UserPreferences;

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);
}
