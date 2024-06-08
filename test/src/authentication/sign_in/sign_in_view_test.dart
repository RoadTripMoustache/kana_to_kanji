import "package:flutter/foundation.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/authentication/sign_in/sign_in_view.dart";
import "package:kana_to_kanji/src/core/constants/authentication_method.dart";
import "package:kana_to_kanji/src/core/repositories/user_repository.dart";
import "package:kana_to_kanji/src/core/services/toaster_service.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

import "../../../helpers.dart";

@GenerateNiceMocks([MockSpec<UserRepository>(), MockSpec<ToasterService>()])
import "sign_in_view_test.mocks.dart";

final userRepositoryMock = MockUserRepository();
final toasterServiceMock = MockToasterService();

void main() {
  setUpAll(() async {
    locator
      ..registerSingleton<UserRepository>(userRepositoryMock)
      ..registerSingleton<ToasterService>(toasterServiceMock);
  });

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
        when(userRepositoryMock.register(
          AuthenticationMethod.classic,
          email: "toto@toto.com",
          password: "toto",
        )).thenAnswer((_) => Future.value(true));

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
        await tester.tap(signInButton);

        await tester.pump(const Duration(milliseconds: 100));

        final emailRequiredErrorFinder = find.text("Email is required");
        expect(emailRequiredErrorFinder, findsNothing);

        final emailInvalidFormatErrorFinder = find.text("Email invalid format");
        expect(emailInvalidFormatErrorFinder, findsNothing);

        final passwordRequiredErrorFinder = find.text("Password is required");
        expect(passwordRequiredErrorFinder, findsNothing);

        verify(userRepositoryMock.register(
          AuthenticationMethod.classic,
          email: "toto@toto.com",
          password: "toto",
        )).called(1);
        verifyNever(toasterServiceMock.toast(any, any));
      });

      testWidgets("Correct email/password - issue during registration",
          (WidgetTester tester) async {
        when(userRepositoryMock.register(
          AuthenticationMethod.classic,
          email: "toto@toto.com",
          password: "toto",
        )).thenAnswer((_) => Future.value(false));

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
        await tester.tap(signInButton);

        await tester.pump(const Duration(milliseconds: 100));

        final emailRequiredErrorFinder = find.text("Email is required");
        expect(emailRequiredErrorFinder, findsNothing);

        final emailInvalidFormatErrorFinder = find.text("Email invalid format");
        expect(emailInvalidFormatErrorFinder, findsNothing);

        final passwordRequiredErrorFinder = find.text("Password is required");
        expect(passwordRequiredErrorFinder, findsNothing);

        verify(userRepositoryMock.register(
          AuthenticationMethod.classic,
          email: "toto@toto.com",
          password: "toto",
        )).called(1);
        verify(toasterServiceMock.toast(any, any)).called(1);
      });
    });

    group("Sign in with external provider", () {
      group("Apple", () {
        testWidgets("Registration success", (WidgetTester tester) async {
          when(userRepositoryMock.register(AuthenticationMethod.apple))
              .thenAnswer((_) => Future.value(true));

          debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
          await tester.pumpLocalizedRouterWidget(const SignInView(),
              initialLocation: SignInView.routeName,
              allowedRoutes: [],
              allowedRoutesChild: const SignInView());
          await tester.pumpAndSettle();

          final logoButton = find.byKey(const Key("button_logo_widget"));
          expect(logoButton, findsNWidgets(2));

          await tester.tap(logoButton.last);

          await tester.pump(const Duration(milliseconds: 100));

          verify(userRepositoryMock.register(AuthenticationMethod.apple))
              .called(1);
          verifyNever(toasterServiceMock.toast(any, any));
          debugDefaultTargetPlatformOverride = null;
        });
        testWidgets("Registration fails", (WidgetTester tester) async {
          when(userRepositoryMock.register(AuthenticationMethod.apple))
              .thenAnswer((_) => Future.value(false));

          debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
          await tester.pumpLocalizedRouterWidget(const SignInView(),
              initialLocation: SignInView.routeName,
              allowedRoutes: [],
              allowedRoutesChild: const SignInView());
          await tester.pumpAndSettle();

          final logoButton = find.byKey(const Key("button_logo_widget"));
          expect(logoButton, findsNWidgets(2));

          await tester.tap(logoButton.last);

          await tester.pump(const Duration(milliseconds: 100));

          verify(userRepositoryMock.register(AuthenticationMethod.apple))
              .called(1);
          verify(toasterServiceMock.toast(any, any)).called(1);
          debugDefaultTargetPlatformOverride = null;
        });
      });

      group("Google", () {
        testWidgets("Registration success", (WidgetTester tester) async {
          when(userRepositoryMock.register(AuthenticationMethod.google))
              .thenAnswer((_) => Future.value(true));

          await tester.pumpLocalizedRouterWidget(const SignInView(),
              initialLocation: SignInView.routeName,
              allowedRoutes: [],
              allowedRoutesChild: const SignInView());
          await tester.pumpAndSettle();

          final logoButton = find.byKey(const Key("button_logo_widget"));
          expect(logoButton, findsOneWidget);

          await tester.tap(logoButton.first);

          await tester.pump(const Duration(milliseconds: 100));

          verify(userRepositoryMock.register(AuthenticationMethod.google))
              .called(1);
          verifyNever(toasterServiceMock.toast(any, any));
        });
        testWidgets("Registration fails", (WidgetTester tester) async {
          when(userRepositoryMock.register(AuthenticationMethod.google))
              .thenAnswer((_) => Future.value(false));

          await tester.pumpLocalizedRouterWidget(const SignInView(),
              initialLocation: SignInView.routeName,
              allowedRoutes: [],
              allowedRoutesChild: const SignInView());
          await tester.pumpAndSettle();

          final logoButton = find.byKey(const Key("button_logo_widget"));
          expect(logoButton, findsOneWidget);

          await tester.tap(logoButton.first);

          await tester.pump(const Duration(milliseconds: 100));

          verify(userRepositoryMock.register(AuthenticationMethod.google))
              .called(1);
          verify(toasterServiceMock.toast(any, any)).called(1);
        });
      });
    });
  });
}
