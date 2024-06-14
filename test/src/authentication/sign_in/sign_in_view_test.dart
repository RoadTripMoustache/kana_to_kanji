import "package:flutter/foundation.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/authentication/sign_in/sign_in_view.dart";

import "../../../helpers.dart";

void main() {
  group("SignInView", () {
    group("Default display", () {
      testWidgets("IOS", (WidgetTester tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        await tester.pumpLocalizedRouterWidget(const SignInView(),
            initialLocation: SignInView.routeName,
            allowedRoutes: [],
            allowedRoutesChild: const SignInView());
        await tester.pumpAndSettle();

        final returnButton = find.byKey(const Key("sign_in_view_return"));
        expect(returnButton, findsOneWidget);

        final emailInput = find.byKey(const Key("email_input_widget"));
        expect(emailInput, findsOneWidget);

        final passwordInput = find.byKey(const Key("password_input_widget"));
        expect(passwordInput, findsOneWidget);

        final forgotPasswordLink =
            find.byKey(const Key("sign_in_view_forgot_password"));
        expect(forgotPasswordLink, findsOneWidget);

        final signInButton =
            find.byKey(const Key("sign_in_view_sign_in_button"));
        expect(signInButton, findsOneWidget);

        final logoButton = find.byKey(const Key("button_logo_widget"));
        expect(logoButton, findsNWidgets(2));

        debugDefaultTargetPlatformOverride = null;
      });

      testWidgets("Android", (WidgetTester tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        await tester.pumpLocalizedRouterWidget(const SignInView(),
            initialLocation: SignInView.routeName,
            allowedRoutes: [],
            allowedRoutesChild: const SignInView());
        await tester.pumpAndSettle();

        final returnButton = find.byKey(const Key("sign_in_view_return"));
        expect(returnButton, findsOneWidget);

        final emailInput = find.byKey(const Key("email_input_widget"));
        expect(emailInput, findsOneWidget);

        final passwordInput = find.byKey(const Key("password_input_widget"));
        expect(passwordInput, findsOneWidget);

        final forgotPasswordLink =
            find.byKey(const Key("sign_in_view_forgot_password"));
        expect(forgotPasswordLink, findsOneWidget);

        final signInButton =
            find.byKey(const Key("sign_in_view_sign_in_button"));
        expect(signInButton, findsOneWidget);

        final logoButton = find.byKey(const Key("button_logo_widget"));
        expect(logoButton, findsNWidgets(1));
        debugDefaultTargetPlatformOverride = null;
      });
    });

    group("Form validations", () {
      testWidgets("Empty email", (WidgetTester tester) async {
        await tester.pumpLocalizedRouterWidget(const SignInView(),
            initialLocation: SignInView.routeName,
            allowedRoutes: [],
            allowedRoutesChild: const SignInView());
        await tester.pumpAndSettle();

        final signInButton =
            find.byKey(const Key("sign_in_view_sign_in_button"));
        await tester.tap(signInButton);

        await tester.pump(const Duration(milliseconds: 100));

        final emailErrorFinder = find.text("Email is required");
        expect(emailErrorFinder, findsOneWidget);
      });

      testWidgets("Email invalid format", (WidgetTester tester) async {
        await tester.pumpLocalizedRouterWidget(const SignInView(),
            initialLocation: SignInView.routeName,
            allowedRoutes: [],
            allowedRoutesChild: const SignInView());
        await tester.pumpAndSettle();

        final emailInput = find.byKey(const Key("email_input_widget"));
        await tester.enterText(emailInput, "toto");

        final signInButton =
            find.byKey(const Key("sign_in_view_sign_in_button"));
        await tester.tap(signInButton);

        await tester.pump(const Duration(milliseconds: 100));

        final emailErrorFinder = find.text("Email invalid format");
        expect(emailErrorFinder, findsOneWidget);
      });

      testWidgets("Empty password", (WidgetTester tester) async {
        await tester.pumpLocalizedRouterWidget(const SignInView(),
            initialLocation: SignInView.routeName,
            allowedRoutes: [],
            allowedRoutesChild: const SignInView());
        await tester.pumpAndSettle();

        final signInButton =
            find.byKey(const Key("sign_in_view_sign_in_button"));
        await tester.tap(signInButton);

        await tester.pump(const Duration(milliseconds: 100));

        final passwordErrorFinder = find.text("Password is required");
        expect(passwordErrorFinder, findsOneWidget);
      });

      testWidgets("Correct email/password", (WidgetTester tester) async {
        await tester.pumpLocalizedRouterWidget(const SignInView(),
            initialLocation: SignInView.routeName,
            allowedRoutes: [],
            allowedRoutesChild: const SignInView());
        await tester.pumpAndSettle();

        final emailInput = find.byKey(const Key("email_input_widget"));
        await tester.enterText(emailInput, "toto@toto.com");
        final passwordInput = find.byKey(const Key("password_input_widget"));
        await tester.enterText(passwordInput, "toto");

        final signInButton =
            find.byKey(const Key("sign_in_view_sign_in_button"));
        await tester.press(signInButton);

        await tester.pump(const Duration(milliseconds: 100));

        final emailRequiredErrorFinder = find.text("Email is required");
        expect(emailRequiredErrorFinder, findsNothing);

        final emailInvalidFormatErrorFinder = find.text("Email invalid format");
        expect(emailInvalidFormatErrorFinder, findsNothing);

        final passwordRequiredErrorFinder = find.text("Password is required");
        expect(passwordRequiredErrorFinder, findsNothing);
      });
    });
  });
}
