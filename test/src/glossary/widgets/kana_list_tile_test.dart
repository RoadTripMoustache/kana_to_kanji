import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/constants/app_theme.dart";
import "package:kana_to_kanji/src/glossary/widgets/kana_list_tile.dart";

import "../../../dummies/kana.dart";
import "../../../helpers.dart";

void main() {
  group("KanaListTile", () {
    Future<Finder> pump(WidgetTester tester, Widget widget) async {
      await tester.pumpLocalizedWidget(widget);
      await tester.pumpAndSettle();

      return find.byType(KanaListTile);
    }

    group("UI", () {
      testWidgets("It should display the kana and its pronunciation",
          (WidgetTester tester) async {
        final widget = await pump(tester, const KanaListTile(dummyKatakana));

        // Validate that the Card"s elevation property is equal to 0
        final Finder card =
            find.descendant(of: widget, matching: find.byType(Card));
        expect((tester.widget(card) as Card).elevation, equals(1.0));

        Finder text = find.descendant(
            of: widget, matching: find.text(dummyKatakana.kana));
        expect(text, findsOneWidget);
        TextStyle? style = (tester.widget(text) as Text).style;
        TextStyle? expectedStyle = AppTheme.light().textTheme.titleMedium;
        expect(style?.fontWeight, FontWeight.bold,
            reason: "Font used should be bold");
        expect(style?.color, expectedStyle?.color);

        text = find.descendant(
            of: widget, matching: find.text(dummyKatakana.romaji));
        expect(text, findsOneWidget);
        style = (tester.widget(text) as Text).style;
        expectedStyle = AppTheme.light().textTheme.bodyMedium;
        expect(style?.fontWeight, FontWeight.normal,
            reason: "Font used should be bold");
        expect(style?.color, expectedStyle?.color);
      });

      // Added test
      testWidgets("When disabled, elevation and text color should change",
          (WidgetTester tester) async {
        final widget = await pump(
            tester, const KanaListTile(dummyKatakana, disabled: true));

        // Validate that the Card"s elevation property is equal to 0
        final Finder card =
            find.descendant(of: widget, matching: find.byType(Card));
        expect((tester.widget(card) as Card).elevation, equals(0.0));

        // Validate that all text style color is equal to theme.disabledColor
        final Finder texts =
            find.descendant(of: widget, matching: find.byType(Text));
        for (final Widget text in tester.widgetList(texts)) {
          expect((text as Text).style?.color,
              equals(AppTheme.light().disabledColor));
        }
      });
    });

    group("Interactions", () {
      final List<int> log = [];

      setUp(log.clear);

      testWidgets("It should call onPressed when tapped",
          (WidgetTester tester) async {
        final widget = await pump(
            tester,
            KanaListTile(dummyKatakana, onPressed: () {
              log.add(dummyKatakana.id);
            }));

        expect(widget, findsOneWidget);

        await tester.tap(widget);
        await tester.pumpAndSettle();

        expect(log, containsOnce(dummyKatakana.id),
            reason: "proof that onPressed was called one time");
      });

      testWidgets("It should not call onPressed when disabled",
          (WidgetTester tester) async {
        final widget = await pump(
            tester,
            KanaListTile(dummyKatakana, onPressed: () {
              log.add(dummyKatakana.id);
            }, disabled: true));

        expect(widget, findsOneWidget);

        await tester.tap(widget);
        await tester.pumpAndSettle();

        expect(log, isNot(contains(dummyKatakana.id)),
            reason: "proof that onPressed wasn't called");
      });
    });
  });
}
