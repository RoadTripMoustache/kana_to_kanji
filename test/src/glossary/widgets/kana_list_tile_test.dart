import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kana_to_kanji/src/core/constants/alphabets.dart';
import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/glossary/widgets/kana_list_tile.dart';

import '../../../helpers.dart';

void main() {
  group("KanaListTile", () {
    final Kana kanaSample =
        Kana(0, Alphabets.hiragana, 0, "あ", "a", "2023-12-01");

    Future<Finder> pump(WidgetTester tester, Widget widget) async {
      await tester.pumpLocalizedWidget(widget);
      await tester.pumpAndSettle();

      return find.byType(KanaListTile);
    }

    group("UI", () {
      testWidgets("It should display the kana and its pronunciation",
          (WidgetTester tester) async {
        final widget = await pump(tester, KanaListTile(kanaSample));

        Finder text =
            find.descendant(of: widget, matching: find.text(kanaSample.kana));
        expect(text, findsOneWidget);

        text =
            find.descendant(of: widget, matching: find.text(kanaSample.romaji));
        expect(text, findsOneWidget);
      });
    });

    group("Interactions", () {
      final List<int> log = [];

      setUp(() {
        log.clear();
      });

      testWidgets("It should call onPressed when tapped",
          (WidgetTester tester) async {
        final widget = await pump(
            tester,
            KanaListTile(kanaSample, onPressed: () {
              log.add(kanaSample.id);
            }));

        expect(widget, findsOneWidget);

        await tester.tap(widget);
        await tester.pumpAndSettle();

        expect(log, containsOnce(kanaSample.id),
            reason: "proof that onPressed was called one time");
      });
    });
  });
}
