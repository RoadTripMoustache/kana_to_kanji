import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kana_to_kanji/src/feedback/constants/feedback_type.dart';
import 'package:kana_to_kanji/src/feedback/widgets/feedback_type_selection.dart';

import '../../../helpers.dart';

void main() {
  group("FeedbackTypeSelection", () {
    late final AppLocalizations l10n;

    setUpAll(() async {
      l10n = await setupLocalizations();
    });

    testWidgets("Should display bug and feature request buttons",
        (WidgetTester tester) async {
      await tester.pumpWidget(
          LocalizedWidget(child: FeedbackTypeSelection(onPressed: (_) {})));
      await tester.pumpAndSettle();

      final widget = find.byType(FeedbackTypeSelection);

      expect(widget, findsOneWidget);

      // Valid bug report button
      Finder button = find.descendant(
          of: widget,
          matching: find.byKey(FeedbackTypeSelection.reportBugButtonKey));
      expect(button, findsOneWidget);
      expect(
          find.descendant(
              of: button, matching: find.byIcon(Icons.bug_report_outlined)),
          findsOneWidget);
      expect(
          find.descendant(
              of: button, matching: find.text(l10n.feedback_report_bug)),
          findsOneWidget);
      expect(
          find.descendant(
              of: button,
              matching: find.text(l10n.feedback_report_bug_subtitle)),
          findsOneWidget);

      // Valid feature request button
      button = find.descendant(
          of: widget,
          matching: find.byKey(FeedbackTypeSelection.featureRequestButtonKey));
      expect(button, findsOneWidget);
      expect(
          find.descendant(
              of: button,
              matching: find.byIcon(Icons.design_services_outlined)),
          findsOneWidget);
      expect(
          find.descendant(
              of: button, matching: find.text(l10n.feedback_request_feature)),
          findsOneWidget);
      expect(
          find.descendant(
              of: button,
              matching: find.text(l10n.feedback_request_feature_subtitle)),
          findsOneWidget);
    });

    testWidgets(
        "Should call the onPressed function with the right FeedbackType",
        (WidgetTester tester) async {
      FeedbackType? typePassed;
      void onPressed(FeedbackType type) {
        typePassed = type;
      }

      await tester.pumpWidget(
          LocalizedWidget(child: FeedbackTypeSelection(onPressed: onPressed)));
      await tester.pumpAndSettle();

      final widget = find.byType(FeedbackTypeSelection);

      expect(widget, findsOneWidget);

      // Valid bug report button
      var button = find.descendant(
          of: widget,
          matching: find.byKey(FeedbackTypeSelection.reportBugButtonKey));
      expect(button, findsOneWidget);
      await tester.tap(button);
      expect(typePassed, FeedbackType.bug);

      typePassed = null;

      // Valid feature request button
      button = find.descendant(
          of: widget,
          matching: find.byKey(FeedbackTypeSelection.featureRequestButtonKey));
      expect(button, findsOneWidget);
      await tester.tap(button);
      expect(typePassed, FeedbackType.featureRequest);
    });
  });
}
