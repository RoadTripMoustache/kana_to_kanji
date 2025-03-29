import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_rtm/flutter_rtm.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/l10n/app_localizations.dart";
import "package:kana_to_kanji/src/authentication/sign_in/sign_in_view.dart";
import "package:kana_to_kanji/src/authentication/widgets/input_email.dart";
import "package:kana_to_kanji/src/authentication/widgets/input_password.dart";
import "package:kana_to_kanji/src/authentication/widgets/third_party_round_icon_button.dart";
import "package:kana_to_kanji/src/glossary/glossary_view.dart";

import "../../../helpers.dart";

void main() {
  group("SignInView", () {
    late final AppLocalizations l10n;

    setUpAll(() async {
      l10n = await setupLocalizations();
    });

    Future<void> pumpAndSettleView(WidgetTester tester) async {
      await tester.pumpLocalizedRouterWidget(
        const SignInView(),
        initialLocation: SignInView.routeName,
        allowedRoutes: [
          GlossaryView.routeName,
          "/authentication/reset_password",
        ],
        allowedRoutesChild: const SignInView(),
      );
      await tester.pumpAndSettle();
    }

    group("Default display", () {
      testWidgets("iOS", (WidgetTester tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        await pumpAndSettleView(tester);

        expect(
          find.descendant(
            of: find.byType(AppBar),
            matching: find.widgetWithIcon(
              RTMIconButton,
              Icons.arrow_back_rounded,
            ),
          ),
          findsOneWidget,
          reason: "The back button should be available in the AppBar",
        );

        // Validate the form
        expect(find.byType(InputEmail), findsOneWidget);
        expect(find.byType(InputPassword), findsOneWidget);
        expect(
          find.widgetWithText(RTMTextButton, l10n.sign_in_view_forgot_password),
          findsOneWidget,
        );
        final signInButton = find.widgetWithText(
          FilledButton,
          l10n.sign_in_view_sign_in,
        );
        expect(signInButton, findsOneWidget);
        expect(
          tester.widget<FilledButton>(signInButton).enabled,
          isFalse,
          reason: "Sign in button should be disabled if the form isn't valid",
        );

        // Validate both sign in with ... buttons are there
        expect(find.byType(ThirdPartyRoundRTMIconButton), findsNWidgets(2));

        debugDefaultTargetPlatformOverride = null;
      });

      testWidgets("Android", (WidgetTester tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        await pumpAndSettleView(tester);

        expect(
          find.descendant(
            of: find.byType(AppBar),
            matching: find.widgetWithIcon(
              RTMIconButton,
              Icons.arrow_back_rounded,
            ),
          ),
          findsOneWidget,
          reason: "The back button should be available in the AppBar",
        );

        // Validate the form
        expect(find.byType(InputEmail), findsOneWidget);
        expect(find.byType(InputPassword), findsOneWidget);
        expect(
          find.widgetWithText(RTMTextButton, l10n.sign_in_view_forgot_password),
          findsOneWidget,
        );
        final signInButton = find.widgetWithText(
          FilledButton,
          l10n.sign_in_view_sign_in,
        );
        expect(signInButton, findsOneWidget);
        expect(
          tester.widget<FilledButton>(signInButton).enabled,
          isFalse,
          reason: "Sign in button should be disabled if the form isn't valid",
        );

        // Validate only one sign in with ... button is there.
        expect(find.byType(ThirdPartyRoundRTMIconButton), findsOneWidget);

        debugDefaultTargetPlatformOverride = null;
      });
    });

    group("Form", () {
      testWidgets(
        "Sign in button should only be enabled when the form is valid",
        (WidgetTester tester) async {
          await pumpAndSettleView(tester);

          // Initial state
          Finder signInButton = find.widgetWithText(
            FilledButton,
            l10n.sign_in_view_sign_in,
          );
          expect(
            tester.widget<FilledButton>(signInButton).enabled,
            isFalse,
            reason: "Sign in button should be disabled if the form isn't valid",
          );

          // Enter a valid email
          await tester.enterText(find.byType(InputEmail), "valid@valid.com");
          // Pump 300ms for the validation to be triggered
          await tester.pump(const Duration(milliseconds: 300));

          // Sign in button should be disabled
          signInButton = find.widgetWithText(
            FilledButton,
            l10n.sign_in_view_sign_in,
          );
          expect(
            tester.widget<FilledButton>(signInButton).enabled,
            isFalse,
            reason: "Sign in button should be disabled if the form isn't valid",
          );

          // Enter a password
          await tester.enterText(find.byType(InputPassword), "password");
          // Pump 300ms for the validation to be triggered
          await tester.pump(const Duration(milliseconds: 300));

          // Sign in button should be disabled
          signInButton = find.widgetWithText(
            FilledButton,
            l10n.sign_in_view_sign_in,
          );
          expect(
            tester.widget<FilledButton>(signInButton).enabled,
            isTrue,
            reason: "Sign in button should be enabled if the form is valid",
          );

          // Change the email to an invalid one
          await tester.enterText(find.byType(InputEmail), "");
          await tester.enterText(find.byType(InputEmail), "invalid");
          // Pump 300ms for the validation to be triggered
          await tester.pump(const Duration(milliseconds: 300));

          // Sign in button should be disabled
          signInButton = find.widgetWithText(
            FilledButton,
            l10n.sign_in_view_sign_in,
          );
          expect(
            tester.widget<FilledButton>(signInButton).enabled,
            isFalse,
            reason: "Sign in button should be disabled if the form isn't valid",
          );
        },
      );

      testWidgets("All button should be disabled during sign in process", (
        WidgetTester tester,
      ) async {
        await pumpAndSettleView(tester);

        // Enter valid email and password
        await tester.enterText(find.byType(InputEmail), "valid@valid.com");
        await tester.enterText(find.byType(InputPassword), "password");
        // Pump 300ms for the validation to be triggered
        await tester.pump(const Duration(milliseconds: 300));
        // Trigger sign in.
        await tester.tap(find.text(l10n.sign_in_view_sign_in));
        await tester.pump();

        // Validate all inputs are disabled
        expect(
          tester.widget<InputEmail>(find.byType(InputEmail)).enabled,
          isFalse,
        );
        expect(
          tester.widget<InputPassword>(find.byType(InputPassword)).enabled,
          isFalse,
        );

        // Validate all buttons are disabled.
        expect(
          tester
              .widget<RTMTextButton>(
                find.widgetWithText(
                  RTMTextButton,
                  l10n.sign_in_view_forgot_password,
                ),
              )
              .enabled,
          isFalse,
        );
        for (final ThirdPartyRoundRTMIconButton button in tester
            .widgetList<ThirdPartyRoundRTMIconButton>(
              find.byType(ThirdPartyRoundRTMIconButton),
            )) {
          expect(button.onPressed, isNull);
        }

        // Validate Sign in button is a RTMSpinner
        expect(
          find.widgetWithText(FilledButton, l10n.sign_in_view_sign_in),
          findsNothing,
          reason:
              "During the sign in process the sign in"
              " button should not be visible",
        );
        expect(
          find.byType(RTMSpinner),
          findsOneWidget,
          reason:
              "During the sign in process, a RTMSpinner "
              "should be displayed instead of the sign in button",
        );

        // Finish the sign in process
        await tester.pumpAndSettle();

        // Validate user was redirected to GlossaryView.
        expect(
          find.byKey(Key(getRouterKey(GlossaryView.routeName))),
          findsOneWidget,
        );
      });

      testWidgets("Clicking on Forgot password should redirect to the "
          "ResetPasswordView", (WidgetTester tester) async {
        await pumpAndSettleView(tester);

        // Tap on Forgot password button
        await tester.tap(find.text(l10n.sign_in_view_forgot_password));
        await tester.pumpAndSettle();

        // Validate new view
        expect(
          find.byKey(Key(getRouterKey("/authentication/reset_password"))),
          findsOneWidget,
        );
      });
    });

    group("Social Sign in", () {
      group("Google", () {
        testWidgets("Redirect to the glossary if sign in succeed", (
          WidgetTester tester,
        ) async {
          // TODO: Temporary solution until we understand why the Widget is
          //  off-screen only in the test
          await tester.binding.setSurfaceSize(const Size(800, 800));
          await pumpAndSettleView(tester);

          // Tap on Forgot password button
          await tester.tap(find.byKey(const Key("google_sign_in")));
          await tester.pumpAndSettle();

          // TODO : Validate Google sign in.

          // Validate new view
          expect(
            find.byKey(Key(getRouterKey(GlossaryView.routeName))),
            findsOneWidget,
            reason:
                "On successful sign in, the user should be redirected "
                "to the glossary",
          );

          // Reset surface size.
          await tester.binding.setSurfaceSize(null);
        });
      });

      group("Apple", () {
        testWidgets("Redirect to the glossary if sign in succeed", (
          WidgetTester tester,
        ) async {
          // Set iOS as platform to make the Apple sign in button appear
          debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
          // TODO: Temporary solution until we understand why the Widget is
          //  off-screen only in the test
          await tester.binding.setSurfaceSize(const Size(800, 800));
          await pumpAndSettleView(tester);

          // Tap on Forgot password button
          await tester.tap(find.byKey(const Key("apple_sign_in")));
          await tester.pumpAndSettle();

          // TODO : Validate Apple sign in.

          // Validate new view
          expect(
            find.byKey(Key(getRouterKey(GlossaryView.routeName))),
            findsOneWidget,
            reason:
                "On successful sign in, the user should be redirected "
                "to the glossary",
          );

          // Reset the default platform
          debugDefaultTargetPlatformOverride = null;
          // Reset surface size.
          await tester.binding.setSurfaceSize(null);
        });
      });
    });
  });
}
