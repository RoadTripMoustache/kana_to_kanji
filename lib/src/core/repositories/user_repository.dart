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

  /// Authenticate the user with the [AuthenticationMethod] selected, store its
  /// token and get the user account in the database.
  ///
  /// If the user doesn't exist, it will be created instead.
  ///
  /// If the user wants to authenticate themself with the [classic] method,
  /// they must define an [email] and a [password].
  ///
  /// Returns a [bool] to let you know if the authentication went well or not.
  Future<bool> authenticate(AuthenticationMethod method,
      {bool isSilent = false, String email = "", String password = ""}) async {
    // Sign In
    UserCredential? userCredential;
    switch (method) {
      case AuthenticationMethod.anonymous:
        userCredential = await _authService.authenticateAnonymously();
      case AuthenticationMethod.apple:
        userCredential = await _authService.authenticateWithApple();
      case AuthenticationMethod.classic:
        userCredential =
            await _authService.authenticateWithEmail(email, password);
      case AuthenticationMethod.google:
        userCredential = await _authService.authenticateWithGoogle();
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
