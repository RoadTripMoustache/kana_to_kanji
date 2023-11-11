import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kana_to_kanji/src/settings/widgets/tile_item.dart';

import '../../../helpers.dart';

void main() {
  group("TileItem", () {
    testWidgets("UI", (WidgetTester tester) async {
      const String title = 'title';
      const String subtitle = 'Subtitle';
      const IconData leading = Icons.abc;
      const IconData trailing = Icons.account_circle_outlined;

      await tester.pumpLocalizedWidget(const TileItem(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(leading),
        trailing: Icon(trailing),
      ));
      await tester.pumpAndSettle();

      final widget = find.byType(TileItem);

      expect(widget, findsOneWidget);

      expect(find.descendant(of: widget, matching: find.text(title)),
          findsOneWidget);
      expect(find.descendant(of: widget, matching: find.text(subtitle)),
          findsOneWidget);
      expect(find.descendant(of: widget, matching: find.byIcon(leading)),
          findsOneWidget);
      expect(find.descendant(of: widget, matching: find.byIcon(trailing)),
          findsOneWidget);

      expect(
          find.descendant(
              of: widget,
              matching: find.byWidgetPredicate((widget) =>
                  widget is ListTile &&
                  widget.contentPadding ==
                      const EdgeInsets.symmetric(horizontal: 16.0))),
          findsOneWidget);
    });
  });
}
