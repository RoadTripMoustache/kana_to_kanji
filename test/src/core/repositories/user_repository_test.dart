import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/authentication/services/auth_service.dart";
import "package:kana_to_kanji/src/core/constants/authentication_method.dart";
import "package:kana_to_kanji/src/core/models/user.dart" as ktk;
import "package:kana_to_kanji/src/core/repositories/user_repository.dart";
import "package:kana_to_kanji/src/core/services/dataloader_service.dart";
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
  MockSpec<AuthService>(),
  MockSpec<DataloaderService>(),
  MockSpec<ktk.User>(),
  MockSpec<User>(as: Symbol("FirebaseUserMock"))
])
import "user_repository_test.mocks.dart";

final loggerMock = MockLogger();
final userServiceMock = MockUserService();
final tokenServiceMock = MockTokenService();
final authServiceMock = MockAuthService();
final dataloaderServiceMock = MockDataloaderService();

void main() {
  group("UserRepository", () {
    late UserRepository repository;

    final UserCredential userCredential = MockUserCredential();
    final ktk.User ktkUser = MockUser();
    final User user = FirebaseUserMock();

    setUpAll(() async {
      locator
        ..registerSingleton<Logger>(loggerMock)
        ..registerSingleton<UserService>(userServiceMock)
        ..registerSingleton<TokenService>(tokenServiceMock)
        ..registerSingleton<AuthService>(authServiceMock)
        ..registerSingleton<DataloaderService>(dataloaderServiceMock);
      repository = UserRepository();
    });

    group("register", () {
      test("Correct registration - anonymous", () async {
        when(authServiceMock.authenticateAnonymously())
            .thenAnswer((_) => Future.value(userCredential));
        when(userCredential.user).thenReturn(user);
        when(userServiceMock.getUser())
            .thenAnswer((_) => Future.value(ktkUser));

        final result =
            await repository.authenticate(AuthenticationMethod.anonymous);

        verifyInOrder([
          authServiceMock.authenticateAnonymously(),
          dataloaderServiceMock.loadStaticData(),
          userServiceMock.getUser(),
        ]);
        verifyNever(loggerMock.e(any));
        expect(result, true);
      });
      test("Correct registration - apple", () async {
        when(authServiceMock.authenticateWithApple())
            .thenAnswer((_) => Future.value(userCredential));
        when(userCredential.user).thenReturn(user);
        when(userServiceMock.getUser())
            .thenAnswer((_) => Future.value(ktkUser));

        final result =
            await repository.authenticate(AuthenticationMethod.apple);

        verifyInOrder([
          authServiceMock.authenticateWithApple(),
          dataloaderServiceMock.loadStaticData(),
          userServiceMock.getUser(),
        ]);
        verifyNever(loggerMock.e(any));
        expect(result, true);
      });
      test("Correct registration - classic", () async {
        when(
          authServiceMock.authenticateWithEmail("toto", "tata"),
        ).thenAnswer((_) => Future.value(userCredential));
        when(userCredential.user).thenReturn(user);
        when(userServiceMock.getUser())
            .thenAnswer((_) => Future.value(ktkUser));

        final result = await repository.authenticate(
            AuthenticationMethod.classic,
            email: "toto",
            password: "tata");

        verifyInOrder([
          authServiceMock.authenticateWithEmail("toto", "tata"),
          dataloaderServiceMock.loadStaticData(),
          userServiceMock.getUser(),
        ]);
        verifyNever(loggerMock.e(any));
        expect(result, true);
      });
      test("Correct registration - google", () async {
        when(authServiceMock.authenticateWithGoogle())
            .thenAnswer((_) => Future.value(userCredential));
        when(userCredential.user).thenReturn(user);
        when(userServiceMock.getUser())
            .thenAnswer((_) => Future.value(ktkUser));

        final result =
            await repository.authenticate(AuthenticationMethod.google);

        verifyInOrder([
          authServiceMock.authenticateWithGoogle(),
          dataloaderServiceMock.loadStaticData(),
          userServiceMock.getUser(),
        ]);
        verifyNever(loggerMock.e(any));
        expect(result, true);
      });

      test("Incorrect registration - ktkUser credential null", () async {
        when(authServiceMock.authenticateAnonymously())
            .thenAnswer((_) => Future.value());

        final result =
            await repository.authenticate(AuthenticationMethod.anonymous);

        verifyInOrder([authServiceMock.authenticateAnonymously()]);
        verifyNever(dataloaderServiceMock.loadStaticData());
        verifyNever(userServiceMock.getUser());
        expect(result, false);
      });

      test("Incorrect registration - ktkUser null", () async {
        when(authServiceMock.authenticateAnonymously())
            .thenAnswer((_) => Future.value(userCredential));
        when(userCredential.user).thenReturn(user);
        when(userServiceMock.getUser()).thenAnswer((_) => Future.value());

        final result =
            await repository.authenticate(AuthenticationMethod.anonymous);

        verifyInOrder([
          authServiceMock.authenticateAnonymously(),
          dataloaderServiceMock.loadStaticData(),
          userServiceMock.getUser()
        ]);
        expect(result, false);
      });
    });
  });
}
