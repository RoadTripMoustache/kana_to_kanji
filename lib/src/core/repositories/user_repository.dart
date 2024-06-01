import "package:firebase_auth/firebase_auth.dart";
import "package:kana_to_kanji/src/authentication/services/auth_service.dart";
import "package:kana_to_kanji/src/core/constants/authentication_method.dart";
import "package:kana_to_kanji/src/core/models/user.dart" as ktk_user;
import "package:kana_to_kanji/src/core/services/dataloader_service.dart";
import "package:kana_to_kanji/src/core/services/token_service.dart";
import "package:kana_to_kanji/src/core/services/user_service.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:stacked/stacked.dart";

class UserRepository with ListenableServiceMixin {
  final UserService _userService = locator<UserService>();
  final AuthService _authService = locator<AuthService>();
  final TokenService _tokenService = locator<TokenService>();
  final DataloaderService _dataloaderService = locator<DataloaderService>();

  UserRepository() {
    listenToReactiveValues([_self]);
  }

  ktk_user.User? _self;

  ktk_user.User? get self => _self;

  Future<bool> signOut() {
    _self = null;
    return Future.value(true);
  }

  Future<void> signIn() async {
    _self = await _userService.getUser();
  }

  /// Sign in the user anonymously, store its token and create its user account
  /// in the database.
  /// Returns: Future<bool> - If the registration goes well, returns
  /// `Future.value(true)`. Otherwise `Future.value(false)`.
  Future<bool> register(AuthenticationMethod method,
      {bool isSilent = false, String email = "", String password = ""}) async {
    // Sign In
    UserCredential? userCredential;
    switch (method) {
      case AuthenticationMethod.anonymous:
        userCredential = await _authService.signInAnonymously();
      case AuthenticationMethod.apple:
        userCredential = await _authService.signInWithApple();
      case AuthenticationMethod.classic:
        userCredential = await _authService.signInEmail(email, password);
      case AuthenticationMethod.google:
        userCredential = await _authService.signInWithGoogle();
    }
    if (userCredential == null) {
      return Future.value(false);
    }

    // Store the user credentials
    _tokenService.userCredential = userCredential.user!;

    // Load/update the static data stored locally
    await _dataloaderService.loadStaticData();

    // Create the user in the API
    final user = await _userService.getUser();
    if (user == null) {
      return Future.value(false);
    } else {
      _self = user;
    }

    return Future.value(true);
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
