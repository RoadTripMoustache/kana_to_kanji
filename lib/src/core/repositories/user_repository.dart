import "package:firebase_auth/firebase_auth.dart" as firebase;
import "package:kana_to_kanji/src/authentication/services/auth_service.dart";
import "package:kana_to_kanji/src/core/constants/authentication_method.dart";
import "package:kana_to_kanji/src/core/models/user/user.dart";
import "package:kana_to_kanji/src/core/services/user_service.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:logger/logger.dart";
import "package:stacked/stacked.dart";

class UserRepository with ListenableServiceMixin {
  final Logger _logger = locator<Logger>();
  final AuthService _authService = locator<AuthService>();
  late final UserService _userService;

  /// [userService] is visible for testing purpose.
  UserRepository({UserService? userService}) {
    _userService = userService ?? UserService();
    listenToReactiveValues([_self]);
  }

  User? _self;

  User? get self => _self;

  Future<bool> signOut() {
    _self = null;
    return Future.value(true);
  }

  Future<bool> silentSignIn() => _authService.silentSignIn();

  Future<bool> signIn(
    AuthenticationMethod method, {
    String? email,
    String? password,
  }) {
    throw UnimplementedError();
  }

  /// Sign in the user anonymously, store its token and create its user account
  /// in the database.
  ///
  /// If the registration goes well, returns `Future.value(true)`.
  /// Otherwise `Future.value(false)`.
  Future<bool> register(AuthenticationMethod method) async {
    try {
      await _authService.signInAnonymously();
      final User? user = await _userService.getUser();

      return user != null;
    } on firebase.FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          _logger.e("Anonymous auth hasn't been enabled for this project.");
        default:
          _logger.e("Unknown error while doing anonymous authentication.");
      }
      return Future.value(false);
    }
  }

  Future<bool> updateSelf(User updatedUser) {
    throw UnimplementedError();
  }

  Future<bool> linkAccount(
    AuthenticationMethod method, {
    String? email,
    String? password,
  }) {
    throw UnimplementedError();
  }

  Future<bool> deleteUser() {
    throw UnimplementedError();
  }

  Future<bool> updatePassword(String oldPassword, String newPassword) {
    throw UnimplementedError();
  }
}
