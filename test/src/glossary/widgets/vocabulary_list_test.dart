import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kana_to_kanji/src/core/models/vocabulary.dart';
import 'package:kana_to_kanji/src/glossary/widgets/glossary_list_tile.dart';
import 'package:kana_to_kanji/src/glossary/widgets/vocabulary_list.dart';

import '../../../helpers.dart';

void main() {
  group("VocabularyList", () {
    const vocabulary =
        Vocabulary(1, "亜", "あ", 1, ["inferior"], "a", [], "2023-12-1", ["a"], []);

    testWidgets("Empty list", (WidgetTester tester) async {
      await tester.pumpLocalizedWidget(const VocabularyList(
        items: [],
      ));
      await tester.pumpAndSettle();

      final found = find.byType(GlossaryListTile);
      expect(found, findsNothing);
    });

    testWidgets("Contains 1 item", (WidgetTester tester) async {
      List<Vocabulary> vocabularyList = [vocabulary];

      await tester.pumpLocalizedWidget(VocabularyList(
        items: vocabularyList,
      ));
      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsOneWidget);

      final foundAllTiles = find.byType(GlossaryListTile);
      expect(foundAllTiles, findsNWidgets(vocabularyList.length));

      var tileList = tester.widgetList(foundAllTiles).iterator;
      for (var i = 0; i < vocabularyList.length; i++) {
        tileList.moveNext();
        expect((tileList.current as GlossaryListTile).vocabulary,
            vocabularyList[i]);
      }
    });

    testWidgets("Contains 2 items", (WidgetTester tester) async {
      List<Vocabulary> vocabularyList = [
        vocabulary,
        const Vocabulary(2, "亜", "あ", 1, ["inferior"], "a", [], "2023-12-1", [], [])
      ];
      await tester.pumpLocalizedWidget(VocabularyList(
        items: vocabularyList,
      ));
      await tester.pumpAndSettle();

      final foundAllTiles = find.byType(GlossaryListTile);
      expect(foundAllTiles, findsNWidgets(vocabularyList.length));

      var tileList = tester.widgetList(foundAllTiles).iterator;
      for (var i = 0; i < vocabularyList.length; i++) {
        tileList.moveNext();
        expect((tileList.current as GlossaryListTile).vocabulary,
            vocabularyList[i]);
      }
    });
  });
}
