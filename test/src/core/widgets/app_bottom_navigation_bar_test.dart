import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/widgets/app_bottom_navigation_bar.dart";
import "package:kana_to_kanji/src/quiz/prepare/prepare_quiz_view.dart";

import "../../../helpers.dart";

void main() {
  group("AppBottomNavigationBar", () {
    testWidgets("should have 3 tabs", (WidgetTester tester) async {
      final l10n = await setupLocalizations();

      await tester.pumpLocalizedRouterWidget(const AppBottomNavigationBar(),
          initialLocation: PrepareQuizView.routeName);
      await tester.pumpAndSettle();

      final widget = find.byType(AppBottomNavigationBar);

      expect(widget, findsOneWidget);
      expect(
          find.descendant(
              of: widget, matching: find.byType(NavigationDestination)),
          findsNWidgets(3),
          reason: "Should only have 3 tabs");

      // Practice tab
      Finder tab = find.ancestor(
          of: find.text(l10n.app_bottom_bar_practice),
          matching: find.byType(NavigationDestination));

      expect(tab, findsOneWidget);
      expect(
          find.descendant(
              of: tab, matching: find.byIcon(Icons.psychology_rounded)),
          findsOneWidget,
          reason: "Practice icon should be psychology_rounded, "
              "as it's currently selected");

      // Glossary tab
      tab = find.ancestor(
          of: find.text(l10n.app_bottom_bar_glossary),
          matching: find.byType(NavigationDestination));

      expect(tab, findsOneWidget);
      expect(
          find.descendant(
              of: tab, matching: find.byIcon(Icons.menu_book_outlined)),
          findsOneWidget,
          reason: "Practice icon should be menu_book_outlined");

      // Profile tab
      tab = find.ancestor(
          of: find.text(l10n.app_bottom_bar_profile),
          matching: find.byType(NavigationDestination));

      expect(tab, findsOneWidget);
      expect(
          find.descendant(of: tab, matching: find.byIcon(Icons.face_outlined)),
          findsOneWidget,
          reason: "Profile icon should be face_outlined");
    });

    group("Behaviours", () {
      testWidgets("should open the glossary", (WidgetTester tester) async {
        final l10n = await setupLocalizations();

        await tester.pumpLocalizedRouterWidget(const AppBottomNavigationBar(),
            initialLocation: PrepareQuizView.routeName,
            allowedRoutes: ["/glossary"],
            allowedRoutesChild: const AppBottomNavigationBar());
        await tester.pumpAndSettle();

        // Glossary tab
        final Finder tab = find.ancestor(
            of: find.text(l10n.app_bottom_bar_glossary),
            matching: find.byType(NavigationDestination));

        expect(tab, findsOneWidget);
        expect(
            find.descendant(
                of: tab, matching: find.byIcon(Icons.menu_book_outlined)),
            findsOneWidget,
            reason: "Practice icon should be menu_book_outlined");

        await tester.tap(find.descendant(
            of: tab, matching: find.byIcon(Icons.menu_book_outlined)));
        await tester.pumpAndSettle();

        expect(find.byKey(Key(getRouterKey("/glossary"))), findsOneWidget);
        expect(find.byIcon(Icons.menu_book_rounded), findsOneWidget,
            reason:
                "The selected icon of Glossary should be menu_book_rounded");
      });
      testWidgets("should open the profile", (WidgetTester tester) async {
        final l10n = await setupLocalizations();

        await tester.pumpLocalizedRouterWidget(const AppBottomNavigationBar(),
            initialLocation: PrepareQuizView.routeName,
            allowedRoutes: ["/profile"],
            allowedRoutesChild: const AppBottomNavigationBar());
        await tester.pumpAndSettle();

        // Profile tab
        final Finder tab = find.ancestor(
            of: find.text(l10n.app_bottom_bar_profile),
            matching: find.byType(NavigationDestination));

        expect(tab, findsOneWidget);
        expect(
            find.descendant(
                of: tab, matching: find.byIcon(Icons.face_outlined)),
            findsOneWidget,
            reason: "Practice icon should be face_outlined");

        await tester.tap(find.descendant(
            of: tab, matching: find.byIcon(Icons.face_outlined)));
        await tester.pumpAndSettle();

        expect(find.byKey(Key(getRouterKey("/profile"))), findsOneWidget);
        expect(find.byIcon(Icons.face_rounded), findsOneWidget,
            reason: "The selected icon of Profile should be face_rounded");
      });
    });
  });
}
