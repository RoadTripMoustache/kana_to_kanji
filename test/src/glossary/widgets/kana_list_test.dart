import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/models/kana.dart";
import "package:kana_to_kanji/src/glossary/widgets/kana_list.dart";
import "package:kana_to_kanji/src/glossary/widgets/kana_list_tile.dart";

import "../../../dummies/kana.dart";
import "../../../helpers.dart";

void main() {
  group("KanaList", () {
    late final AppLocalizations l10n;
    final List<Kana> kanaListSample = List.generate(107, generateDummyKana);

    setUpAll(() async {
      l10n = await setupLocalizations();
    });

    testWidgets("Empty list", (WidgetTester tester) async {
      await tester.pumpLocalizedWidget(const KanaList(items: []));
      await tester.pumpAndSettle();

      expect(find.byType(KanaListTile), findsNothing);
      expect(find.text(l10n.nothing_to_show), findsOneWidget);
    });

    testWidgets("Full list", (WidgetTester tester) async {
      final items = List.generate(
        kanaListSample.length,
        (index) => (kana: kanaListSample[index], disabled: false),
      );
      await tester.pumpLocalizedWidget(KanaList(items: items));
      await tester.pumpAndSettle();

      expect(
        find.byType(KanaListTile),
        findsNWidgets(items.length),
        reason: "All the tiles passed should be displayed",
      );

      final grids = find.byType(GridView);
      expect(
        grids,
        findsNWidgets(3),
        reason: "Should have 3 GridView: Main, dakuten and combinaison",
      );
      // Main kana
      expect(
        find.descendant(of: grids.first, matching: find.byType(KanaListTile)),
        findsNWidgets(46),
        reason: "Should have all the main kana on it (the first 46 elements",
      );
      expect(
        find.descendant(
          of: grids.first,
          matching: find.byWidgetPredicate(
            (widget) => widget is Card && widget.elevation == 0,
          ),
        ),
        findsNWidgets(5),
        reason: "There should have 5 empty card on the main kana",
      );

      // Dakuten
      expect(find.text(l10n.dakuten_kana), findsOneWidget);
      expect(
        find.descendant(of: grids.at(1), matching: find.byType(KanaListTile)),
        findsNWidgets(25),
        reason: "Should show 25 elements (dakuten)",
      );

      // Combinaison
      expect(find.text(l10n.combination_kana), findsOneWidget);
      expect(
        find.descendant(of: grids.last, matching: find.byType(KanaListTile)),
        findsNWidgets(36),
        reason: "Should show 36 elements (combinaison)",
      );
    });

    testWidgets("The first not disabled tile should be visible", (
      WidgetTester tester,
    ) async {
      final items = List.generate(
        kanaListSample.length,
        (index) => (kana: kanaListSample[index], disabled: false),
      );
      final disabledItems = List.generate(
        kanaListSample.length,
        (index) => (kana: kanaListSample[index], disabled: index != 105),
      );

      await tester.pumpLocalizedWidget(KanaList(items: items));
      await tester.pumpAndSettle();

      expect(
        find.byType(KanaListTile),
        findsNWidgets(107),
        reason: "All the tiles passed should be displayed",
      );
      expect(
        find.byWidgetPredicate(
          (widget) => widget is KanaListTile && widget.disabled,
        ),
        findsNothing,
      );

      // Update the kana to have only the 105th not disabled
      await tester.pumpLocalizedWidget(KanaList(items: disabledItems));
      await tester.pumpAndSettle();

      final Finder tiles = find.byWidgetPredicate(
        (widget) => widget is KanaListTile && widget.disabled,
      );
      expect(tiles, findsNWidgets(disabledItems.length - 1));
      // Check that 105th tile is visible
      expect(find.byType(KanaListTile).at(105).hitTestable(), findsOneWidget);
    });
  });
}
