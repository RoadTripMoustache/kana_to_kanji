import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/glossary/details/widgets/section_title.dart";

import "../../../../helpers.dart";

void main() {
  group("SectionTitle", () {
    testWidgets("Should display title with correct style", (
      WidgetTester tester,
    ) async {
      const title = "Test Section Title";
      final customStyle = TextStyle(
        fontSize: 24,
        color: Colors.red,
        fontWeight: FontWeight.bold,
      );

      await tester.pumpLocalizedWidget(
        SectionTitle(title: title, style: customStyle),
      );
      await tester.pumpAndSettle();

      // Verify title is displayed
      expect(find.text(title), findsOneWidget);

      // Verify title has the correct style
      final titleWidget = tester.widget<Text>(find.text(title));
      expect(titleWidget.style, equals(customStyle));
    });

    testWidgets("Should use theme's titleLarge style when no style provided", (
      WidgetTester tester,
    ) async {
      const title = "Test Section Title";

      await tester.pumpLocalizedWidget(const SectionTitle(title: title));
      await tester.pumpAndSettle();

      // Get the theme from the widget
      final theme = Theme.of(tester.element(find.byType(SectionTitle)));

      // Verify title has the theme's titleLarge style
      final titleWidget = tester.widget<Text>(find.text(title));
      expect(titleWidget.style, equals(theme.textTheme.titleLarge));
    });

    testWidgets("Should display divider", (WidgetTester tester) async {
      const title = "Test Section Title";

      await tester.pumpLocalizedWidget(const SectionTitle(title: title));
      await tester.pumpAndSettle();

      // Verify divider is displayed
      expect(find.byType(Divider), findsOneWidget);

      // Verify divider properties
      final divider = tester.widget<Divider>(find.byType(Divider));
      expect(divider.height, equals(0));
      expect(divider.endIndent, equals(100));
    });
  });
}
