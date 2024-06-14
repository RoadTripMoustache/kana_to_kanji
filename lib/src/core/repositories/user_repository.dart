import "package:firebase_auth/firebase_auth.dart";
import "package:kana_to_kanji/src/authentication/services/auth_service.dart";
import "package:kana_to_kanji/src/core/constants/authentication_method.dart";
import "package:kana_to_kanji/src/core/models/user.dart" as ktk_user;
import "package:kana_to_kanji/src/core/services/token_service.dart";
import "package:kana_to_kanji/src/core/services/user_service.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:logger/logger.dart";
import "package:stacked/stacked.dart";

class UserRepository with ListenableServiceMixin {
  final Logger _logger = locator<Logger>();
  final UserService _userService = locator<UserService>();
  final AuthService _authService = locator<AuthService>();
  final TokenService _tokenService = locator<TokenService>();

  UserRepository() {
    listenToReactiveValues([_self]);
  }

  ktk_user.User? _self;

  ktk_user.User? get self => _self;

  Future<bool> signOut() {
    _self = null;
    return Future.value(true);
  }

  Future<bool> signIn(AuthenticationMethod method,
      {bool isSilent = false, String? email, String? password}) {
    throw UnimplementedError();
  }

  /// Sign in the user anonymously, store its token and create its user account
  /// in the database.
  /// Returns: Future<bool> - If the registration goes well, returns
  /// `Future.value(true)`. Otherwise `Future.value(false)`.
  Future<bool> register() async {
    try {
      final userCredential = await _authService.signInAnonymously();
      _tokenService.token = userCredential;
      return _userService.getUser().then((value) => true);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          _logger.e("Anonymous auth hasn't been enabled for this project.");
        default:
          _logger.e("Unknown error while doing anonymous authentication.");
      }
      return Future.value(false);
    }
  }

  Future<bool> updateSelf(ktk_user.User updatedUser) {
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
