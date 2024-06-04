import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/src/core/repositories/settings_repository.dart";
import "package:kana_to_kanji/src/core/repositories/user_repository.dart";
import "package:kana_to_kanji/src/core/services/token_service.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:kana_to_kanji/src/profile/profile_view_model.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

import "../../dummies/user.dart";
@GenerateNiceMocks([
  MockSpec<SettingsRepository>(),
  MockSpec<UserRepository>(),
  MockSpec<TokenService>(),
  MockSpec<GoRouter>()
])
import "profile_view_model_test.mocks.dart";

void main() async {
  group("ProfileViewModel", () {
    late ProfileViewModel viewModel;

    final settingsRepositoryMock = MockSettingsRepository();
    final userRepositoryMock = MockUserRepository();
    final tokenServiceMock = MockTokenService();
    final goRouterMock = MockGoRouter();

    setUpAll(() {
      locator
        ..registerSingleton<SettingsRepository>(settingsRepositoryMock)
        ..registerSingleton<TokenService>(tokenServiceMock)
        ..registerSingleton<UserRepository>(userRepositoryMock);
    });

    setUp(() {
      viewModel = ProfileViewModel(goRouterMock);
    });

    tearDown(() {
      reset(settingsRepositoryMock);
      reset(userRepositoryMock);
    });

    tearDownAll(() {
      locator
        ..unregister<SettingsRepository>(instance: settingsRepositoryMock)
        ..unregister<UserRepository>(instance: userRepositoryMock);
    });

    group("getUserName", () {
      test("User null", () {
        when(userRepositoryMock.self).thenReturn(null);

        expect(viewModel.getUserName(), "");
        verify(userRepositoryMock.self).called(1);
      });
      test("User not null", () {
        when(userRepositoryMock.self).thenReturn(dummyUser);

        expect(viewModel.getUserName(), dummyUser.displayName);
        verify(userRepositoryMock.self).called(2);
      });
    });

    group("getUserCreationDate", () {
      test("User null", () {
        when(userRepositoryMock.self).thenReturn(null);

        expect(viewModel.getUserCreationDate(), "");
        verify(userRepositoryMock.self).called(1);
        verifyNever(settingsRepositoryMock.locale);
      });
      test("User not null and language EN", () {
        when(userRepositoryMock.self).thenReturn(dummyUser);
        when(settingsRepositoryMock.locale).thenReturn(const Locale("en_US"));

        expect(viewModel.getUserCreationDate(), "January 2022");
        verify(userRepositoryMock.self).called(2);
        verify(settingsRepositoryMock.locale).called(1);
      });
    });
  });
}
