import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kana_to_kanji/src/glossary/widgets/search_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../helpers.dart';

void main() {
  group("GlossarySearchBar", () {
    testWidgets("Default view", (WidgetTester tester) async {
      /**
       * Steps:
       * 1. Load the GlossarySearchBar
       */

      await tester.pumpLocalizedWidget(GlossarySearchBar(
        searchGlossary: (String searchText) => {},
      ));
      await tester.pumpAndSettle();

      final searchBar = find.byType(GlossarySearchBar);
      expect(searchBar, findsOneWidget);

      final searchIcon = find.byKey(const Key("glossary_bar_search_icon"));
      expect(searchIcon, findsOneWidget);

      checkClosedState(tester);
    });

    testWidgets("Open search bar", (WidgetTester tester) async {
      /**
       * Steps:
       * 1. Load the GlossarySearchBar
       * 2. Open the search bar
       */

      final l10n = await setupLocalizations();

      await tester.pumpLocalizedWidget(GlossarySearchBar(
        searchGlossary: (String searchText) => {},
      ));

      // Simulate click to open the search bar
      final searchIcon = find.byKey(const Key("glossary_bar_search_icon"));
      await tester.tap(searchIcon);

      await tester.pumpAndSettle();

      final searchTextField =
          find.byKey(const Key("glossary_bar_search_text_field"));
      expect(
          tester.widget(searchTextField),
          isA<TextField>().having((tf) => tf.decoration?.hintText,
              "decoration.hintText", l10n.glossary_search_bar_hint));

      final found = find.byType(GlossarySearchBar);
      expect(found, findsOneWidget);
    });

    testWidgets("Open/Close search bar", (WidgetTester tester) async {
      /**
       * Steps:
       * 1. Load the GlossarySearchBar
       * 2. Open the search bar
       * 3. Close the search bar by clicking on the `search` icon
       */
      // Init widget
      final l10n = await setupLocalizations();

      await tester.pumpLocalizedWidget(GlossarySearchBar(
        searchGlossary: (String searchText) => {},
      ));

      // Simulate click to open the search bar
      final searchIcon = find.byKey(const Key("glossary_bar_search_icon"));
      await tester.tap(searchIcon);

      await tester.pumpAndSettle();

      checkOpenWithoutTextState(tester, l10n);

      // Simulate click to close the search bar
      await tester.tap(searchIcon);

      await tester.pumpAndSettle();

      checkClosedState(tester);
    });

    testWidgets("Tap text in search bar", (WidgetTester tester) async {
      /**
       * Steps:
       * 1. Load the GlossarySearchBar
       * 2. Open the search bar
       * 3. Tap text in the search bar
       */
      // Init widget
      final l10n = await setupLocalizations();

      await tester.pumpLocalizedWidget(GlossarySearchBar(
        searchGlossary: (String searchText) => {},
      ));

      // Simulate click to open the search bar
      final searchIcon = find.byKey(const Key("glossary_bar_search_icon"));
      await tester.tap(searchIcon);

      await tester.pumpAndSettle();

      checkOpenWithoutTextState(tester, l10n);

      // Simulate text typed in search field
      final searchTextField =
          find.byKey(const Key("glossary_bar_search_text_field"));
      await tester.enterText(searchTextField, "toto");

      await tester.pumpAndSettle();

      checkOpenWithTextState(tester, "toto", false);
    });

    testWidgets("Search text", (WidgetTester tester) async {
      /**
       * Steps:
       * 1. Load the GlossarySearchBar
       * 2. Open the search bar
       * 3. Tap text in the search bar
       * 4. Trigger search
       */
      // Init widget
      final l10n = await setupLocalizations();

      await tester.pumpLocalizedWidget(GlossarySearchBar(
        searchGlossary: (String searchText) => {},
      ));

      // Simulate click to open the search bar
      final searchIcon = find.byKey(const Key("glossary_bar_search_icon"));
      await tester.tap(searchIcon);

      await tester.pumpAndSettle();

      checkOpenWithoutTextState(tester, l10n);

      // Simulate text typed in search field
      final searchTextField =
          find.byKey(const Key("glossary_bar_search_text_field"));
      await tester.enterText(searchTextField, "toto");

      await tester.pumpAndSettle();

      checkOpenWithTextState(tester, "toto", false);

      // Simulate click to trigger the search
      await tester.tap(searchIcon);

      await tester.pumpAndSettle();

      checkSearchState(tester, "toto");
    });

    testWidgets("Search text, then clear", (WidgetTester tester) async {
      /**
       * Steps:
       * 1. Load the GlossarySearchBar
       * 2. Open the search bar
       * 3. Tap text in the search bar
       * 4. Trigger search
       * 5. Clear text input
       */
      // Init widget
      final l10n = await setupLocalizations();

      await tester.pumpLocalizedWidget(GlossarySearchBar(
        searchGlossary: (String searchText) => {},
      ));

      // Simulate click to open the search bar
      final searchIcon = find.byKey(const Key("glossary_bar_search_icon"));
      await tester.tap(searchIcon);

      await tester.pumpAndSettle();

      checkOpenWithoutTextState(tester, l10n);

      // Simulate text typed in search field
      final searchTextField =
          find.byKey(const Key("glossary_bar_search_text_field"));
      await tester.enterText(searchTextField, "toto");

      await tester.pumpAndSettle();

      checkOpenWithTextState(tester, "toto", false);

      // Simulate click to trigger the search
      await tester.tap(searchIcon);

      await tester.pumpAndSettle();

      checkSearchState(tester, "toto");

      // Simulate click to clear the input
      final clearSearchIcon =
          find.byKey(const Key("glossary_bar_clear_search_icon"));
      await tester.tap(clearSearchIcon);

      await tester.pumpAndSettle();

      checkOpenWithoutTextState(tester, l10n);
    });

    testWidgets("Search text, then clear and close",
        (WidgetTester tester) async {
      /**
       * Steps:
       * 1. Load the GlossarySearchBar
       * 2. Open the search bar
       * 3. Tap text in the search bar
       * 4. Trigger search
       * 5. Clear text input
       * 6. Close search bar with the search icon
       */
      // Init widget
      final l10n = await setupLocalizations();

      await tester.pumpLocalizedWidget(GlossarySearchBar(
        searchGlossary: (String searchText) => {},
      ));

      // Simulate click to open the search bar
      final searchIcon = find.byKey(const Key("glossary_bar_search_icon"));
      await tester.tap(searchIcon);

      await tester.pumpAndSettle();

      checkOpenWithoutTextState(tester, l10n);

      // Simulate text typed in search field
      final searchTextField =
          find.byKey(const Key("glossary_bar_search_text_field"));
      await tester.enterText(searchTextField, "toto");

      await tester.pumpAndSettle();

      checkOpenWithTextState(tester, "toto", false);

      // Simulate click to trigger the search
      await tester.tap(searchIcon);

      await tester.pumpAndSettle();

      checkSearchState(tester, "toto");

      // Simulate click to clear the input
      final clearSearchIcon =
          find.byKey(const Key("glossary_bar_clear_search_icon"));
      await tester.tap(clearSearchIcon);

      await tester.pumpAndSettle();

      checkOpenWithoutTextState(tester, l10n);

      // Simulate click to close the search bar
      await tester.tap(searchIcon);

      await tester.pumpAndSettle();

      checkClosedState(tester);
    });

    testWidgets("Search text, then close", (WidgetTester tester) async {
      /**
       * Steps:
       * 1. Load the GlossarySearchBar
       * 2. Open the search bar
       * 3. Tap text in the search bar
       * 4. Trigger search
       * 5. Close search bar with the arrow
       */
      // Init widget
      final l10n = await setupLocalizations();

      await tester.pumpLocalizedWidget(GlossarySearchBar(
        searchGlossary: (String searchText) => {},
      ));

      // Simulate click to open the search bar
      final searchIcon = find.byKey(const Key("glossary_bar_search_icon"));
      await tester.tap(searchIcon);

      await tester.pumpAndSettle();

      checkOpenWithoutTextState(tester, l10n);

      // Simulate text typed in search field
      final searchTextField =
          find.byKey(const Key("glossary_bar_search_text_field"));
      await tester.enterText(searchTextField, "toto");

      await tester.pumpAndSettle();

      checkOpenWithTextState(tester, "toto", false);

      // Simulate click to trigger the search
      await tester.tap(searchIcon);

      await tester.pumpAndSettle();

      checkSearchState(tester, "toto");

      // Simulate click to clear the input
      final cancelSearchIcon =
          find.byKey(const Key("glossary_bar_cancel_search_icon"));
      await tester.tap(cancelSearchIcon);

      await tester.pumpAndSettle();

      checkClosedState(tester);
    });
  });
}

