import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/profile/widgets/link_account_banner.dart";

import "../../../helpers.dart";

void main() {
  group("LinkAccountBanner", () {
    testWidgets("UI", (WidgetTester tester) async {
      const Widget widget = LinkAccountBanner();

      await tester.pumpLocalizedRouterWidget(widget);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.warning_amber_rounded), findsNWidgets(1));
      expect(find.byIcon(Icons.person_add_alt_rounded), findsNWidgets(1));
      expect(find.text("Create account"), findsNWidgets(1));
      expect(find.text("Create an account to not loose your progression!"),
          findsNWidgets(1));
    });
  });
}
