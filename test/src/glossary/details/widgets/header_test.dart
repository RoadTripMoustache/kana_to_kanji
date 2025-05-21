import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/widgets/drag_handle.dart";
import "package:kana_to_kanji/src/glossary/details/widgets/header.dart";

import "../../../../helpers.dart";

void main() {
  group("Header", () {
    int onSpeakerPressedCallCount = 0;

    Future<void> mockOnSpeakerPressed() async {
      onSpeakerPressedCallCount++;
    }

    setUp(() {
      onSpeakerPressedCallCount = 0;
    });

    testWidgets("Should display title with correct style", (
      WidgetTester tester,
    ) async {
      const title = "Test Title";
      final customStyle = TextStyle(
        fontSize: 24,
        color: Colors.red,
        fontWeight: FontWeight.bold,
      );

      await tester.pumpLocalizedWidget(
        Header(title: title, textStyle: customStyle),
      );
      await tester.pumpAndSettle();

      // Verify title is displayed
      expect(find.text(title), findsOneWidget);

      // Verify title has the correct style
      final titleWidget = tester.widget<Text>(find.text(title));
      expect(titleWidget.style, equals(customStyle));
    });

    testWidgets(
      "Should use theme's displayMedium style when no style provided",
      (WidgetTester tester) async {
        const title = "Test Title";

        await tester.pumpLocalizedWidget(const Header(title: title));
        await tester.pumpAndSettle();

        // Get the theme from the widget
        final theme = Theme.of(tester.element(find.byType(Header)));

        // Verify title has the theme's displayMedium style
        final titleWidget = tester.widget<Text>(find.text(title));
        expect(titleWidget.style, equals(theme.textTheme.displayMedium));
      },
    );

    testWidgets("Should display subtitle when provided", (
      WidgetTester tester,
    ) async {
      const title = "Test Title";
      const subtitle = "Test Subtitle";

      await tester.pumpLocalizedWidget(
        const Header(title: title, subtitle: subtitle),
      );
      await tester.pumpAndSettle();

      // Verify subtitle is displayed
      expect(find.text(subtitle), findsOneWidget);

      // Get the theme from the widget
      final theme = Theme.of(tester.element(find.byType(Header)));

      // Verify subtitle has the theme's titleLarge style
      final subtitleWidget = tester.widget<Text>(find.text(subtitle));
      expect(subtitleWidget.style, equals(theme.textTheme.titleLarge));
    });

    testWidgets("Should not display subtitle when not provided", (
      WidgetTester tester,
    ) async {
      const title = "Test Title";

      await tester.pumpLocalizedWidget(const Header(title: title));
      await tester.pumpAndSettle();

      // Verify no subtitle is displayed
      expect(find.text("Test Subtitle"), findsNothing);
    });

    testWidgets("Should not display subtitle when empty", (
      WidgetTester tester,
    ) async {
      const title = "Test Title";
      const emptySubtitle = "";

      await tester.pumpLocalizedWidget(
        const Header(title: title, subtitle: emptySubtitle),
      );
      await tester.pumpAndSettle();

      // Verify no subtitle is displayed (no Text widget with empty string)
      final textWidgets = tester.widgetList<Text>(find.byType(Text));
      for (final widget in textWidgets) {
        expect(widget.data, isNot(equals("")));
      }
    });

    testWidgets(
      "Should display speaker button when onSpeakerPressed provided",
      (WidgetTester tester) async {
        const title = "Test Title";

        await tester.pumpLocalizedWidget(
          Header(title: title, onSpeakerPressed: mockOnSpeakerPressed),
        );
        await tester.pumpAndSettle();

        // Verify speaker button is displayed
        expect(find.byIcon(Icons.volume_up_rounded), findsOneWidget);
      },
    );

    testWidgets(
      "Should not display speaker button when onSpeakerPressed not provided",
      (WidgetTester tester) async {
        const title = "Test Title";

        await tester.pumpLocalizedWidget(const Header(title: title));
        await tester.pumpAndSettle();

        // Verify speaker button is not displayed
        expect(find.byIcon(Icons.volume_up_rounded), findsNothing);
      },
    );

    testWidgets("Should call onSpeakerPressed when speaker button is pressed", (
      WidgetTester tester,
    ) async {
      const title = "Test Title";

      await tester.pumpLocalizedWidget(
        Header(title: title, onSpeakerPressed: mockOnSpeakerPressed),
      );
      await tester.pumpAndSettle();

      // Tap the speaker button
      await tester.tap(find.byIcon(Icons.volume_up_rounded));
      await tester.pumpAndSettle();

      // Verify onSpeakerPressed was called
      expect(onSpeakerPressedCallCount, 1);
    });

    testWidgets("Should display drag handle", (WidgetTester tester) async {
      const title = "Test Title";

      await tester.pumpLocalizedWidget(const Header(title: title));
      await tester.pumpAndSettle();

      // Verify drag handle is displayed
      expect(find.byType(DragHandle), findsOneWidget);
    });
  });
}
