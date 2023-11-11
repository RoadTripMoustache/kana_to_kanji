import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kana_to_kanji/src/core/widgets/arc_progress_indicator.dart';

import '../../../helpers.dart';

void main() {
  group("ArcProgressIndicator", () {
    group("UI", () {
      testWidgets("Default", (WidgetTester tester) async {
        final l10n = await setupLocalizations();
        const value = 0.0;

        await tester.pumpLocalizedWidget(const ArcProgressIndicator(
          value: value,
        ));
        await tester.pumpAndSettle();

        final widget = find.byType(ArcProgressIndicator);

        expect(widget, findsOneWidget);
        expect(
            find.descendant(
                of: widget, matching: find.text(l10n.percent(value))),
            findsOneWidget);
      });

      testWidgets("Hiding the percentage", (WidgetTester tester) async {
        final l10n = await setupLocalizations();
        const value = 0.0;

        await tester.pumpLocalizedWidget(const ArcProgressIndicator(
          value: value,
          showPercentage: false,
        ));
        await tester.pumpAndSettle();

        final widget = find.byType(ArcProgressIndicator);

        expect(widget, findsOneWidget);
        expect(
            find.descendant(
                of: widget, matching: find.text(l10n.percent(value))),
            findsNothing);
      });

      testWidgets("Custom radius", (WidgetTester tester) async {
        const double customRadius = 300.0;
        await tester.pumpLocalizedWidget(const ArcProgressIndicator(
          value: 0.0,
          radius: customRadius,
        ));
        await tester.pumpAndSettle();

        final widget = find.byType(ArcProgressIndicator);
        final container = find.descendant(
            of: widget,
            matching: find.byWidgetPredicate((Widget widget) {
              if (widget is Container) {
                BoxConstraints? constraints = widget.constraints;

                if (constraints != null &&
                    constraints.minWidth == customRadius &&
                    constraints.minHeight == customRadius) {
                  return true;
                }
              }
              return false;
            }));

        expect(container, findsOneWidget);
      });
    });

    group("Interactions", () {
      testWidgets(
          "Should switch to alternativeText when central text is tapped",
          (WidgetTester tester) async {
        const double value = 0.5;
        const String alternativeText = "Test";

        final l10n = await setupLocalizations();

        await tester.pumpLocalizedWidget(const ArcProgressIndicator(
            value: value, alternativeText: alternativeText));
        await tester.pumpAndSettle();

        final widget = find.byType(ArcProgressIndicator);

        final defaultText = find.text(l10n.percent(value));
        expect(
            find.descendant(of: widget, matching: defaultText), findsOneWidget,
            reason: "The percent text should be displayed by default");
        expect(
            find.descendant(of: widget, matching: find.text(alternativeText)),
            findsNothing,
            reason: "The alternative text should not be displayed by default");

        // Tap on the central text to switch to alternative text
        await tester.tap(defaultText);
        await tester.pumpAndSettle();

        expect(
            find.descendant(
                of: widget, matching: find.text(l10n.percent(value))),
            findsNothing,
            reason:
                "The percent text shouldn't be displayed after a tapped when alternativeText is provided.");
        expect(
            find.descendant(of: widget, matching: find.text(alternativeText)),
            findsOneWidget,
            reason:
                "The alternative text should be displayed after first tap.");
      });

      testWidgets("Should not switch to alternativeText when it's not provided",
          (WidgetTester tester) async {
        const double value = 0.5;

        final l10n = await setupLocalizations();

        await tester
            .pumpLocalizedWidget(const ArcProgressIndicator(value: value));
        await tester.pumpAndSettle();

        final widget = find.byType(ArcProgressIndicator);

        final defaultText = find.text(l10n.percent(value));
        expect(
            find.descendant(of: widget, matching: defaultText), findsOneWidget,
            reason: "The percent text should be displayed by default");

        // Tap on the central text to switch to alternative text
        await tester.tap(defaultText);
        await tester.pumpAndSettle();

        expect(
            find.descendant(
                of: widget, matching: find.text(l10n.percent(value))),
            findsOneWidget,
            reason: "The tap shouldn't have changed the text value.");
      });
    });
  });
}
