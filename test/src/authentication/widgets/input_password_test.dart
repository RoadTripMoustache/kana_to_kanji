import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/authentication/widgets/input_password.dart";

import "../../../helpers.dart";

void main() {
  group("InputPassword", () {
    late final AppLocalizations l10n;
    TextEditingController? controller;

    setUpAll(() async {
      l10n = await setupLocalizations();
    });

    setUp(() {
      controller = TextEditingController();
    });

    tearDown(() {
      controller?.dispose();
    });

    testWidgets(
      "It should have a TextFormField, obscured text, and an IconButton",
      (WidgetTester tester) async {
        await tester.pumpLocalizedWidget(
          InputPassword(
            controller: controller!,
            validate: (String? value) => null,
          ),
        );
        await tester.pumpAndSettle();

        expect(
          tester.widget<TextFormField>(find.byType(TextFormField)).controller,
          same(controller),
        );

        // Extract the TextField inside the TextFormField.
        final textField = tester.widget<TextField>(find.byType(TextField));

        // Validate hints, hint text, keyboard action
        expect(textField.autofillHints, containsAll([AutofillHints.password]));
        expect(textField.decoration?.hintText, l10n.input_password_placeholder);
        expect(
          textField.textInputAction,
          TextInputAction.done,
          reason: "By default, the TextInputAction should be 'done'",
        );

        // Validate icon and text is obscured.
        expect(textField.obscureText, isTrue);
        expect(
          textField.decoration?.suffixIcon,
          isA<IconButton>(),
          reason: "At the end of the input, we should have an IconButton",
        );
        expect(find.byType(IconButton), findsOneWidget);
        expect(
          find.widgetWithIcon(IconButton, Icons.visibility_rounded),
          findsOneWidget,
          reason: "If the text is obscured, should be visibility_rounded",
        );
      },
    );

    testWidgets(
      "It should obscure and reveal the password when IconButton is tapped",
      (WidgetTester tester) async {
        await tester.pumpLocalizedWidget(
          InputPassword(
            controller: controller!,
            validate: (String? value) => null,
          ),
        );
        await tester.pumpAndSettle();

        // Extract the TextField inside the TextFormField.
        final textField = tester.widget<TextField>(find.byType(TextField));

        // Validate icon and text is obscured.
        expect(textField.obscureText, isTrue);
        expect(
          find.widgetWithIcon(IconButton, Icons.visibility_rounded),
          findsOneWidget,
          reason: "If the text is obscured, should be visibility_rounded",
        );

        await tester.tap(find.byType(IconButton));
        await tester.pump();

        // Validate the text is now visible and the icon changed
        expect(
          tester.widget<TextField>(find.byType(TextField)).obscureText,
          isFalse,
        );
        expect(
          find.widgetWithIcon(IconButton, Icons.visibility_off_rounded),
          findsOneWidget,
          reason:
              "If the text is not obscured, should be visibility_off_rounded",
        );

        await tester.tap(find.byType(IconButton));
        await tester.pump();

        // Validate the text and icon are back to the default settings
        expect(
          tester.widget<TextField>(find.byType(TextField)).obscureText,
          isTrue,
        );
        expect(
          find.widgetWithIcon(IconButton, Icons.visibility_rounded),
          findsOneWidget,
          reason: "If the text is obscured, should be visibility_rounded",
        );
      },
    );

    group("Validation", () {
      testWidgets("It should validate the password and call onChange", (
        WidgetTester tester,
      ) async {
        int onChangeCalled = 0;
        await tester.pumpLocalizedWidget(
          InputPassword(
            controller: controller!,
            onChange: () => onChangeCalled++,
            validate: (String? value) => null,
          ),
        );
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextFormField), "password");
        // Pump the timer before validation is triggered
        await tester.pump(const Duration(milliseconds: 300));

        expect(
          find.text(l10n.input_password_msg_missing_password),
          findsNothing,
        );
        expect(onChangeCalled, 1);
      });

      testWidgets("It should validate isn't empty and call onChange", (
        WidgetTester tester,
      ) async {
        int onChangeCalled = 0;
        await tester.pumpLocalizedWidget(
          InputPassword(
            controller: controller!,
            onChange: () => onChangeCalled++,
            validate: (String? value) => null,
          ),
        );
        await tester.pumpAndSettle();

        // We inject a value then remove it.
        await tester.enterText(find.byType(TextFormField), "0");
        await tester.enterText(find.byType(TextFormField), "");
        // Pump the timer before validation is triggered
        await tester.pump(const Duration(milliseconds: 300));

        expect(
          find.text(l10n.input_password_msg_missing_password),
          findsOneWidget,
        );
        expect(onChangeCalled, 1);
      });

      testWidgets("It should not validate if isRequired is false", (
        WidgetTester tester,
      ) async {
        int onChangeCalled = 0;
        await tester.pumpLocalizedWidget(
          InputPassword(
            controller: controller!,
            isRequired: false,
            onChange: () => onChangeCalled++,
            validate: (String? value) => null,
          ),
        );
        await tester.pumpAndSettle();

        // We inject a value then remove it.
        await tester.enterText(find.byType(TextFormField), "0");
        await tester.enterText(find.byType(TextFormField), "");
        // Pump the timer before validation is triggered
        await tester.pump(const Duration(milliseconds: 300));

        expect(
          find.text(l10n.input_password_msg_missing_password),
          findsNothing,
        );
        expect(onChangeCalled, 1);
      });
    });
  });
}
