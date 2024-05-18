import "package:flutter_test/flutter_test.dart";
import "package:infinite_scroll_pagination/infinite_scroll_pagination.dart";
import "package:kana_to_kanji/src/core/models/kanji.dart";
import "package:kana_to_kanji/src/glossary/widgets/glossary_list_tile.dart";
import "package:kana_to_kanji/src/glossary/widgets/kanji_list.dart";

import "../../../dummies/kanji.dart";
import "../../../helpers.dart";

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
      final List<Kanji> kanjiList = [dummyKanji];
      await tester.pumpLocalizedWidget(KanjiList(
        items: kanjiList,
      ));
      await tester.pumpAndSettle();
      expect(find.byType(PagedListView<int, Kanji>), findsOneWidget);

      final foundAllTiles = find.byType(GlossaryListTile);
      expect(foundAllTiles, findsOneWidget);

      final tileList = tester.widgetList(foundAllTiles).iterator;
      for (var i = 0; i < kanjiList.length; i++) {
        tileList.moveNext();
        expect((tileList.current as GlossaryListTile).kanji, kanjiList[i]);
      }
    });

    testWidgets("Contains 2 kanji", (WidgetTester tester) async {
      final List<Kanji> kanjiList = [dummyKanji, dummyKanji];

      await tester.pumpLocalizedWidget(KanjiList(
        items: kanjiList,
      ));
      await tester.pumpAndSettle();

      final foundAllTiles = find.byType(GlossaryListTile);
      expect(foundAllTiles, findsNWidgets(kanjiList.length));

      final tileList = tester.widgetList(foundAllTiles).iterator;
      for (var i = 0; i < kanjiList.length; i++) {
        tileList.moveNext();
        expect((tileList.current as GlossaryListTile).kanji, kanjiList[i]);
      }
    });
  });
}
