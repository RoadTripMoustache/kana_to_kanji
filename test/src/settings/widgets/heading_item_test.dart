import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kana_to_kanji/src/core/constants/app_theme.dart';
import 'package:kana_to_kanji/src/settings/widgets/heading_item.dart';

import '../../../helpers.dart';

void main() {
  group("HeadingItem", () {
    testWidgets("UI", (WidgetTester tester) async {
      const String title = 'TEST';
      await tester.pumpWidget(const LocalizedWidget(
          child: HeadingItem(
        title: title,
      )));
      await tester.pumpAndSettle();

      final widget = find.byType(HeadingItem);

      expect(widget, findsOneWidget);

      final textFound = find.descendant(of: widget, matching: find.text(title));
      expect(textFound, findsOneWidget);
    });
  });
}
