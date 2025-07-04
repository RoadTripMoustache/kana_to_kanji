import "dart:convert";

import "package:kana_to_kanji/src/core/constants/preference_flags.dart";
import "package:kana_to_kanji/src/core/dataloaders/user_dataloader.dart";
import "package:kana_to_kanji/src/core/models/user/user.dart";
import "package:kana_to_kanji/src/core/services/preferences_service.dart";
import "package:kana_to_kanji/src/locator.dart";

class UserService {
  final PreferencesService _preferencesService = locator<PreferencesService>();
  final UserDataLoader _userDataLoader = UserDataLoader();

  /// Get the current user
  Future<User?> getUser() async {
    final latestUser = await _userDataLoader.sync();

    if (latestUser != null) {
      await _saveUser(latestUser);
    }

    final record = await _preferencesService.getString(PreferenceFlags.user);

    if (record == null) {
      return null;
    }

    return _transformer(record);
  }

  /// Update the user in database with the new data given in parameter.
  Future _saveUser(User user) async {
    await _preferencesService.setString(
      PreferenceFlags.user,
      jsonEncode(user.toJson()),
    );
  }

  /// Update the user in database with the new data given in parameter.
  Future<User?> updateUser(User updatedUser) async {
    final user = await _userDataLoader.updateUser(
      updatedUser.copyWith(lastUpdate: DateTime.now().toIso8601String()),
    );
    if (user != null) {
      await _saveUser(user);
    }

    return user;
  }

  /// Delete the user given in parameter from the database.
  Future<void> deleteUser() async =>
      _preferencesService.removePreferenceFlags(PreferenceFlags.user);

  User _transformer(String snapshot) => User.fromJson(jsonDecode(snapshot));
}
