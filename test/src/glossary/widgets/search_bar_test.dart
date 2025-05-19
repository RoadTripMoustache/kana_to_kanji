import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/glossary/widgets/search_bar.dart";

import "../../../helpers.dart";

void main() {
  group("HiddenSearchBar", () {
    final List<String> searchHistory = [];
    void searchCallback(String searchText) {
      searchHistory.add(searchText);
    }

    tearDown(searchHistory.clear);

    Future<void> pumpSearchBar(
      WidgetTester tester, {
      String title = "Test Title",
      List<Widget> actions = const [],
      PreferredSizeWidget? bottom,
    }) async {
      await tester.pumpLocalizedWidget(
        Scaffold(
          appBar: HiddenSearchBar(
            title: title,
            onSearch: searchCallback,
            actions: actions,
            bottom: bottom,
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets("Should display title and search icon initially", (
      WidgetTester tester,
    ) async {
      const title = "Title";
      await pumpSearchBar(tester, title: title);

      // Verify title is displayed
      expect(find.text(title), findsOneWidget);

      // Verify search icon is displayed
      expect(find.byIcon(Icons.search), findsOneWidget);

      // Verify search field is not displayed
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets("Should show search field when search icon is tapped", (
      WidgetTester tester,
    ) async {
      await pumpSearchBar(tester);

      // Tap search icon
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Verify search field is displayed
      expect(find.byType(TextField), findsOneWidget);

      // Verify back button is displayed
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);

      // Verify title is not displayed
      expect(find.text("Test Title"), findsNothing);
    });

    testWidgets("Should hide search field when back button is tapped", (
      WidgetTester tester,
    ) async {
      await pumpSearchBar(tester);

      // Tap search icon to show search field
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Verify search field is displayed
      expect(find.byType(TextField), findsOneWidget);

      // Tap back button
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Verify search field is not displayed
      expect(find.byType(TextField), findsNothing);

      // Verify title is displayed again
      expect(find.text("Test Title"), findsOneWidget);

      // Verify onSearch was called with empty string
      expect(searchHistory.length, 1);
      expect(searchHistory.first, "");
    });

    testWidgets("Should call onSearch when text is submitted", (
      WidgetTester tester,
    ) async {
      await pumpSearchBar(tester);

      // Tap search icon to show search field
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Enter text in search field
      const searchText = "test";
      await tester.enterText(find.byType(TextField), searchText);
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      // Verify onSearch was called with the entered text
      expect(searchHistory.length, 1);
      expect(searchHistory.first, searchText);
    });

    testWidgets("Should show clear button when text is entered", (
      WidgetTester tester,
    ) async {
      await pumpSearchBar(tester);

      // Tap search icon to show search field
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Verify clear button is not displayed initially
      expect(find.byIcon(Icons.clear), findsNothing);

      // Enter text in search field
      await tester.enterText(find.byType(TextField), "test");
      await tester.pumpAndSettle();

      // Verify clear button is displayed
      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets(
      "Should clear text and call onSearch when clear button is tapped",
      (WidgetTester tester) async {
        await pumpSearchBar(tester);

        // Tap search icon to show search field
        await tester.tap(find.byIcon(Icons.search));
        await tester.pumpAndSettle();

        // Enter text in search field
        await tester.enterText(find.byType(TextField), "test");
        await tester.pumpAndSettle();

        // Tap clear button
        await tester.tap(find.byIcon(Icons.clear));
        await tester.pumpAndSettle();

        // Verify text field is empty
        expect(find.text("test"), findsNothing);

        // Verify onSearch was called with empty string
        expect(searchHistory.length, 1);
        expect(searchHistory.first, "");
      },
    );

    testWidgets("Should filter input to allow only valid characters", (
      WidgetTester tester,
    ) async {
      await pumpSearchBar(tester);

      // Tap search icon to show search field
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Enter text with valid and invalid characters
      await tester.enterText(find.byType(TextField), "test123!@#あいう漢字");
      await tester.pumpAndSettle();

      // Verify only valid characters are displayed
      expect(find.text("test123!@#あいう漢字"), findsNothing);
      expect(find.text("testあいう漢字"), findsOneWidget);
    });

    testWidgets("Should display additional actions", (
      WidgetTester tester,
    ) async {
      final actions = [
        IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
      ];

      await pumpSearchBar(tester, actions: actions);

      // Verify additional action is displayed
      expect(find.byIcon(Icons.filter_list), findsOneWidget);
    });

    testWidgets("Should display bottom widget if provided", (
      WidgetTester tester,
    ) async {
      final bottom = PreferredSize(
        preferredSize: const Size.fromHeight(48.0),
        child: Container(
          height: 48.0,
          color: Colors.blue,
          child: const Center(child: Text("Bottom Widget")),
        ),
      );

      await pumpSearchBar(tester, bottom: bottom);

      // Verify bottom widget is displayed
      expect(find.text("Bottom Widget"), findsOneWidget);
    });
  });
}
