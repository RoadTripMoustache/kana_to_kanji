import 'package:flutter_test/flutter_test.dart';
import 'package:kana_to_kanji/src/core/models/vocabulary.dart';
import 'package:kana_to_kanji/src/glossary/widgets/vocabulary_list.dart';
import 'package:kana_to_kanji/src/glossary/widgets/vocabulary_list_tile.dart';

import '../../../helpers.dart';

void main() {
  group("VocabularyList", () {
    testWidgets("Empty list", (WidgetTester tester) async {
      await tester.pumpLocalizedWidget(const VocabularyList(
        items: [],
      ));
      await tester.pumpAndSettle();

      final found = find.byType(VocabularyListTile);
      expect(found, findsNothing);
    });

    testWidgets("Contains 1 kanji", (WidgetTester tester) async {
      List<Vocabulary> vocabularyList = [];
      vocabularyList.add(Vocabulary(1, "a", "a", 1, [], "a", [], "a"));
      await tester.pumpLocalizedWidget(VocabularyList(
        items: vocabularyList,
      ));
      await tester.pumpAndSettle();

      final foundAllTiles = find.byType(VocabularyListTile);
      expect(foundAllTiles, findsNWidgets(vocabularyList.length));

      var tileList = tester.widgetList(foundAllTiles).iterator;
      for (var i = 0; i < vocabularyList.length; i++) {
        tileList.moveNext();
        expect((tileList.current as VocabularyListTile).data,
            vocabularyList[i].kanji);
      }
    });

    testWidgets("Contains 2 kanji", (WidgetTester tester) async {
      List<Vocabulary> vocabularyList = [];
      vocabularyList.add(Vocabulary(1, "a", "a", 1, [], "a", [], "a"));
      vocabularyList.add(Vocabulary(2, "b", "b", 2, [], "b", [], "b"));
      await tester.pumpLocalizedWidget(VocabularyList(
        items: vocabularyList,
      ));
      await tester.pumpAndSettle();

      final foundAllTiles = find.byType(VocabularyListTile);
      expect(foundAllTiles, findsNWidgets(vocabularyList.length));

      var tileList = tester.widgetList(foundAllTiles).iterator;
      for (var i = 0; i < vocabularyList.length; i++) {
        tileList.moveNext();
        expect((tileList.current as VocabularyListTile).data,
            vocabularyList[i].kanji);
      }
    });
  });
}
