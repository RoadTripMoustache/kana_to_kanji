import "package:kana_to_kanji/src/core/constants/authentication_method.dart";
import "package:kana_to_kanji/src/core/models/user.dart";
import "package:stacked/stacked.dart";

class UserRepository with ListenableServiceMixin {
  UserRepository() {
    listenToReactiveValues([_self]);
  }

  User? _self;

  User? get self => _self;

  Future<bool> signOut() {
    _self = null;
    return Future.value(true);
  }

  Future<bool> signIn(AuthenticationMethod method,
      {bool isSilent = false, String? email, String? password}) {
    throw UnimplementedError();
  }

  Future<bool> register() {
    throw UnimplementedError();
  }

  Future<bool> updateSelf(User updatedUser) {
    throw UnimplementedError();
  }

  Future<bool> linkAccount(AuthenticationMethod method,
      {String? email, String? password}) {
    throw UnimplementedError();
  }

  Future<bool> deleteUser() {
    throw UnimplementedError();
  }

  Future<bool> updatePassword(String oldPassword, String newPassword) {
    throw UnimplementedError();
  }
}
