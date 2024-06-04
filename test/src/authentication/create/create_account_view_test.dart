import "package:flutter/foundation.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/authentication/create/create_account_view.dart";
import "package:kana_to_kanji/src/core/repositories/user_repository.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:mockito/annotations.dart";

import "../../../helpers.dart";
@GenerateNiceMocks([MockSpec<UserRepository>()])
import "create_account_view_test.mocks.dart";

final userRepositoryMock = MockUserRepository();

void main() {
  setUpAll(() async {
    locator.registerSingleton<UserRepository>(userRepositoryMock);
  });
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

        final emailInput = find.byKey(const Key("email_input_widget"));
        expect(emailInput, findsOneWidget);

        final passwordInput = find.byKey(const Key("password_input_widget"));
        expect(passwordInput, findsOneWidget);

        final passwordConfirmationInput =
            find.byKey(const Key("password_confirmation_input_widget"));
        expect(passwordConfirmationInput, findsOneWidget);

        final createAccountButton =
            find.byKey(const Key("create_account_view_create_account_button"));
        expect(createAccountButton, findsOneWidget);

        final logoButton = find.byKey(const Key("button_logo_widget"));
        expect(logoButton, findsNWidgets(2));

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

        final emailInput = find.byKey(const Key("email_input_widget"));
        expect(emailInput, findsOneWidget);

        final passwordInput = find.byKey(const Key("password_input_widget"));
        expect(passwordInput, findsOneWidget);

        final passwordConfirmationInput =
            find.byKey(const Key("password_confirmation_input_widget"));
        expect(passwordConfirmationInput, findsOneWidget);

        final createAccountButton =
            find.byKey(const Key("create_account_view_create_account_button"));
        expect(createAccountButton, findsOneWidget);

        final logoButton = find.byKey(const Key("button_logo_widget"));
        expect(logoButton, findsNWidgets(1));
        debugDefaultTargetPlatformOverride = null;
      });
    });

    group("Form validations", () {
      testWidgets("Empty email", (WidgetTester tester) async {
        await tester.pumpLocalizedRouterWidget(const CreateAccountView(),
            initialLocation: CreateAccountView.routeName,
            allowedRoutes: [],
            allowedRoutesChild: const CreateAccountView());
        await tester.pumpAndSettle();

        final signInButton =
            find.byKey(const Key("create_account_view_create_account_button"));
        await tester.tap(signInButton);

        await tester.pump(const Duration(milliseconds: 100));

        final emailErrorFinder = find.text("Email is required");
        expect(emailErrorFinder, findsOneWidget);
      });

      testWidgets("Email invalid format", (WidgetTester tester) async {
        await tester.pumpLocalizedRouterWidget(const CreateAccountView(),
            initialLocation: CreateAccountView.routeName,
            allowedRoutes: [],
            allowedRoutesChild: const CreateAccountView());
        await tester.pumpAndSettle();

        final emailInput = find.byKey(const Key("email_input_widget"));
        await tester.enterText(emailInput, "toto");

        final signInButton =
            find.byKey(const Key("create_account_view_create_account_button"));
        await tester.tap(signInButton);

        await tester.pump(const Duration(milliseconds: 100));

        final emailErrorFinder = find.text("Email invalid format");
        expect(emailErrorFinder, findsOneWidget);
      });

      testWidgets("Empty password", (WidgetTester tester) async {
        await tester.pumpLocalizedRouterWidget(const CreateAccountView(),
            initialLocation: CreateAccountView.routeName,
            allowedRoutes: [],
            allowedRoutesChild: const CreateAccountView());
        await tester.pumpAndSettle();

        final signInButton =
            find.byKey(const Key("create_account_view_create_account_button"));
        await tester.tap(signInButton);

        await tester.pump(const Duration(milliseconds: 100));

        final passwordErrorFinder = find.text("Password is required");
        expect(passwordErrorFinder, findsOneWidget);
      });

      testWidgets("Empty password confirmation", (WidgetTester tester) async {
        await tester.pumpLocalizedRouterWidget(const CreateAccountView(),
            initialLocation: CreateAccountView.routeName,
            allowedRoutes: [],
            allowedRoutesChild: const CreateAccountView());
        await tester.pumpAndSettle();

        final signInButton =
            find.byKey(const Key("create_account_view_create_account_button"));
        await tester.tap(signInButton);

        await tester.pump(const Duration(milliseconds: 100));

        final passwordErrorFinder =
            find.text("Password confirmation is required");
        expect(passwordErrorFinder, findsOneWidget);
      });

      testWidgets("Passwords mismatch", (WidgetTester tester) async {
        await tester.pumpLocalizedRouterWidget(const CreateAccountView(),
            initialLocation: CreateAccountView.routeName,
            allowedRoutes: [],
            allowedRoutesChild: const CreateAccountView());
        await tester.pumpAndSettle();

        final passwordInput = find.byKey(const Key("password_input_widget"));
        await tester.enterText(passwordInput, "toto");
        final passwordConfirmationInput =
            find.byKey(const Key("password_confirmation_input_widget"));
        await tester.enterText(passwordConfirmationInput, "titi");

        final signInButton =
            find.byKey(const Key("create_account_view_create_account_button"));
        await tester.tap(signInButton);

        await tester.pump(const Duration(milliseconds: 100));

        final passwordErrorFinder =
            find.text("Password confirmation is different from the password");
        expect(passwordErrorFinder, findsOneWidget);
      });

      testWidgets("Correct email/password", (WidgetTester tester) async {
        await tester.pumpLocalizedRouterWidget(const CreateAccountView(),
            initialLocation: CreateAccountView.routeName,
            allowedRoutes: [],
            allowedRoutesChild: const CreateAccountView());
        await tester.pumpAndSettle();

        final emailInput = find.byKey(const Key("email_input_widget"));
        await tester.enterText(emailInput, "toto@toto.com");
        final passwordInput = find.byKey(const Key("password_input_widget"));
        await tester.enterText(passwordInput, "toto");
        final passwordConfirmationInput =
            find.byKey(const Key("password_confirmation_input_widget"));
        await tester.enterText(passwordConfirmationInput, "toto");

        final signInButton =
            find.byKey(const Key("create_account_view_create_account_button"));
        await tester.tap(signInButton);

        await tester.pump(const Duration(milliseconds: 100));

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
