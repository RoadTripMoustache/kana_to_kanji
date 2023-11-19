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
        dataList: [],
      ));
      await tester.pumpAndSettle();

      final found = find.byType(KanaListTile);
      expect(found, findsNothing);
    });

    testWidgets("Contains 1 kana", (WidgetTester tester) async {
      List<Kana> kanaList = [];
      kanaList.add(Kana(1, Alphabets.katakana, 1, "a", "a", "a"));
      await tester.pumpLocalizedWidget(KanaList(
        dataList: kanaList,
      ));
      await tester.pumpAndSettle();

      final foundAllTiles = find.byType(KanaListTile);
      expect(foundAllTiles, findsOneWidget);

      var kanaListTile = tester.widgetList(foundAllTiles).iterator;
      for (var i = 0; i < kanaList.length; i++) {
        kanaListTile.moveNext();
        expect((kanaListTile.current as KanaListTile).data, kanaList[i].kana);
      }
    });

    testWidgets("Contains 2 kana", (WidgetTester tester) async {
      List<Kana> kanaList = [];
      kanaList.add(Kana(1, Alphabets.katakana, 1, "a", "a", "a"));
      kanaList.add(Kana(2, Alphabets.katakana, 2, "b", "b", "b"));
      await tester.pumpLocalizedWidget(KanaList(
        dataList: kanaList,
      ));
      await tester.pumpAndSettle();

      final foundAllTiles = find.byType(KanaListTile);
      expect(foundAllTiles, findsNWidgets(kanaList.length));

      var kanaListTile = tester.widgetList(foundAllTiles).iterator;
      for (var i = 0; i < kanaList.length; i++) {
        kanaListTile.moveNext();
        expect((kanaListTile.current as KanaListTile).data, kanaList[i].kana);
      }
    });
  });
}
