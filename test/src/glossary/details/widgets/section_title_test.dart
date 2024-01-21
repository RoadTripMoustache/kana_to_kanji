import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:kana_to_kanji/src/glossary/details/widgets/section_title.dart';

import '../../../../helpers.dart';

void main() {
  group("SectionTitle", () {
    const titleSample = 'Test Title';

    testWidgets("it should display the pass titled", (WidgetTester tester) async {
      await tester
          .pumpLocalizedWidget(const SectionTitle(title: titleSample));

      final widget = find.byType(SectionTitle);

      expect(widget, findsOneWidget);
      expect(find.descendant(of: widget, matching: find.text(titleSample)),
          findsOneWidget);
      expect(find.descendant(of: widget, matching: find.byType(Divider)),
          findsOneWidget,
          reason: "Should have a divider");
    });

    testWidgets("it should use the pass style", (WidgetTester tester) async {
      await tester.pumpLocalizedWidget(const SectionTitle(
        title: titleSample,
        style: TextStyle(color: Colors.red, fontSize: 20),
      ));

      final widget = find.byType(SectionTitle);
      final title =
          find.descendant(of: widget, matching: find.text(titleSample));


      expect(title, findsOneWidget);
      Text titleWidget = tester.firstWidget(title);
      expect(titleWidget.style?.color, Colors.red);
      expect(titleWidget.style?.fontSize, 20);
    });
  });
}
