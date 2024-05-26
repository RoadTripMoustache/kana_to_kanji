import "package:freezed_annotation/freezed_annotation.dart";
import "package:isar/isar.dart";
import "package:kana_to_kanji/src/core/constants/languages.dart";

part "user_preferences.g.dart";

@embedded
@JsonSerializable()
class UserPreferences {
  @enumValue
  final Languages language;

  const UserPreferences(this.language);

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);
}
