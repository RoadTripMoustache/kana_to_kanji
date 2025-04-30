import "package:firebase_auth/firebase_auth.dart" as firebase;
import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/authentication/services/auth_service.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

@GenerateMocks([firebase.FirebaseAuth, firebase.User, firebase.UserCredential])
import "auth_service_test.mocks.dart";

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;
  late AuthService authService;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUser = MockUser();
    mockUserCredential = MockUserCredential();
    authService = AuthService(firebaseAuth: mockFirebaseAuth);
  });

  tearDown(() {
    reset(mockFirebaseAuth);
    reset(mockUserCredential);
    reset(mockUser);
  });

  group("AuthService", () {
    group("getAuthToken", () {
      test("getAuthToken returns token when user is authenticated", () async {
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.getIdToken()).thenAnswer((_) async => "test_token");

        final token = await authService.getAuthToken();

        expect(token, equals("test_token"));
        verify(mockFirebaseAuth.currentUser).called(1);
        verify(mockUser.getIdToken()).called(1);
      });

      test("getAuthToken returns null when no user is authenticated", () async {
        when(mockFirebaseAuth.currentUser).thenReturn(null);

        final token = await authService.getAuthToken();

        expect(token, isNull);
        verify(mockFirebaseAuth.currentUser).called(1);
      });
    });

    group("silentSignIn", () {
      test("silentSignIn returns true when auth token exists", () async {
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.getIdToken()).thenAnswer((_) async => "test_token");

        final result = await authService.silentSignIn();

        expect(result, isTrue);
        verify(mockFirebaseAuth.currentUser).called(1);
      });

      test("silentSignIn returns false when no auth token", () async {
        when(mockFirebaseAuth.currentUser).thenReturn(null);

        final result = await authService.silentSignIn();

        expect(result, isFalse);
        verify(mockFirebaseAuth.currentUser).called(1);
      });
    });

    group("signInAnonymously", () {
      test(
        "signInAnonymously succeeds and returns the user credential",
        () async {
          when(
            mockFirebaseAuth.signInAnonymously(),
          ).thenAnswer((_) async => mockUserCredential);
          when(mockUserCredential.user).thenReturn(mockUser);

          final result = await authService.signInAnonymously();

          expect(result, mockUserCredential);
          verify(mockFirebaseAuth.signInAnonymously()).called(1);
        },
      );
    });

    group("signOut", () {
      test("should successfully signs out user", () async {
        when(mockFirebaseAuth.signOut()).thenAnswer((_) async => {});

        await authService.signOut();

        verify(mockFirebaseAuth.signOut()).called(1);
      });
    });
  });
}
