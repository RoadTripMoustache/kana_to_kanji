import 'package:flutter_test/flutter_test.dart';
import 'package:kana_to_kanji/src/core/constants/alphabets.dart';
import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/glossary/widgets/kana_list.dart';
import 'package:kana_to_kanji/src/glossary/widgets/kana_list_tile.dart';

import '../../../helpers.dart';

void main() {
  group("KanaList", () {
    testWidgets("Empty list", (WidgetTester tester) async {
      await tester.pumpLocalizedWidget(const KanaList(
        items: [],
      ));
      await tester.pumpAndSettle();

      final found = find.byType(KanaListTile);
      expect(found, findsNothing);
    });

    testWidgets("Contains 1 kana", (WidgetTester tester) async {
      List<Kana> items = [];
      items.add(Kana(1, Alphabets.katakana, 1, "a", "a", "a"));
      await tester.pumpLocalizedWidget(KanaList(
        items: items,
      ));
      await tester.pumpAndSettle();

      final foundAllTiles = find.byType(KanaListTile);
      expect(foundAllTiles, findsOneWidget);

      var itemsTile = tester.widgetList(foundAllTiles).iterator;
      for (var i = 0; i < items.length; i++) {
        itemsTile.moveNext();
        expect((itemsTile.current as KanaListTile).data, items[i].kana);
      }
    });

    testWidgets("Contains 2 kana", (WidgetTester tester) async {
      List<Kana> items = [];
      items.add(Kana(1, Alphabets.katakana, 1, "a", "a", "a"));
      items.add(Kana(2, Alphabets.katakana, 2, "b", "b", "b"));
      await tester.pumpLocalizedWidget(KanaList(
        items: items,
      ));
      await tester.pumpAndSettle();

      final foundAllTiles = find.byType(KanaListTile);
      expect(foundAllTiles, findsNWidgets(items.length));

      var itemsTile = tester.widgetList(foundAllTiles).iterator;
      for (var i = 0; i < items.length; i++) {
        itemsTile.moveNext();
        expect((itemsTile.current as KanaListTile).data, items[i].kana);
      }
    });
  });
}
