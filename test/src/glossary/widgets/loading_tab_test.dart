import "package:flutter/material.dart";
import "package:flutter_rtm/flutter_rtm.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/glossary/widgets/loading_tab.dart";

import "../../../helpers.dart";

void main() {
  group("LoadingTab", () {
    testWidgets("Should display spinner when data is not ready", (
      WidgetTester tester,
    ) async {
      const testChild = Text("Test Child");

      await tester.pumpLocalizedWidget(
        const LoadingTab(isDataReady: false, child: testChild),
      );
      // Pumping a single frame as the spinner is animated and settle time out
      await tester.pump();

      // Verify the spinner is displayed
      expect(find.byType(RTMSpinner), findsOneWidget);

      // Verify the child is not displayed
      expect(find.text("Test Child"), findsNothing);
    });

    testWidgets("Should display child when data is ready", (
      WidgetTester tester,
    ) async {
      const testChild = Text("Test Child");

      await tester.pumpLocalizedWidget(
        const LoadingTab(isDataReady: true, child: testChild),
      );
      await tester.pumpAndSettle();

      // Verify the child is displayed
      expect(find.text("Test Child"), findsOneWidget);

      // Verify the spinner is not displayed
      expect(find.byType(RTMSpinner), findsNothing);
    });
  });
}
