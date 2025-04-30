import "package:firebase_auth/firebase_auth.dart" as firebase;
import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/authentication/services/auth_service.dart";
import "package:kana_to_kanji/src/core/constants/authentication_method.dart";
import "package:kana_to_kanji/src/core/models/user/user.dart";
import "package:kana_to_kanji/src/core/repositories/user_repository.dart";
import "package:kana_to_kanji/src/core/services/user_service.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:logger/logger.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

import "../../../helpers.dart";
@GenerateNiceMocks([
  MockSpec<Logger>(),
  MockSpec<UserService>(),
  MockSpec<firebase.FirebaseAuth>(),
  MockSpec<firebase.UserCredential>(),
  MockSpec<User>(),
  MockSpec<AuthService>(),
])
import "user_repository_test.mocks.dart";

void main() {
  final loggerMock = MockLogger();
  final userServiceMock = MockUserService();
  final authServiceMock = MockAuthService();

  group("UserRepository", () {
    late UserRepository repository;

    setUpAll(() async {
      locator
        ..registerSingleton<Logger>(loggerMock)
        ..registerSingleton<AuthService>(authServiceMock);
    });

    setUp(() {
      repository = UserRepository(userService: userServiceMock);
    });

    tearDown(() {
      reset(loggerMock);
      reset(userServiceMock);
      reset(authServiceMock);
    });

    tearDownAll(() async {
      await Future.wait([unregister<Logger>(), unregister<AuthService>()]);
    });

    group("register", () {
      test("Correct registration", () async {
        final firebase.UserCredential userCredential = MockUserCredential();
        when(
          authServiceMock.signInAnonymously(),
        ).thenAnswer((_) => Future.value(userCredential));
        when(userServiceMock.getUser()).thenAnswer((_) async => MockUser());

        final result = await repository.register(
          AuthenticationMethod.anonymous,
        );

        verifyInOrder([
          authServiceMock.signInAnonymously(),
          userServiceMock.getUser(),
        ]);
        expect(result, true);
      });

      test("Incorrect registration - operation not allowed", () async {
        when(authServiceMock.signInAnonymously()).thenThrow(
          firebase.FirebaseAuthException(code: "operation-not-allowed"),
        );

        final result = await repository.register(
          AuthenticationMethod.anonymous,
        );

        verifyInOrder([
          authServiceMock.signInAnonymously(),
          loggerMock.e("Anonymous auth hasn't been enabled for this project."),
        ]);
        verifyNever(userServiceMock.getUser());
        verifyNever(
          loggerMock.e("Unknown error while doing anonymous authentication."),
        );
        expect(result, false);
      });

      test("Incorrect registration - default", () async {
        when(
          authServiceMock.signInAnonymously(),
        ).thenThrow(firebase.FirebaseAuthException(code: "operwed"));

        final result = await repository.register(
          AuthenticationMethod.anonymous,
        );

        verifyInOrder([
          authServiceMock.signInAnonymously(),
          loggerMock.e("Unknown error while doing anonymous authentication."),
        ]);
        verifyNever(userServiceMock.getUser());
        verifyNever(
          loggerMock.e("Anonymous auth hasn't been enabled for this project."),
        );
        expect(result, false);
      });
    });
  });
}
