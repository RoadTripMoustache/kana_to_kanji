import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/src/core/repositories/user_repository.dart";
import "package:kana_to_kanji/src/core/widgets/stat_cards/stat_cards.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:kana_to_kanji/src/profile/update_avatar/view.dart";
import "package:kana_to_kanji/src/profile/view.dart";
import "package:kana_to_kanji/src/profile/widgets/avatar.dart";
import "package:kana_to_kanji/src/settings/settings_view.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

import "../../dummies/user.dart";
import "../../helpers.dart";
@GenerateNiceMocks([MockSpec<UserRepository>(), MockSpec<GoRouter>()])
import "view_test.mocks.dart";

void main() {
  group("ProfileView", () {
    late final MockUserRepository mockRepository = MockUserRepository();

    setUpAll(() {
      locator.registerSingleton<UserRepository>(mockRepository);
    });

    setUp(() {
      // Set up the mock repository to return a dummy user
      when(mockRepository.self).thenReturn(dummyUser);
    });

    tearDownAll(() async {
      await unregister<UserRepository>();
    });

    testWidgets("displays user information", (WidgetTester tester) async {
      // Arrange
      await tester.pumpLocalizedRouterWidget(const ProfileView());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Avatar), findsOneWidget);
      expect(find.text("Test User"), findsOneWidget);
      expect(find.byType(StreakStatCard), findsOneWidget);
      expect(find.byType(WordsStatCard), findsOneWidget);
    });

    testWidgets("displays 'Anonymous' when display name is empty", (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockRepository.self).thenReturn(dummyUserWithEmptyName);

      await tester.pumpLocalizedRouterWidget(const ProfileView());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text("Anonymous"), findsOneWidget);
    });

    testWidgets("navigates to settings when settings button is tapped", (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpLocalizedRouterWidget(
        const ProfileView(),
        allowedRoutes: [SettingsView.routeName],
      );
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.byIcon(Icons.settings_rounded));
      await tester.pumpAndSettle();

      expect(
        find.byKey(Key(getRouterKey(SettingsView.routeName))),
        findsOneWidget,
      );
    });

    testWidgets("navigates to update avatar when avatar is tapped", (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpLocalizedRouterWidget(
        const ProfileView(),
        allowedRoutes: [UpdateAvatarView.routeName],
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Avatar));
      await tester.pumpAndSettle();

      expect(
        find.byKey(Key(getRouterKey(UpdateAvatarView.routeName))),
        findsOneWidget,
      );
    });
  });
}
