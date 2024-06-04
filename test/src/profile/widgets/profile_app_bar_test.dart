import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/src/profile/widgets/profile_app_bar.dart";
import "package:kana_to_kanji/src/settings/settings_view.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

import "../../../helpers.dart";

@GenerateNiceMocks([
  MockSpec<GoRouter>(),
])
import "profile_app_bar_test.mocks.dart";

void main() {
  group("ProfileAppBar", () {
    final gorouter = MockGoRouter();
    testWidgets("UI", (WidgetTester tester) async {
      final Widget widget = ProfileAppBar(router: gorouter);

      await tester.pumpLocalizedWidget(widget);
      await tester.pumpAndSettle();

      expect(find.byType(IconButton), findsNWidgets(1));
      verifyNever(gorouter.push(SettingsView.routeName));
    });
    testWidgets("tap setting button", (WidgetTester tester) async {
      final Widget widget = ProfileAppBar(router: gorouter);

      await tester.pumpLocalizedWidget(widget);
      await tester.pumpAndSettle();

      expect(find.byType(IconButton), findsNWidgets(1));

      await tester.tap(find.byType(IconButton));

      verify(gorouter.push(SettingsView.routeName)).called(1);
    });
  });
}
