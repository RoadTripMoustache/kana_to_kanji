import "package:firebase_auth/firebase_auth.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:kana_to_kanji/src/authentication/utils/crypto_utils.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:logger/logger.dart";
import "package:sign_in_with_apple/sign_in_with_apple.dart";

/// [AuthService] Manage all the authentications processes related to firebase.
/// It's for 2 objectives :
/// - Isolate the code to have a better reusability
/// - Facilitate unit tests
class AuthService {
  final Logger _logger = locator<Logger>();

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> getCurrentUser() async =>
      Future.value(FirebaseAuth.instance.currentUser);

  /// Sign in anonymously using Firebase.
  /// returns : Future<UserCredential?> - Contains all the information of the
  /// current user, its token...
  /// The UserCredential is null if an error occurs.
  Future<UserCredential?> signInAnonymously() async {
    try {
      return await FirebaseAuth.instance.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      _logger.e(e);
      return Future.value();
    }
  }

  /// Sing in with Google.
  /// returns : Future<UserCredential?> - Contains all the information of the
  /// current user, its token...
  /// The UserCredential is null if an error occurs.
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      _logger.e(e);
      return Future.value();
    }
  }

  Future<UserCredential?> linkAccountWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.currentUser
          ?.linkWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      _logger.e(e);
      return Future.value();
    }
  }

  /// Sing in with Apple.
  /// returns : Future<UserCredential?> - Contains all the information of the
  /// current user, its token...
  /// The UserCredential is null if an error occurs.
  Future<UserCredential> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

  Future<UserCredential?> linkAccountWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Link the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail
    return await FirebaseAuth.instance.currentUser
        ?.linkWithCredential(oauthCredential);
  }

  Future<UserCredential?> signInEmail(String email, String password) async {
    try {
      return await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      _logger.e(e);
      if (e.code == "user-not-found") {
        _logger.e("No user found for that email.");
      } else if (e.code == "wrong-password") {
        _logger.e("Wrong password provided for that user.");
      }
      return Future.value();
    }
  }

  Future<UserCredential?> linkAccountWithEmail(
      String email, String password) async {
    try {
      final credential =
          EmailAuthProvider.credential(email: email, password: password);
      return await FirebaseAuth.instance.currentUser
          ?.linkWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      _logger.e(e);
      switch (e.code) {
        case "provider-already-linked":
          _logger.e("The provider has already been linked to the user.");
        case "invalid-credential":
          _logger.e("The provider's credential is not valid.");
        case "credential-already-in-use":
          _logger
              .e("The account corresponding to the credential already exists, "
                  "or is already linked to a Firebase User.");
        // See the API reference for the full list of error codes.
        default:
          _logger.e("Unknown error.");
      }
      return Future.value();
    }
  }
}
