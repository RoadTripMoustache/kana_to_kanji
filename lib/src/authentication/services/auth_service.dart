import "package:firebase_auth/firebase_auth.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:logger/logger.dart";

/// [AuthService] Manage all the authentications processes related to firebase.
/// It's for 2 objectives :
/// - Isolate the code to have a better reusability
/// - Facilitate unit tests
class AuthService {
  final Logger _logger = locator<Logger>();

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final AppleAuthProvider _appleAuthProvider = AppleAuthProvider();

  Future<User?> getCurrentUser() async => FirebaseAuth.instance.currentUser;

  /// Authenticate anonymously the user using Firebase.
  /// returns : Future<UserCredential?> - Contains all the information of the
  /// current user, its token...
  /// The UserCredential is null if an error occurs.
  Future<UserCredential?> authenticateAnonymously() async {
    try {
      return await FirebaseAuth.instance.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      _logger.e(e);
    }
    return null;
  }

  /// Authenticate the user with a Google account.
  /// returns : Future<UserCredential?> - Contains all the information of the
  /// current user, its token...
  /// The UserCredential is null if an error occurs.
  Future<UserCredential?> authenticateWithGoogle() async {
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

  /// Authenticate the user with an Apple account.
  /// returns : Future<UserCredential?> - Contains all the information of the
  /// current user, its token...
  /// The UserCredential is null if an error occurs.
  Future<UserCredential> authenticateWithApple() async =>
      await FirebaseAuth.instance.signInWithProvider(_appleAuthProvider);

  /// Authenticate the user with an [email] and a [password].
  Future<UserCredential?> authenticateWithEmail(
      String email, String password) async {
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
}