// Check components of the search bar when the search bar is closed.
void checkClosedState(WidgetTester tester) {
  final searchTextField =
      find.byKey(const Key("glossary_bar_search_text_field"));
  expect(
      tester.widget(searchTextField),
      isA<TextField>()
          .having((tf) => tf.decoration?.hintText, "decoration.hintText", ""));

  final searchIcon = find.byKey(const Key("glossary_bar_search_icon"));
  expect(searchIcon, findsOneWidget);

  final clearSearchIcon =
      find.byKey(const Key("glossary_bar_clear_search_icon"));
  expect(clearSearchIcon, findsNothing);

  final closeSearchIcon =
      find.byKey(const Key("glossary_bar_cancel_search_icon"));
  expect(closeSearchIcon, findsNothing);
}

// Check components of the search bar when the search bar is opened and no text is typed in the input.
void checkOpenWithoutTextState(WidgetTester tester, AppLocalizations l10n) {
  final searchTextField =
      find.byKey(const Key("glossary_bar_search_text_field"));
  expect(
      tester.widget(searchTextField),
      isA<TextField>().having((tf) => tf.decoration?.hintText,
          "decoration.hintText", l10n.glossary_search_bar_hint));
  expect((tester.widget(searchTextField) as TextField).focusNode?.hasFocus,
      isTrue);

  final searchIcon = find.byKey(const Key("glossary_bar_search_icon"));
  expect(searchIcon, findsOneWidget);

  final clearSearchIcon =
      find.byKey(const Key("glossary_bar_clear_search_icon"));
  expect(clearSearchIcon, findsNothing);

  final closeSearchIcon =
      find.byKey(const Key("glossary_bar_cancel_search_icon"));
  expect(closeSearchIcon, findsNothing);
}

