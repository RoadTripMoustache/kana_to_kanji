import 'package:flutter_test/flutter_test.dart';
import 'package:kana_to_kanji/src/core/models/kanji.dart';
import 'package:kana_to_kanji/src/glossary/widgets/glossary_list_tile.dart';
import 'package:kana_to_kanji/src/glossary/widgets/kanji_list.dart';

import '../../../helpers.dart';

void main() {
  group("KanjiList", () {
    testWidgets("Empty list", (WidgetTester tester) async {
      await tester.pumpLocalizedWidget(const KanjiList(
        items: [],
      ));
      await tester.pumpAndSettle();

      final found = find.byType(GlossaryListTile);
      expect(found, findsNothing);
    });

    testWidgets("Contains 1 kanji", (WidgetTester tester) async {
      List<Kanji> kanjiList = [];
      kanjiList.add(Kanji(1, "a", 1, 1, 1, [], [], [], "a", []));
      await tester.pumpLocalizedWidget(KanjiList(
        items: kanjiList,
      ));
      await tester.pumpAndSettle();

      final foundAllTiles = find.byType(GlossaryListTile);
      expect(foundAllTiles, findsOneWidget);

      var tileList = tester.widgetList(foundAllTiles).iterator;
      for (var i = 0; i < kanjiList.length; i++) {
        tileList.moveNext();
        expect((tileList.current as GlossaryListTile).kanji, kanjiList[i].kanji);
      }
    });

    testWidgets("Contains 2 kanji", (WidgetTester tester) async {
      List<Kanji> kanjiList = [];
      kanjiList.add(Kanji(1, "a", 1, 1, 1, [], [], [], "a", []));
      kanjiList.add(Kanji(2, "b", 2, 2, 2, [], [], [], "b", []));
      await tester.pumpLocalizedWidget(KanjiList(
        items: kanjiList,
      ));
      await tester.pumpAndSettle();

      final foundAllTiles = find.byType(GlossaryListTile);
      expect(foundAllTiles, findsNWidgets(kanjiList.length));

      var tileList = tester.widgetList(foundAllTiles).iterator;
      for (var i = 0; i < kanjiList.length; i++) {
        tileList.moveNext();
        expect((tileList.current as GlossaryListTile).kanji, kanjiList[i].kanji);
      }
    });
  });
}
