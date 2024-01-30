import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kana_to_kanji/src/core/constants/sort_order.dart';
import 'package:kana_to_kanji/src/glossary/widgets/sort_by.dart';

import '../../../helpers.dart';

void main() {
  group("SortBy", () {
    testWidgets("Default view - Japanese sort selected",
        (WidgetTester tester) async {
      await tester.pumpLocalizedWidget(SortBy(
        sortGlossary: (SortOrder order) => {},
        selectedOrder: SortOrder.japanese,
      ));
      await tester.pumpAndSettle();

      final radioButtons = find.byType(Radio<SortOrder>);
      expect(radioButtons, findsNWidgets(2));

      expect((tester.widget(radioButtons.at(0)) as Radio<SortOrder>).groupValue,
          SortOrder.japanese);
    });

    testWidgets("Default view - Alphabetical sort selected",
        (WidgetTester tester) async {
      await tester.pumpLocalizedWidget(SortBy(
        sortGlossary: (SortOrder order) => {},
        selectedOrder: SortOrder.alphabetical,
      ));
      await tester.pumpAndSettle();

      final radioButtons = find.byType(Radio<SortOrder>);
      expect(radioButtons, findsNWidgets(2));

      expect((tester.widget(radioButtons.at(0)) as Radio<SortOrder>).groupValue,
          SortOrder.alphabetical);
    });

    testWidgets("Click on close", (WidgetTester tester) async {
      var isClicked = false;
      await tester.pumpLocalizedWidget(SortBy(
        sortGlossary: (SortOrder order) => {isClicked = true},
        selectedOrder: SortOrder.alphabetical,
      ));
      await tester.pumpAndSettle();

      final buttons = find.byType(IconButton);
      expect(buttons, findsOneWidget);
      expect(isClicked, isFalse);

      await tester.tap(buttons.first);
      expect(isClicked, isTrue);
    });
  });
}
