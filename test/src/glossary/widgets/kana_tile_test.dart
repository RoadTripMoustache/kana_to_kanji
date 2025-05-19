import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/models/resources/kana.dart";
import "package:kana_to_kanji/src/glossary/widgets/kana_tile.dart";

import "../../../dummies/dummies.dart";
import "../../../helpers.dart";

void main() {
  group("KanaTile", () {
    int onPressedCallCount = 0;

    void mockOnPressed() {
      onPressedCallCount++;
    }

    tearDown(() {
      onPressedCallCount = 0;
    });

    Future<void> pumpKanaTile(
      WidgetTester tester, {
      required Kana kana,
      VoidCallback? onPressed,
      bool disabled = false,
    }) async {
      await tester.pumpLocalizedWidget(
        Center(
          child: SizedBox(
            width: 100,
            height: 100,
            child: KanaTile(kana, onPressed: onPressed, disabled: disabled),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets("Should display kana and romaji", (WidgetTester tester) async {
      await pumpKanaTile(tester, kana: dummyHiragana);

      expect(find.text(dummyHiragana.kana), findsOneWidget);
      expect(find.text(dummyHiragana.romaji), findsOneWidget);
    });

    testWidgets("Should call onPressed when tapped", (
      WidgetTester tester,
    ) async {
      await pumpKanaTile(tester, kana: dummyHiragana, onPressed: mockOnPressed);

      await tester.tap(find.byType(KanaTile));
      await tester.pumpAndSettle();

      expect(onPressedCallCount, 1);
    });

    testWidgets("Should not call onPressed when disabled", (
      WidgetTester tester,
    ) async {
      await pumpKanaTile(
        tester,
        kana: dummyHiragana,
        onPressed: mockOnPressed,
        disabled: true,
      );

      await tester.tap(find.byType(KanaTile));
      await tester.pumpAndSettle();

      expect(onPressedCallCount, 0);
    });

    testWidgets("Should have different styling when disabled", (
      WidgetTester tester,
    ) async {
      // Pump enabled tile
      await pumpKanaTile(tester, kana: dummyHiragana);

      // Get enabled styles
      final enabledKanaStyle =
          tester.widget<Text>(find.text(dummyHiragana.kana)).style;
      final enabledRomajiStyle =
          tester.widget<Text>(find.text(dummyHiragana.romaji)).style;

      // Pump disabled tile
      await pumpKanaTile(tester, kana: dummyHiragana, disabled: true);

      // Get disabled styles
      final disabledKanaStyle =
          tester.widget<Text>(find.text(dummyHiragana.kana)).style;
      final disabledRomajiStyle =
          tester.widget<Text>(find.text(dummyHiragana.romaji)).style;

      // Verify styles are different
      expect(enabledKanaStyle!.color, isNot(equals(disabledKanaStyle!.color)));
      expect(
        enabledRomajiStyle!.color,
        isNot(equals(disabledRomajiStyle!.color)),
      );
    });

    testWidgets("Should have zero elevation when disabled", (
      WidgetTester tester,
    ) async {
      await pumpKanaTile(tester, kana: dummyHiragana, disabled: true);

      // Find the card and check its elevation
      final disabledCard = find.byType(Card);
      expect(disabledCard, findsOneWidget);
      expect(tester.widget<Card>(disabledCard).elevation, 0.0);
    });
  });
}