// Check components of the search bar when the search bar is opened and text is typed in the input.
void checkOpenWithTextState(
    WidgetTester tester, String textSearchInput, bool isClearVisible) {
  final searchTextField =
      find.byKey(const Key("glossary_bar_search_text_field"));
  expect(
      tester.widget(searchTextField),
      isA<TextField>().having(
          (tf) => tf.controller?.text, "controller.test", textSearchInput));
  expect((tester.widget(searchTextField) as TextField).focusNode?.hasFocus,
      isTrue);

  final searchIcon = find.byKey(const Key("glossary_bar_search_icon"));
  expect(searchIcon, findsOneWidget);

  final clearSearchIcon =
      find.byKey(const Key("glossary_bar_clear_search_icon"));
  expect(clearSearchIcon, (isClearVisible ? findsOneWidget : findsNothing));

  final closeSearchIcon =
      find.byKey(const Key("glossary_bar_cancel_search_icon"));
  expect(closeSearchIcon, findsNothing);
}

// Check components of the search bar when a search has been triggered.
void checkSearchState(WidgetTester tester, String textSearchInput) {
  final searchTextField =
      find.byKey(const Key("glossary_bar_search_text_field"));
  expect(
      tester.widget(searchTextField),
      isA<TextField>().having(
          (tf) => tf.controller?.text, "controller.test", textSearchInput));
  expect((tester.widget(searchTextField) as TextField).focusNode?.hasFocus,
      isFalse);

  final searchIcon = find.byKey(const Key("glossary_bar_search_icon"));
  expect(searchIcon, findsNothing);

  final clearSearchIcon =
      find.byKey(const Key("glossary_bar_clear_search_icon"));
  expect(clearSearchIcon, findsOneWidget);

  final closeSearchIcon =
      find.byKey(const Key("glossary_bar_cancel_search_icon"));
  expect(closeSearchIcon, findsOneWidget);
}
