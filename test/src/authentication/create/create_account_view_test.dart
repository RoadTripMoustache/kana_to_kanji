import "package:flutter/foundation.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/authentication/create/create_account_view.dart";
import "package:kana_to_kanji/src/authentication/widgets/input_email.dart";
import "package:kana_to_kanji/src/authentication/widgets/input_password.dart";
import "package:kana_to_kanji/src/authentication/widgets/third_party_round_icon_button.dart";

import "../../../helpers.dart";

void main() {
  group("CreateAccountView", () {
    group("Default display", () {
      testWidgets("IOS", (WidgetTester tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        await tester.pumpLocalizedRouterWidget(const CreateAccountView(),
            initialLocation: CreateAccountView.routeName,
            allowedRoutes: [],
            allowedRoutesChild: const CreateAccountView());
        await tester.pumpAndSettle();

        final returnButton =
            find.byKey(const Key("create_account_view_return"));
        expect(returnButton, findsOneWidget);

        final emailInput = find.byType(InputEmail);
        expect(emailInput, findsOneWidget);

        final passwordInputs = find.byType(InputPassword);
        expect(passwordInputs, findsNWidgets(2));

        final createAccountButton =
            find.byKey(const Key("create_account_view_create_account_button"));
        expect(createAccountButton, findsOneWidget);

        final logoButtons = find.byType(ThirdPartyRoundIconButton);
        expect(logoButtons, findsNWidgets(2));

        debugDefaultTargetPlatformOverride = null;
      });

      testWidgets("Android", (WidgetTester tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        await tester.pumpLocalizedRouterWidget(const CreateAccountView(),
            initialLocation: CreateAccountView.routeName,
            allowedRoutes: [],
            allowedRoutesChild: const CreateAccountView());
        await tester.pumpAndSettle();

        final returnButton =
            find.byKey(const Key("create_account_view_return"));
        expect(returnButton, findsOneWidget);

        final emailInput = find.byType(InputEmail);
        expect(emailInput, findsOneWidget);

        final passwordInputs = find.byType(InputPassword);
        expect(passwordInputs, findsNWidgets(2));

        final createAccountButton =
            find.byKey(const Key("create_account_view_create_account_button"));
        expect(createAccountButton, findsOneWidget);

        final logoButton = find.byType(ThirdPartyRoundIconButton);
        expect(logoButton, findsNWidgets(1));
        debugDefaultTargetPlatformOverride = null;
      });
    });

    group("Form validations", () {
      testWidgets("Email invalid format", (WidgetTester tester) async {
        await tester.pumpLocalizedRouterWidget(const CreateAccountView(),
            initialLocation: CreateAccountView.routeName,
            allowedRoutes: [],
            allowedRoutesChild: const CreateAccountView());
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(InputEmail), "invalid");

        // Pump 300ms for the validation to be triggered
        await tester.pump(const Duration(milliseconds: 300));

        // Check the error message
        final emailErrorFinder = find.text("Email invalid format");
        expect(emailErrorFinder, findsOneWidget);
      });

      testWidgets("Passwords mismatch", (WidgetTester tester) async {
        await tester.pumpLocalizedRouterWidget(const CreateAccountView(),
            initialLocation: CreateAccountView.routeName,
            allowedRoutes: [],
            allowedRoutesChild: const CreateAccountView());
        await tester.pumpAndSettle();

        final passwordInput = find.byType(InputPassword).first;
        await tester.enterText(passwordInput, "toto");
        final passwordConfirmationInput = find.byType(InputPassword).last;
        await tester.enterText(passwordConfirmationInput, "titi");

        // Pump 300ms for the validation to be triggered
        await tester.pump(const Duration(milliseconds: 300));

        // Check the error message
        final passwordErrorFinder =
            find.text("Both passwords should be identical");
        expect(passwordErrorFinder, findsOneWidget);
      });

      testWidgets("Correct email/password", (WidgetTester tester) async {
        await tester.pumpLocalizedRouterWidget(const CreateAccountView(),
            initialLocation: CreateAccountView.routeName,
            allowedRoutes: [],
            allowedRoutesChild: const CreateAccountView());
        await tester.pumpAndSettle();

        final emailInput = find.byType(InputEmail);
        await tester.enterText(emailInput, "toto@toto.com");
        final passwordInput = find.byType(InputPassword).first;
        await tester.enterText(passwordInput, "toto");
        final passwordConfirmationInput = find.byType(InputPassword).last;
        await tester.enterText(passwordConfirmationInput, "toto");

        // Pump 300ms for the validation to be triggered
        await tester.pump(const Duration(milliseconds: 300));

        // Click on the create account button
        final createAccountButton =
            find.byKey(const Key("create_account_view_create_account_button"));
        await tester.tap(createAccountButton);

        await tester.pump(const Duration(milliseconds: 100));

        // No error message should be displayed
        final emailRequiredErrorFinder = find.text("Email is required");
        expect(emailRequiredErrorFinder, findsNothing);

        final emailInvalidFormatErrorFinder = find.text("Email invalid format");
        expect(emailInvalidFormatErrorFinder, findsNothing);

        final passwordRequiredErrorFinder = find.text("Password is required");
        expect(passwordRequiredErrorFinder, findsNothing);

        final passwordConfirmationRequiredErrorFinder =
            find.text("Password confirmation is required");
        expect(passwordConfirmationRequiredErrorFinder, findsNothing);

        final passwordsMismatchErrorFinder =
            find.text("Password confirmation is different from the password");
        expect(passwordsMismatchErrorFinder, findsNothing);
      });
    });
  });
}
