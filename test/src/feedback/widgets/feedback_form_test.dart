import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kana_to_kanji/src/feedback/constants/feedback_form_fields.dart';
import 'package:kana_to_kanji/src/feedback/constants/feedback_type.dart';
import 'package:kana_to_kanji/src/feedback/widgets/feedback_form.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers.dart';

void main() {
  group("FeedbackForm", () {
    late final AppLocalizations l10n;

    MockFunction mock = MockFunction();

    setUpAll(() async {
      l10n = await setupLocalizations();
    });

    setUp(() {
      reset(mock);
    });

    Future<Finder> buildWidget(WidgetTester tester, FeedbackType type,
        [bool isSubmitEnabled = false]) async {
      await tester.pumpWidget(LocalizedWidget(
          child: FeedbackForm(
        feedbackType: type,
        onChange: mock.onChange,
        validator: mock.validator,
        onSubmit: mock.onSubmit,
        isSubmitEnabled: isSubmitEnabled,
      )));
      await tester.pumpAndSettle();

      final widget = find.byType(FeedbackForm);
      expect(widget, findsOneWidget);
      return widget;
    }

    group("UI", () {
      testWidgets(
          "should have 2 fields (email and description) and submit button",
          (WidgetTester tester) async {
        final widget = await buildWidget(tester, FeedbackType.featureRequest);

        // Check fields
        expect(
            find.descendant(of: widget, matching: find.byType(TextFormField)),
            findsNWidgets(2));
        expect(
            find.descendant(
                of: widget,
                matching:
                    find.widgetWithText(TextFormField, l10n.email_optional)),
            findsOneWidget,
            reason: "Email field with optional label should always be present");
        expect(
            find.descendant(
                of: widget,
                matching: find.widgetWithText(
                    TextFormField, l10n.feedback_description)),
            findsOneWidget,
            reason:
                "Description field with mandatory label should be present on feature request form");

        // Check submit button
        expect(
            find.descendant(
                of: widget,
                matching: find.widgetWithText(FilledButton,
                    l10n.feedback_submit(FeedbackType.featureRequest.name))),
            findsOneWidget,
            reason:
                "Submit button should have the feature request submit text");
      });

      testWidgets(
          "should have 'Steps to reproduce' text field when feedback type is bug report",
          (WidgetTester tester) async {
        final widget = await buildWidget(tester, FeedbackType.bug);

        // Check fields
        expect(
            find.descendant(of: widget, matching: find.byType(TextFormField)),
            findsNWidgets(3));
        expect(
            find.descendant(
                of: widget,
                matching:
                    find.widgetWithText(TextFormField, l10n.email_optional)),
            findsOneWidget,
            reason: "Email field with optional label should always be present");
        expect(
            find.descendant(
                of: widget,
                matching: find.widgetWithText(
                    TextFormField, l10n.feedback_description_optional)),
            findsOneWidget,
            reason:
                "Description field with optional label should be present on report bug form");
        expect(
            find.descendant(
                of: widget,
                matching: find.widgetWithText(
                    TextFormField, l10n.feedback_bug_steps)),
            findsOneWidget,
            reason:
                "On bug report the steps to reproduce field should be provided");
        expect(
            find.descendant(
                of: widget,
                matching: find.widgetWithText(
                    OutlinedButton, l10n.feedback_include_screenshot)),
            findsOneWidget,
            reason:
                "On bug report, the 'include screenshot button should be present");
      });
    });

    group("Fields", () {
      testWidgets("should call onChange and validator for email",
          (WidgetTester tester) async {
        final widget = await buildWidget(tester, FeedbackType.featureRequest);
        const email = "test@email.com";

        await tester.enterText(
            find.descendant(
                of: widget,
                matching:
                    find.widgetWithText(TextFormField, l10n.email_optional)),
            email);
        await tester.pump();

        verifyInOrder([
          mock.onChange(FeedbackFormFields.email, email),
          mock.validator(FeedbackFormFields.email, email)
        ]);
        verifyNoMoreInteractions(mock);
      });

      testWidgets("should call onChange and validator for description",
          (WidgetTester tester) async {
        final widget = await buildWidget(tester, FeedbackType.featureRequest);
        const description = "description";

        await tester.enterText(
            find.descendant(
                of: widget,
                matching: find.widgetWithText(
                    TextFormField, l10n.feedback_description)),
            description);
        await tester.pump();

        verifyInOrder([
          mock.onChange(FeedbackFormFields.description, description),
          mock.validator(FeedbackFormFields.description, description)
        ]);
        verifyNoMoreInteractions(mock);
      });

      testWidgets("should call onChange and validator for stepsToReproduce",
          (WidgetTester tester) async {
        final widget = await buildWidget(tester, FeedbackType.bug);
        const steps = "Steps to reproduce";

        await tester.enterText(
            find.descendant(
                of: widget,
                matching: find.widgetWithText(
                    TextFormField, l10n.feedback_bug_steps)),
            steps);
        await tester.pump();

        verifyInOrder([
          mock.onChange(FeedbackFormFields.stepsToReproduce, steps),
          mock.validator(FeedbackFormFields.stepsToReproduce, steps)
        ]);
        verifyNoMoreInteractions(mock);
      });
    });

    testWidgets(
        "should open BetterFeedback when 'Include screenshot' button with form data passed",
            (WidgetTester tester) async {});

    group("Submit", () {
      testWidgets(
          "submit button should be disabled when isSubmitEnabled is false",
          (WidgetTester tester) async {});

      testWidgets(
          "submit button should be enabled when isSubmitEnabled is true",
          (WidgetTester tester) async {});

      testWidgets("should call onSubmit when button is enabled and tapped",
          (WidgetTester tester) async {});
    });
  });
}

abstract class Functions {
  void onChange(FeedbackFormFields field, String value);

  String? validator(FeedbackFormFields field, String? value);

  Future<void> onSubmit();
}

class MockFunction extends Mock implements Functions {}
