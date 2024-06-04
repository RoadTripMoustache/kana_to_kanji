import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/authentication/services/auth_service.dart";
import "package:kana_to_kanji/src/core/constants/authentication_method.dart";
import "package:kana_to_kanji/src/core/models/api_user.dart";
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
        when(authServiceMock.signInAnonymously())
            .thenAnswer((_) => Future.value(userCredential));
        when(userCredential.user).thenReturn(user);
        when(userServiceMock.getUser())
            .thenAnswer((_) => Future.value(ktkUser));

        final result =
            await repository.register(AuthenticationMethod.anonymous);

        verifyInOrder([
          authServiceMock.signInAnonymously(),
          dataloaderServiceMock.loadStaticData(),
          userServiceMock.getUser(),
        ]);
        verifyNever(loggerMock.e(any));
        expect(result, true);
      });
      test("Correct registration - apple", () async {
        when(authServiceMock.signInWithApple())
            .thenAnswer((_) => Future.value(userCredential));
        when(userCredential.user).thenReturn(user);
        when(userServiceMock.getUser())
            .thenAnswer((_) => Future.value(ktkUser));

        final result = await repository.register(AuthenticationMethod.apple);

        verifyInOrder([
          authServiceMock.signInWithApple(),
          dataloaderServiceMock.loadStaticData(),
          userServiceMock.getUser(),
        ]);
        verifyNever(loggerMock.e(any));
        expect(result, true);
      });
      test("Correct registration - classic", () async {
        when(
          authServiceMock.signInEmail("toto", "tata"),
        ).thenAnswer((_) => Future.value(userCredential));
        when(userCredential.user).thenReturn(user);
        when(userServiceMock.getUser())
            .thenAnswer((_) => Future.value(ktkUser));

        final result = await repository.register(AuthenticationMethod.classic,
            email: "toto", password: "tata");

        verifyInOrder([
          authServiceMock.signInEmail("toto", "tata"),
          dataloaderServiceMock.loadStaticData(),
          userServiceMock.getUser(),
        ]);
        verifyNever(loggerMock.e(any));
        expect(result, true);
      });
      test("Correct registration - google", () async {
        when(authServiceMock.signInWithGoogle())
            .thenAnswer((_) => Future.value(userCredential));
        when(userCredential.user).thenReturn(user);
        when(userServiceMock.getUser())
            .thenAnswer((_) => Future.value(ktkUser));

        final result = await repository.register(AuthenticationMethod.google);

        verifyInOrder([
          authServiceMock.signInWithGoogle(),
          dataloaderServiceMock.loadStaticData(),
          userServiceMock.getUser(),
        ]);
        verifyNever(loggerMock.e(any));
        expect(result, true);
      });

      test("Incorrect registration - ktkUser credential null", () async {
        when(authServiceMock.signInAnonymously())
            .thenAnswer((_) => Future.value());

        final result =
            await repository.register(AuthenticationMethod.anonymous);

        verifyInOrder([authServiceMock.signInAnonymously()]);
        verifyNever(dataloaderServiceMock.loadStaticData());
        verifyNever(userServiceMock.getUser());
        expect(result, false);
      });

      test("Incorrect registration - ktkUser null", () async {
        when(authServiceMock.signInAnonymously())
            .thenAnswer((_) => Future.value(userCredential));
        when(userCredential.user).thenReturn(user);
        when(userServiceMock.getUser()).thenAnswer((_) => Future.value());

        final result =
            await repository.register(AuthenticationMethod.anonymous);

        verifyInOrder([
          authServiceMock.signInAnonymously(),
          dataloaderServiceMock.loadStaticData(),
          userServiceMock.getUser()
        ]);
        expect(result, false);
      });
    });

    group("updateSelf", () {
      const userPatch = ApiUser();
      test("Ok", () async {
        when(userServiceMock.updateUser(userPatch))
            .thenAnswer((_) => Future.value(ktkUser));

        final result = await repository.updateSelf(userPatch);

        verifyInOrder([userServiceMock.updateUser(userPatch)]);
        expect(result, ktkUser);
      });
      test("Nok", () async {
        when(userServiceMock.updateUser(userPatch))
            .thenAnswer((_) => Future.value());

        final result = await repository.updateSelf(userPatch);

        verifyInOrder([userServiceMock.updateUser(userPatch)]);
        expect(result, null);
      });
    });

    group("linkAccount", () {
      test("Correct link - apple", () async {
        when(authServiceMock.linkAccountWithApple())
            .thenAnswer((_) => Future.value(userCredential));
        when(userCredential.user).thenReturn(user);

        final result = await repository.linkAccount(AuthenticationMethod.apple);

        verifyInOrder([
          authServiceMock.linkAccountWithApple(),
        ]);
        verifyNever(loggerMock.e(any));
        expect(result, true);
      });
      test("Correct link - classic", () async {
        when(
          authServiceMock.linkAccountWithEmail("toto", "tata"),
        ).thenAnswer((_) => Future.value(userCredential));
        when(userCredential.user).thenReturn(user);

        final result = await repository.linkAccount(
            AuthenticationMethod.classic,
            email: "toto",
            password: "tata");

        verifyInOrder([
          authServiceMock.linkAccountWithEmail("toto", "tata"),
        ]);
        verifyNever(loggerMock.e(any));
        expect(result, true);
      });
      test("Correct link - google", () async {
        when(authServiceMock.linkAccountWithGoogle())
            .thenAnswer((_) => Future.value(userCredential));
        when(userCredential.user).thenReturn(user);

        final result =
            await repository.linkAccount(AuthenticationMethod.google);

        verifyInOrder([
          authServiceMock.linkAccountWithGoogle(),
        ]);
        verifyNever(loggerMock.e(any));
        expect(result, true);
      });

      test("Incorrect link - ktkUser credential null", () async {
        when(authServiceMock.linkAccountWithGoogle())
            .thenAnswer((_) => Future.value());

        final result =
            await repository.linkAccount(AuthenticationMethod.google);

        verifyInOrder([authServiceMock.linkAccountWithGoogle()]);
        expect(result, false);
      });
    });
  });
}
