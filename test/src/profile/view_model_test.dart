import "package:flutter_test/flutter_test.dart";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/src/core/repositories/user_repository.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:kana_to_kanji/src/profile/update_avatar/view.dart";
import "package:kana_to_kanji/src/profile/view_model.dart";
import "package:kana_to_kanji/src/settings/settings_view.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

import "../../dummies/user.dart";
import "../../helpers.dart";
@GenerateNiceMocks([MockSpec<UserRepository>(), MockSpec<GoRouter>()])
import "view_model_test.mocks.dart";

void main() {
  group("ProfileViewModel", () {
    late final MockUserRepository mockRepository = MockUserRepository();
    late final MockGoRouter mockRouter = MockGoRouter();
    late ProfileViewModel viewModel;

    setUpAll(() {
      locator.registerSingleton<UserRepository>(mockRepository);
    });

    setUp(() {
      // Set up the mock repository to return a dummy user
      when(mockRepository.self).thenReturn(dummyUser);

      // Create the view model
      viewModel = ProfileViewModel(mockRouter);
    });

    tearDownAll(() async {
      await unregister<UserRepository>();
    });

    test("returns correct display name", () {
      expect(viewModel.displayName, equals("Test User"));
    });

    test("returns 'Anonymous' when display name is empty", () {
      when(mockRepository.self).thenReturn(dummyUserWithEmptyName);
      viewModel = ProfileViewModel(mockRouter);

      expect(viewModel.displayName, equals("Anonymous"));
    });

    test("returns correct learning since date", () {
      expect(
        viewModel.learningSince,
        equals(DateTime.parse("2023-01-01T00:00:00.000Z")),
      );
    });

    test("returns correct streak count", () {
      expect(viewModel.streakCount, equals(10));
    });

    test("returns correct words learned", () {
      expect(viewModel.wordsLearned, equals(0));
    });

    test("navigates to settings when goToSettings is called", () {
      viewModel.goToSettings();

      verify(mockRouter.push(SettingsView.routeName)).called(1);
    });

    test("navigates to update avatar when updateAvatar is called", () {
      viewModel.updateAvatar();

      verify(mockRouter.push(UpdateAvatarView.routeName)).called(1);
    });
  });
}
