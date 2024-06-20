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
      final Map<String, dynamic> userPatch = {};
      test("User logged in - without display name change", () async {
        when(userServiceMock.getUser())
            .thenAnswer((_) => Future.value(ktkUser));
        when(userServiceMock.updateUser(userPatch))
            .thenAnswer((_) => Future.value(true));

        await repository.signIn();

        await repository.updateSelf(ktkUser, userPatch);

        verifyInOrder([userServiceMock.updateUser(userPatch)]);
      });
      test("User logged in - with display name change", () async {
        final userPatchWithDisplayName = {"display_name": " TOTO"};
        when(userServiceMock.getUser())
            .thenAnswer((_) => Future.value(ktkUser));
        when(userServiceMock.updateUser(userPatchWithDisplayName))
            .thenAnswer((_) => Future.value(true));

        await repository.signIn();

        await repository.updateSelf(ktkUser, userPatchWithDisplayName);

        verifyInOrder([
          tokenServiceMock.userCredential,
          userServiceMock.updateUser(userPatchWithDisplayName)
        ]);
      });
      test("No user logged in", () async {
        await repository.signOut();

        await repository.updateSelf(ktkUser, userPatch);

        verifyInOrder([]);
      });
    });

    group("linkAccount", () {
      test("Correct link - apple", () async {
        when(userServiceMock.getUser())
            .thenAnswer((_) => Future.value(ktkUser));
        await repository.signIn();

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
        when(userServiceMock.getUser())
            .thenAnswer((_) => Future.value(ktkUser));
        await repository.signIn();

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
        when(userServiceMock.getUser())
            .thenAnswer((_) => Future.value(ktkUser));
        await repository.signIn();

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
        when(userServiceMock.getUser())
            .thenAnswer((_) => Future.value(ktkUser));
        await repository.signIn();

        when(authServiceMock.linkAccountWithGoogle())
            .thenAnswer((_) => Future.value());

        final result =
            await repository.linkAccount(AuthenticationMethod.google);

        verifyInOrder([authServiceMock.linkAccountWithGoogle()]);
        expect(result, false);
      });
    });

    group("deleteUser", () {
      test("successful", () async {
        when(userServiceMock.deleteUser())
            .thenAnswer((_) => Future.value(true));
        await repository.signIn();

        when(authServiceMock.linkAccountWithApple())
            .thenAnswer((_) => Future.value(userCredential));
        when(userCredential.user).thenReturn(user);

        final result = await repository.deleteUser();

        verifyInOrder([
          userServiceMock.deleteUser(),
          dataloaderServiceMock.deleteStaticData(),
        ]);
        expect(result, true);
      });
      test("failed", () async {
        when(userServiceMock.deleteUser())
            .thenAnswer((_) => Future.value(false));
        await repository.signIn();

        when(authServiceMock.linkAccountWithApple())
            .thenAnswer((_) => Future.value(userCredential));
        when(userCredential.user).thenReturn(user);

        final result = await repository.deleteUser();

        verifyInOrder([
          userServiceMock.deleteUser(),
        ]);
        verifyNever(dataloaderServiceMock.deleteStaticData());
        expect(result, false);
      });
    });
  });
}
