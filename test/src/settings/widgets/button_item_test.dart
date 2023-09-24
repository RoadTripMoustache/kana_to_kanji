import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kana_to_kanji/src/settings/widgets/button_item.dart';

import '../../../helpers.dart';

void main() {
  group("ButtonItem", () {
    testWidgets("UI", (WidgetTester tester) async {
      const String title = 'TEST';
      int called = 0;
      void onPressed() {
        called++;
      }

      await tester.pumpWidget(LocalizedWidget(
          child: ButtonItem(
              child: const Text(title),
              onPressed: () {
                called++;
              })));
      await tester.pumpAndSettle();

      final widget = find.byType(ButtonItem);

      expect(widget, findsOneWidget);

      final textFound = find.descendant(of: widget, matching: find.text(title));
      expect(textFound, findsOneWidget);

      await tester.tap(widget);
      expect(called, 1);
    });
  });
}
