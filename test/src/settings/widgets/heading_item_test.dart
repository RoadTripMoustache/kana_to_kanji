import 'package:flutter_test/flutter_test.dart';
import 'package:kana_to_kanji/src/settings/widgets/heading_item.dart';

import '../../../helpers.dart';

void main() {
  group("HeadingItem", () {
    testWidgets("UI", (WidgetTester tester) async {
      const String title = 'TEST';
      await tester.pumpLocalizedWidget(const HeadingItem(
        title: title,
      ));
      await tester.pumpAndSettle();

      final widget = find.byType(HeadingItem);

      expect(widget, findsOneWidget);

      final textFound = find.descendant(of: widget, matching: find.text(title));
      expect(textFound, findsOneWidget);
    });
  });
}
