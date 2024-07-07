import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/authentication/services/auth_service.dart";
import "package:kana_to_kanji/src/core/constants/authentication_method.dart";
import "package:kana_to_kanji/src/core/repositories/user_repository.dart";
import "package:kana_to_kanji/src/core/services/token_service.dart";
import "package:kana_to_kanji/src/core/services/user_service.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:logger/logger.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

@GenerateNiceMocks([
  MockSpec<Logger>(),
  MockSpec<UserService>(),
  MockSpec<TokenService>(),
  MockSpec<FirebaseAuth>(),
  MockSpec<UserCredential>(),
  MockSpec<FirebaseApp>(),
  MockSpec<AuthService>()
])
import "user_repository_test.mocks.dart";

final loggerMock = MockLogger();
final userServiceMock = MockUserService();
final tokenServiceMock = MockTokenService();
final authServiceMock = MockAuthService();

void main() {
  group("UserRepository", () {
    late UserRepository repository;

    setUpAll(() async {
      locator
        ..registerSingleton<Logger>(loggerMock)
        ..registerSingleton<UserService>(userServiceMock)
        ..registerSingleton<TokenService>(tokenServiceMock)
        ..registerSingleton<AuthService>(authServiceMock);
      repository = UserRepository();
    });

    group("register", () {
      test("Correct registration", () async {
        final UserCredential userCredential = MockUserCredential();
        when(authServiceMock.signInAnonymously())
            .thenAnswer((_) => Future.value(userCredential));
        when(userServiceMock.getUser()).thenAnswer((_) => Future.value());

        final result =
            await repository.register(AuthenticationMethod.anonymous);

        verifyInOrder([
          authServiceMock.signInAnonymously(),
          userServiceMock.getUser(),
        ]);
        verifyNever(loggerMock.e(any));
        expect(result, true);
      });

      test("Incorrect registration - operation not allowed", () async {
        when(authServiceMock.signInAnonymously())
            .thenThrow(FirebaseAuthException(code: "operation-not-allowed"));

        final result =
            await repository.register(AuthenticationMethod.anonymous);

        verifyInOrder([
          authServiceMock.signInAnonymously(),
          loggerMock.e("Anonymous auth hasn't been enabled for this project.")
        ]);
        verifyNever(userServiceMock.getUser());
        verifyNever(loggerMock
            .e("Unknown error while doing anonymous authentication."));
        expect(result, false);
      });

      test("Incorrect registration - default", () async {
        when(authServiceMock.signInAnonymously())
            .thenThrow(FirebaseAuthException(code: "operwed"));

        final result =
            await repository.register(AuthenticationMethod.anonymous);

        verifyInOrder([
          authServiceMock.signInAnonymously(),
          loggerMock.e("Unknown error while doing anonymous authentication.")
        ]);
        verifyNever(userServiceMock.getUser());
        verifyNever(loggerMock
            .e("Anonymous auth hasn't been enabled for this project."));
        expect(result, false);
      });
    });
  });
}
