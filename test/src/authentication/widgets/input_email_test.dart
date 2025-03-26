import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/l10n/app_localizations.dart";
import "package:kana_to_kanji/src/authentication/widgets/input_email.dart";

import "../../../helpers.dart";

void main() {
  group("InputEmail", () {
    late final AppLocalizations l10n;

    setUpAll(() async {
      l10n = await setupLocalizations();
    });

    testWidgets("It should have a TextFormField with right keyboard, autofill,"
        " and decoration", (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpLocalizedWidget(InputEmail(controller: controller));
      await tester.pumpAndSettle();

      expect(
        tester.widget<TextFormField>(find.byType(TextFormField)).controller,
        same(controller),
      );

      // Extract the TextField inside the TextFormField.
      final textField = tester.widget<TextField>(find.byType(TextField));

      // Validate hints, hint text, keyboard type and action
      expect(textField.autofillHints, containsAll([AutofillHints.email]));
      expect(textField.decoration?.hintText, l10n.input_email_placeholder);
      expect(textField.keyboardType, TextInputType.emailAddress);
      expect(textField.textInputAction, TextInputAction.none);

      // Tear down
      controller.dispose();
    });

    testWidgets("It should validate the email", (WidgetTester tester) async {
      final controller = TextEditingController();
      bool onChangedCalled = false;

      const testCases = [
        {
          "email": "valid@valid.com",
          "missing": findsNothing,
          "invalid": findsNothing,
        },
        {
          "email": "valid.valid@valid.com",
          "missing": findsNothing,
          "invalid": findsNothing,
        },
        {
          "email": "invalid",
          "missing": findsNothing,
          "invalid": findsOneWidget,
        },
        {
          "email": "inv@@asd.com",
          "missing": findsNothing,
          "invalid": findsOneWidget,
        },
        {
          "email": "inv@asd.c",
          "missing": findsNothing,
          "invalid": findsOneWidget,
        },
        {"email": "inv@.c", "missing": findsNothing, "invalid": findsOneWidget},
        {"email": "", "missing": findsOneWidget, "invalid": findsNothing},
      ];

      await tester.pumpLocalizedWidget(
        InputEmail(
          controller: controller,
          onChange: () => onChangedCalled = true,
        ),
      );

      await tester.pumpAndSettle();

      for (final Map<String, dynamic> testCase in testCases) {
        onChangedCalled = false;

        await tester.enterText(find.byType(TextFormField), testCase["email"]);
        await tester.pump(const Duration(milliseconds: 300));

        expect(controller.text, testCase["email"]);
        expect(find.text(l10n.input_email_missing_email), testCase["missing"]);
        expect(
          find.text(l10n.input_email_incorrect_email_format),
          testCase["invalid"],
        );

        expect(onChangedCalled, isTrue);
      }

      // Tear down
      controller.dispose();
    });
  });
}
