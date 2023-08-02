import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kana_to_kanji/src/quiz/widgets/flip_card.dart';

import '../../../helpers.dart';

void main() {
  group("FlipCard", () {
    const frontText = "Front";
    const rearText = "Rear";

    testWidgets("Should show the front widget when doing the first build",
        (WidgetTester tester) async {
      const widget = FlipCard(front: Text(frontText), back: Text(rearText));

      await tester.pumpWidget(const LocalizedWidget(child: widget));
      await tester.pumpAndSettle();

      expect(find.text(frontText), findsOneWidget);
      expect(find.text(rearText), findsNothing);
    });

    testWidgets("Should show the back widget when asking for a flip",
        (WidgetTester tester) async {
      const widget =
          FlipCard(front: Text(frontText), back: Text(rearText), flipped: true);

      await tester.pumpWidget(const LocalizedWidget(child: widget));
      await tester.pumpAndSettle();

      expect(find.text(frontText), findsNothing);
      expect(find.text(rearText), findsOneWidget);
    });

    group("Tap interaction", () {
      testWidgets("should do nothing when tapped and interaction are disable",
          (WidgetTester tester) async {
        const widget = FlipCard(
            front: Text(frontText),
            back: Text(rearText),
            allowTapToFlip: false);

        await tester.pumpWidget(const LocalizedWidget(child: widget));
        await tester.pumpAndSettle();

        expect(find.text(frontText), findsOneWidget);
        expect(find.text(rearText), findsNothing);

        await tester.tap(find.byType(FlipCard));
        await tester.pumpAndSettle();

        expect(find.text(frontText), findsOneWidget);
        expect(find.text(rearText), findsNothing);
      });

      testWidgets("should flip when tapped and tap to flip is allowed",
          (WidgetTester tester) async {
        const widget = FlipCard(
            front: Text(frontText),
            back: Text(rearText),
            allowTapToFlip: true);

        await tester.pumpWidget(const LocalizedWidget(child: widget));
        await tester.pumpAndSettle();

        expect(find.text(frontText), findsOneWidget);
        expect(find.text(rearText), findsNothing);

        await tester.tap(find.byType(FlipCard));
        await tester.pumpAndSettle();

        expect(find.text(frontText), findsNothing);
        expect(find.text(rearText), findsOneWidget);
      });
    });
  });
}
