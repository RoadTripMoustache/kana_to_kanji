import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/glossary/widgets/glossary_list_tile.dart";

import "../../../dummies/kanji.dart";
import "../../../dummies/vocabulary.dart";
import "../../../helpers.dart";

void main() {
  group("GlossaryListTile", () {
    Future<Finder> pump(WidgetTester tester, Widget widget) async {
      await tester.pumpLocalizedWidget(widget);
      await tester.pumpAndSettle();

      return find.byType(GlossaryListTile);
    }

    group("UI", () {
      testWidgets("Kanji", (WidgetTester tester) async {
        final AppLocalizations l10n = await setupLocalizations();

        final widget = await pump(tester, GlossaryListTile.kanji(dummyKanji));

        expect(
          find.descendant(of: widget, matching: find.text(dummyKanji.kanji)),
          findsOneWidget,
          reason: "Main text should be a kanji",
        );
        expect(
          find.descendant(
            of: widget,
            matching: find.text(dummyKanji.kunReadings[0]),
          ),
          findsOneWidget,
          reason:
              "If showFurigana is true, the furigana should be displayed "
              "when available",
        );
        expect(
          find.descendant(
            of: widget,
            matching: find.text(
              l10n.glossary_tile_meanings(dummyKanji.meanings[0], 0),
            ),
          ),
          findsOneWidget,
          reason: "Kanji first meaning should be displayed",
        );
        final badge = find.byType(Badge);
        expect(find.descendant(of: widget, matching: badge), findsOneWidget);
        expect(
          find.descendant(
            of: badge,
            matching: find.text(l10n.jlpt_level_short(dummyKanji.jlptLevel)),
          ),
          findsOneWidget,
          reason: "Kanji JLPT level should be displayed on the first badge",
        );
      });

      testWidgets("Vocabulary", (WidgetTester tester) async {
        final AppLocalizations l10n = await setupLocalizations();

        final widget = await pump(
          tester,
          GlossaryListTile.vocabulary(dummyVocabulary),
        );

        expect(
          find.descendant(
            of: widget,
            matching: find.text(dummyVocabulary.kanji),
          ),
          findsOneWidget,
          reason: "Main text should be a kanji",
        );
        expect(
          find.descendant(
            of: widget,
            matching: find.text(dummyVocabulary.kana[0]),
          ),
          findsOneWidget,
          reason:
              "If showFurigana is true, the furigana should be displayed "
              "when available",
        );
        expect(
          find.descendant(
            of: widget,
            matching: find.text(
              l10n.glossary_tile_meanings(dummyVocabulary.meanings[0], 0),
            ),
          ),
          findsOneWidget,
          reason: "Kanji first meaning should be displayed",
        );
        final badge = find.byType(Badge);
        expect(find.descendant(of: widget, matching: badge), findsOneWidget);
        expect(
          find.descendant(
            of: badge,
            matching: find.text(
              l10n.jlpt_level_short(dummyVocabulary.jlptLevel),
            ),
          ),
          findsOneWidget,
          reason:
              "Vocabulary JLPT level should be displayed on the first badge",
        );
      });
    });

    group("Interactions", () {
      final List<int> log = [];

      setUp(log.clear);

      testWidgets("onTap", (WidgetTester tester) async {
        final widget = await pump(
          tester,
          GlossaryListTile(
            meanings: dummyKanji.meanings,
            jlptLevel: 1,
            kanji: dummyKanji,
            onTap: () {
              log.add(dummyKanji.id);
            },
          ),
        );

        await tester.tap(widget);
        await tester.pumpAndSettle();

        expect(log.length, 1, reason: "onTap should have been called");
      });
    });
  });
}
