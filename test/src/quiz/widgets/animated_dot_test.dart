import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/quiz/widgets/animated_dot.dart";

import "../../../helpers.dart";

void main() {
  group("AnimatedDot", () {
    testWidgets("Dot should be filled with the default color",
        (WidgetTester tester) async {
      await tester.pumpLocalizedWidget(const AnimatedDot(filledOut: true));
      await tester.pumpAndSettle();

      final found = find.byType(Container);
      expect(found, findsOneWidget);
      expect(find.ancestor(of: found, matching: find.byType(AnimatedDot)),
          findsOneWidget);

      final boxDecoration =
          (tester.firstWidget(found) as Container).decoration as BoxDecoration;
      expect(boxDecoration.color, Colors.grey);
      expect(boxDecoration.border, Border.all(color: Colors.grey));
    });

    testWidgets("Dot should be filled with the passed color",
        (WidgetTester tester) async {
      const color = Colors.red;
      await tester.pumpLocalizedWidget(const AnimatedDot(
        filledOut: true,
        color: color,
      ));
      await tester.pumpAndSettle();

      final found = find.byType(Container);
      expect(found, findsOneWidget);
      expect(find.ancestor(of: found, matching: find.byType(AnimatedDot)),
          findsOneWidget);

      final boxDecoration =
          (tester.firstWidget(found) as Container).decoration as BoxDecoration;
      expect(boxDecoration.color, color);
      expect(boxDecoration.border, Border.all(color: color));
    });

    testWidgets("Dot should be not filled out with the default color",
        (WidgetTester tester) async {
      await tester.pumpLocalizedWidget(const AnimatedDot(filledOut: false));
      await tester.pumpAndSettle();

      final found = find.byType(Container);
      expect(found, findsOneWidget);
      expect(find.ancestor(of: found, matching: find.byType(AnimatedDot)),
          findsOneWidget);

      final boxDecoration =
          (tester.firstWidget(found) as Container).decoration as BoxDecoration;
      expect(boxDecoration.color, Colors.transparent);
      expect(boxDecoration.border, Border.all(color: Colors.grey));
    });
  });
}
