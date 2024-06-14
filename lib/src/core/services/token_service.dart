import "package:firebase_auth/firebase_auth.dart";

/// TokenService contains all the methods to store the auth credentials, update
/// it and contains all the token manipulations methods.
class TokenService {
  User? _firebaseUser;

  /// getToken - Get the current token of the user, or generates a new one if
  /// the current one is expired.
  Future<String?> getToken() async => await _firebaseUser?.getIdToken();

  // ignore:avoid_setters_without_getters
  set userCredential(User firebaseUser) {
    _firebaseUser = firebaseUser;
  }
}
