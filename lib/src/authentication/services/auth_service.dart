import "package:firebase_auth/firebase_auth.dart";

/// [AuthService] Manage all the authentications processes related to firebase.
/// It's for 2 objectives :
/// - Isolate the code to have a better reusability
/// - Facilitate unit tests
class AuthService {
  final FirebaseAuth _firebaseAuth;

  /// [firebaseAuth] should only be used for testing.
  AuthService({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<String?> getAuthToken() async =>
      _firebaseAuth.currentUser?.getIdToken();

  /// Sign in anonymously using Firebase.
  /// Returns a UserCredential which contains all the information of the current
  /// user, its token...
  Future<UserCredential> signInAnonymously() =>
      _firebaseAuth.signInAnonymously();

  /// Try to silent sign in the user.
  Future<bool> silentSignIn() async {
    final user = _firebaseAuth.currentUser;

    return user != null;
  }

  /// Sign out the user on Firebase.
  Future<void> signOut() => _firebaseAuth.signOut();
}
