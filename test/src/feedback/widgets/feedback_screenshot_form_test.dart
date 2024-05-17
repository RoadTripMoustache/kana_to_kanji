import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/feedback/constants/feedback_type.dart";
import "package:kana_to_kanji/src/feedback/widgets/feedback_screenshot_form.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

import "../../../helpers.dart";
import "feedback_screenshot_form_test.mocks.dart";

@GenerateNiceMocks([MockSpec<Functions>(as: #MockFunction)])
// ignore: one_member_abstracts,unreachable_from_main
abstract class Functions {
  // ignore: unreachable_from_main
  Future<void> onSubmit(String text, {Map<String, dynamic>? extras});
}

void main() {
  group("FeedbackForm", () {
    late final AppLocalizations l10n;

    final MockFunction mock = MockFunction();

    setUpAll(() async {
      l10n = await setupLocalizations();
    });

    setUp(() {
      reset(mock);
    });

    Future<Finder> buildWidget(WidgetTester tester) async {
      await tester
          .pumpLocalizedWidget(FeedbackScreenshotForm(onSubmit: mock.onSubmit));
      await tester.pumpAndSettle();

      final widget = find.byType(FeedbackScreenshotForm);
      expect(widget, findsOneWidget);
      return widget;
    }

    group("UI", () {
      testWidgets("should have a submit button", (WidgetTester tester) async {
        final widget = await buildWidget(tester);

        // Check submit button
        expect(
            find.descendant(
                of: widget,
                matching: find.widgetWithText(
                    FilledButton, l10n.feedback_submit(FeedbackType.bug.name))),
            findsOneWidget,
            reason: "Submit button should have the report bug submit text");
      });
    });

    group("Interactions", () {
      group("Submit", () {
        testWidgets("should call onSubmit when button is enabled and tapped",
            (WidgetTester tester) async {
          final widget = await buildWidget(tester);
          final button = find.descendant(
              of: widget,
              matching: find.widgetWithText(
                  FilledButton, l10n.feedback_submit(FeedbackType.bug.name)));

          expect(tester.widget<FilledButton>(button).enabled, true,
              reason: "Submit button should be enabled");
          await tester.tap(button);

          verify(mock.onSubmit("")).called(1);
          verifyNoMoreInteractions(mock);
        });
      });
    });
  });
}
