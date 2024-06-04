import "package:isar/isar.dart";
import "package:kana_to_kanji/src/core/dataloaders/user_dataloader.dart";
import "package:kana_to_kanji/src/core/models/api_user.dart";
import "package:kana_to_kanji/src/core/models/user.dart";
import "package:kana_to_kanji/src/locator.dart";

class UserService {
  final Isar _isar = locator<Isar>();
  final UserDataLoader _userDataLoader = locator<UserDataLoader>();

  /// Get the current user
  Future<User?> getUser() async {
    await _userDataLoader.loadCollection();

    return _isar.users.where().findFirst();
  }

  /// Update the user in database with the new data given in parameter.
  Future<User?> updateUser(ApiUser userPatch) async {
    final User? updatedUser = await _userDataLoader.patchUser(userPatch);

    if (updatedUser != null) {
      await _isar.writeAsync((isar) => isar.users.put(updatedUser));
    }
    return Future.value(updatedUser);
  }

  /// Delete the user given in parameter from the database.
  Future<bool> deleteUser(User updatedUser) async {
    throw UnimplementedError();
  }
}
