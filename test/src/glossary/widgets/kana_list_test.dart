import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/constants/alphabets.dart";
import "package:kana_to_kanji/src/core/constants/kana_type.dart";
import "package:kana_to_kanji/src/core/models/resources/kana.dart";
import "package:kana_to_kanji/src/core/models/resources/resource_uid.dart";
import "package:kana_to_kanji/src/glossary/constants.dart";
import "package:kana_to_kanji/src/glossary/widgets/kana_list.dart";
import "package:kana_to_kanji/src/glossary/widgets/kana_tile.dart";

import "../../../dummies/dummies.dart";
import "../../../helpers.dart";

void main() {
  group("KanaList", () {
    int onPressedCallCount = 0;
    Kana? lastPressedKana;

    void mockOnPressed(Kana kana) {
      onPressedCallCount++;
      lastPressedKana = kana;
    }

    tearDown(() {
      onPressedCallCount = 0;
      lastPressedKana = null;
    });

    // Create dummy kana for each type
    final mainKana = dummyHiragana;
    final dakutenKana = Kana(
      uid: ResourceUid.fromJson("kana-dakuten"),
      alphabet: Alphabets.hiragana,
      groupUid: ResourceUid.fromJson("group-kana_hiragana"),
      kana: "が",
      romaji: "ga",
      version: "2025_01_01",
      position: 2,
    );
    final combinationKana = Kana(
      uid: ResourceUid.fromJson("kana-combination"),
      alphabet: Alphabets.hiragana,
      groupUid: ResourceUid.fromJson("group-kana_hiragana"),
      kana: "きゃ",
      romaji: "kya",
      version: "2025_01_01",
      position: 3,
    );

    // Create a KanaMap with all types
    final kanaMap = <KanaTypes, List<KanaDisabled>>{
      KanaTypes.main: [(kana: mainKana, disabled: false)],
      KanaTypes.dakuten: [(kana: dakutenKana, disabled: false)],
      KanaTypes.combination: [(kana: combinationKana, disabled: false)],
    };

    // Create a KanaMap with some disabled kana
    final kanaMapWithDisabled = <KanaTypes, List<KanaDisabled>>{
      KanaTypes.main: [(kana: mainKana, disabled: true)],
      KanaTypes.dakuten: [(kana: dakutenKana, disabled: false)],
      KanaTypes.combination: [(kana: combinationKana, disabled: true)],
    };

    testWidgets("Should display kana items in each section", (
      WidgetTester tester,
    ) async {
      await tester.pumpLocalizedWidget(
        KanaList(items: kanaMap, onPressed: mockOnPressed),
      );
      await tester.pumpAndSettle();

      // Verify main kana is displayed
      expect(find.text(mainKana.kana), findsOneWidget);
      expect(find.text(mainKana.romaji), findsOneWidget);

      // Verify dakuten kana is displayed
      expect(find.text(dakutenKana.kana), findsOneWidget);
      expect(find.text(dakutenKana.romaji), findsOneWidget);

      // Verify combination kana is displayed
      expect(find.text(combinationKana.kana), findsOneWidget);
      expect(find.text(combinationKana.romaji), findsOneWidget);

      // Verify section headers are displayed
      final l10n = await setupLocalizations();
      expect(find.text(l10n.dakuten_kana), findsOneWidget);
      expect(find.text(l10n.combination_kana), findsOneWidget);
    });

    testWidgets("Should call onPressed when a kana is tapped", (
      WidgetTester tester,
    ) async {
      await tester.pumpLocalizedWidget(
        KanaList(items: kanaMap, onPressed: mockOnPressed),
      );
      await tester.pumpAndSettle();

      // Tap the main kana
      await tester.tap(find.text(mainKana.kana));
      await tester.pumpAndSettle();

      // Verify onPressed was called with the correct kana
      expect(onPressedCallCount, 1);
      expect(lastPressedKana, equals(mainKana));

      // Reset
      onPressedCallCount = 0;
      lastPressedKana = null;

      // Tap the dakuten kana
      await tester.tap(find.text(dakutenKana.kana));
      await tester.pumpAndSettle();

      // Verify onPressed was called with the correct kana
      expect(onPressedCallCount, 1);
      expect(lastPressedKana, equals(dakutenKana));
    });

    testWidgets("Should not call onPressed for disabled kana", (
      WidgetTester tester,
    ) async {
      await tester.pumpLocalizedWidget(
        KanaList(items: kanaMapWithDisabled, onPressed: mockOnPressed),
      );
      await tester.pumpAndSettle();

      // Tap the disabled main kana
      await tester.tap(find.text(mainKana.kana));
      await tester.pumpAndSettle();

      // Verify onPressed was not called
      expect(onPressedCallCount, 0);
      expect(lastPressedKana, isNull);

      // Tap the enabled dakuten kana
      await tester.tap(find.text(dakutenKana.kana));
      await tester.pumpAndSettle();

      // Verify onPressed was called with the correct kana
      expect(onPressedCallCount, 1);
      expect(lastPressedKana, equals(dakutenKana));
    });

    testWidgets("Should have different styling for disabled kana", (
      WidgetTester tester,
    ) async {
      await tester.pumpLocalizedWidget(
        KanaList(items: kanaMapWithDisabled, onPressed: mockOnPressed),
      );
      await tester.pumpAndSettle();

      // Find all KanaTile widgets
      final kanaTiles = tester.widgetList<KanaTile>(find.byType(KanaTile));

      // Verify the main kana tile is disabled
      final mainKanaTile = kanaTiles.firstWhere(
        (tile) => tile.kana.kana == mainKana.kana,
      );
      expect(mainKanaTile.disabled, isTrue);

      // Verify the dakuten kana tile is enabled
      final dakutenKanaTile = kanaTiles.firstWhere(
        (tile) => tile.kana.kana == dakutenKana.kana,
      );
      expect(dakutenKanaTile.disabled, isFalse);
    });
  });
}
