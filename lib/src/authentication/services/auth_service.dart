import "package:firebase_auth/firebase_auth.dart";

/// [AuthService] Manage all the authentications processes related to firebase.
/// It's for 2 objectives :
/// - Isolate the code to have a better reusability
/// - Facilitate unit tests
class AuthService {
  /// Sign in anonymously using Firebase.
  /// Returns a UserCredential which contains all the information of the current
  /// user, its token...
  Future<UserCredential> signInAnonymously() =>
      FirebaseAuth.instance.signInAnonymously();
}
