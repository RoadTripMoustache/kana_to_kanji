import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/glossary/widgets/badge_icon.dart";

import "../../../helpers.dart";

void main() {
  group("BadgeIcon", () {
    testWidgets("Should display the icon", (WidgetTester tester) async {
      const testIcon = Icon(Icons.search);

      await tester.pumpLocalizedWidget(const BadgeIcon(icon: testIcon));
      await tester.pumpAndSettle();

      // Verify the icon is displayed
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets("Should not show badge when showBadge is false", (
      WidgetTester tester,
    ) async {
      const testIcon = Icon(Icons.search);

      await tester.pumpLocalizedWidget(const BadgeIcon(icon: testIcon));
      await tester.pumpAndSettle();

      // Find the Badge widget
      final badge = tester.widget<Badge>(find.byType(Badge));

      // Verify the badge is not visible
      expect(badge.isLabelVisible, isFalse);
    });

    testWidgets("Should show badge when showBadge is true", (
      WidgetTester tester,
    ) async {
      const testIcon = Icon(Icons.search);

      await tester.pumpLocalizedWidget(
        const BadgeIcon(icon: testIcon, showBadge: true),
      );
      await tester.pumpAndSettle();

      // Find the Badge widget
      final badge = tester.widget<Badge>(find.byType(Badge));

      // Verify the badge is visible
      expect(badge.isLabelVisible, isTrue);
    });

    testWidgets("Should have deep orange background color", (
      WidgetTester tester,
    ) async {
      const testIcon = Icon(Icons.search);

      await tester.pumpLocalizedWidget(
        const BadgeIcon(icon: testIcon, showBadge: true),
      );
      await tester.pumpAndSettle();

      // Find the Badge widget
      final badge = tester.widget<Badge>(find.byType(Badge));

      // Verify the badge background color
      expect(badge.backgroundColor, equals(Colors.deepOrange));
    });
  });
}
