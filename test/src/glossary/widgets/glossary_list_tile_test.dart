import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/constants/jlpt_levels.dart";
import "package:kana_to_kanji/src/glossary/widgets/glossary_list_tile.dart";

import "../../../dummies/dummies.dart";
import "../../../helpers.dart";

void main() {
  group("GlossaryListTile", () {
    int onTapCallCount = 0;

    void mockOnTap() {
      onTapCallCount++;
    }

    tearDown(() {
      onTapCallCount = 0;
    });

    testWidgets("Should display kanji information correctly", (
      WidgetTester tester,
    ) async {
      await tester.pumpLocalizedWidget(GlossaryListTile.kanji(dummyKanji));
      await tester.pumpAndSettle();

      // Verify kanji is displayed
      expect(find.text(dummyKanji.kanji), findsOneWidget);

      // Verify JLPT level is displayed
      final l10n = await setupLocalizations();
      expect(
        find.text(l10n.jlpt_level_short(dummyKanji.jlptLevel)),
        findsOneWidget,
      );

      // Verify meaning is displayed
      expect(find.textContaining(dummyKanji.meanings.first), findsOneWidget);

      // Verify JLPT level color
      final trailingText = tester.widget<Text>(
        find.text(l10n.jlpt_level_short(dummyKanji.jlptLevel)),
      );
      expect(
        trailingText.style?.color,
        equals(JLPTLevelColors.level(dummyKanji.jlptLevel)),
      );
    });

    testWidgets("Should display vocabulary information correctly", (
      WidgetTester tester,
    ) async {
      await tester.pumpLocalizedWidget(
        GlossaryListTile.vocabulary(dummyVocabulary),
      );
      await tester.pumpAndSettle();

      // Verify vocabulary is displayed
      expect(find.text(dummyVocabulary.japanese), findsOneWidget);

      // Verify JLPT level is displayed
      final l10n = await setupLocalizations();
      expect(
        find.text(l10n.jlpt_level_short(dummyVocabulary.jlptLevel)),
        findsOneWidget,
      );

      // Verify meaning is displayed
      expect(
        find.textContaining(dummyVocabulary.meanings.first),
        findsOneWidget,
      );

      // Verify JLPT level color
      final trailingText = tester.widget<Text>(
        find.text(l10n.jlpt_level_short(dummyVocabulary.jlptLevel)),
      );
      expect(
        trailingText.style?.color,
        equals(JLPTLevelColors.level(dummyVocabulary.jlptLevel)),
      );
    });

    testWidgets("Should call onTap when tapped", (WidgetTester tester) async {
      await tester.pumpLocalizedWidget(
        GlossaryListTile.kanji(dummyKanji, onPressed: mockOnTap),
      );
      await tester.pumpAndSettle();

      // Tap the tile
      await tester.tap(find.byType(GlossaryListTile));
      await tester.pumpAndSettle();

      // Verify onTap was called
      expect(onTapCallCount, 1);
    });

    testWidgets("Should not call onTap when onTap is null", (
      WidgetTester tester,
    ) async {
      await tester.pumpLocalizedWidget(GlossaryListTile.kanji(dummyKanji));
      await tester.pumpAndSettle();

      // Tap the tile
      await tester.tap(find.byType(GlossaryListTile));
      await tester.pumpAndSettle();

      // Verify onTap was not called
      expect(onTapCallCount, 0);
    });
  });
}
