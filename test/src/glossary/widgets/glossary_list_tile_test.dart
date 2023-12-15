import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kana_to_kanji/src/core/models/kanji.dart';
import 'package:kana_to_kanji/src/core/models/vocabulary.dart';
import 'package:kana_to_kanji/src/glossary/widgets/glossary_list_tile.dart';

import '../../../helpers.dart';

void main() {
  group("GlossaryListTile", () {
    const Kanji kanji =
        Kanji(1, "本", 5, 5, 5, ["book"], [], ["ほん"], "2023-12-1", []);

    Future<Finder> pump(WidgetTester tester, Widget widget) async {
      await tester.pumpLocalizedWidget(widget);
      await tester.pumpAndSettle();

      return find.byType(GlossaryListTile);
    }

    group("UI", () {
      testWidgets("Kanji", (WidgetTester tester) async {
        final AppLocalizations l10n = await setupLocalizations();

        final widget = await pump(tester, GlossaryListTile.kanji(kanji));

        expect(find.descendant(of: widget, matching: find.text(kanji.kanji)),
            findsOneWidget,
            reason: "Main text should be a kanji");
        expect(
            find.descendant(
                of: widget, matching: find.text(kanji.kunReadings[0])),
            findsOneWidget,
            reason:
                "If showFurigana is true, the furigana should be displayed when available");
        expect(
            find.descendant(
                of: widget,
                matching: find
                    .text(l10n.glossary_tile_meanings(kanji.meanings[0], 0))),
            findsOneWidget,
            reason: "Kanji first meaning should be displayed");
        final badge = find.byType(Badge);
        expect(find.descendant(of: widget, matching: badge), findsOneWidget);
        expect(
            find.descendant(
                of: badge,
                matching: find.text(l10n.jlpt_level_short(kanji.jlptLevel))),
            findsOneWidget,
            reason: "Kanji JLPT level should be displayed on the first badge");
      });

      testWidgets("Vocabulary", (WidgetTester tester) async {
        const vocabulary =
            Vocabulary(1, "亜", "あ", 1, ["inferior"], "a", [], "2023-12-1");
        final AppLocalizations l10n = await setupLocalizations();

        final widget =
            await pump(tester, GlossaryListTile.vocabulary(vocabulary));

        expect(
            find.descendant(of: widget, matching: find.text(vocabulary.kanji)),
            findsOneWidget,
            reason: "Main text should be a kanji");
        expect(
            find.descendant(
                of: widget, matching: find.text(vocabulary.kana[0])),
            findsOneWidget,
            reason:
                "If showFurigana is true, the furigana should be displayed when available");
        expect(
            find.descendant(
                of: widget,
                matching: find.text(
                    l10n.glossary_tile_meanings(vocabulary.meanings[0], 0))),
            findsOneWidget,
            reason: "Kanji first meaning should be displayed");
        final badge = find.byType(Badge);
        expect(find.descendant(of: widget, matching: badge), findsOneWidget);
        expect(
            find.descendant(
                of: badge,
                matching:
                    find.text(l10n.jlpt_level_short(vocabulary.jlptLevel))),
            findsOneWidget,
            reason:
                "Vocabulary JLPT level should be displayed on the first badge");
      });
    });

    group("Interactions", () {
      final List<int> log = [];

      setUp(() {
        log.clear();
      });

      testWidgets("onPressed", (WidgetTester tester) async {
        final widget = await pump(
            tester,
            GlossaryListTile(
                meanings: const ["book"],
                jlptLevel: 1,
                kanji: kanji,
                onPressed: () {
                  log.add(kanji.id);
                }));

        final iconButton = find.descendant(
            of: widget, matching: find.byIcon(Icons.chevron_right_rounded));

        expect(iconButton, findsOneWidget,
            reason:
                "As onPressed is provided, the icon button should be present");

        await tester.tap(iconButton);
        await tester.pumpAndSettle();

        expect(log.length, 1, reason: "onPressed should have been called");
      });
    });
  });
}
