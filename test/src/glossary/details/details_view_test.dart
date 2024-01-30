import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kana_to_kanji/src/core/constants/alphabets.dart';
import 'package:kana_to_kanji/src/core/constants/app_theme.dart';
import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/core/models/kanji.dart';
import 'package:kana_to_kanji/src/core/models/vocabulary.dart';
import 'package:kana_to_kanji/src/glossary/details/details_view.dart';
import 'package:kana_to_kanji/src/glossary/details/widgets/details.dart';

import '../../../helpers.dart';

void main() {
  group("DetailsView", () {
    const kanaSample = Kana(0, Alphabets.hiragana, 0, "あ", "a", "2023-12-01");

    Future<Finder> pump(WidgetTester tester, Widget widget) async {
      await tester.pumpLocalizedWidget(widget);
      await tester.pumpAndSettle();

      return find.byType(DetailsView);
    }

    testWidgets("Kana", (WidgetTester tester) async {
      await pump(tester, const DetailsView(item: kanaSample));
      final theme = AppTheme.light();

      // Check title section
      final title = find.text(kanaSample.kana);
      expect(title, findsOneWidget);
      expect(
          find.ancestor(
              of: title,
              matching: find.byWidgetPredicate((widget) =>
                  widget is Container &&
                  widget.color ==
                      AppTheme.getModalBottomSheetBackgroundColor(theme))),
          findsOneWidget);

      // Check details
      final details = find.byType(Details);
      expect(details, findsOneWidget);
      expect(
          find.descendant(of: details, matching: find.text(kanaSample.romaji)),
          findsOneWidget);
    });

    testWidgets("Kanji", (WidgetTester tester) async {
      final theme = AppTheme.light();
      const kanjiSample =
      Kanji(1, "本", 5, 5, 5, ["book"], [], ["ほん"], "2023-12-1", [], []);
      await pump(tester, const DetailsView(item: kanjiSample));

      // Check title section
      final titleContainer = find.byWidgetPredicate((widget) =>
      widget is Container &&
          widget.color == AppTheme.getModalBottomSheetBackgroundColor(theme));
      expect(titleContainer, findsOneWidget);
      expect(
          find.descendant(
              of: titleContainer, matching: find.text(kanjiSample.kanji)),
          findsOneWidget);

      // Check details
      final details = find.byType(Details);
      expect(details, findsOneWidget);
      expect(
          find.descendant(
              of: details, matching: find.text(kanjiSample.meanings[0])),
          findsOneWidget);
    });

    group("Vocabulary", () {
      testWidgets("With kanji", (WidgetTester tester) async {
        final theme = AppTheme.light();
        const vocabularySample =
            Vocabulary(1, "亜", "あ", 1, ["inferior"], "a", [], "2023-12-1", []);
        await pump(tester, const DetailsView(item: vocabularySample));

        // Check title section
        final titleContainer = find.byWidgetPredicate((widget) =>
        widget is Container &&
            widget.color == AppTheme.getModalBottomSheetBackgroundColor(theme));
        expect(titleContainer, findsOneWidget);
        expect(
            find.descendant(
                of: titleContainer, matching: find.text(vocabularySample.kanji)),
            findsOneWidget);

        // Check details
        final details = find.byType(Details);
        expect(details, findsOneWidget);
        expect(
            find.descendant(
                of: details, matching: find.text(vocabularySample.kana)),
            findsOneWidget);
      });

      testWidgets("Without kanji", (WidgetTester tester) async {
        final theme = AppTheme.light();
        const vocabularySample =
            Vocabulary(1, "", "あ", 1, ["inferior"], "a", [], "2023-12-1", []);
        await pump(tester, const DetailsView(item: vocabularySample));

        // Check title section
        final titleContainer = find.byWidgetPredicate((widget) =>
            widget is Container &&
            widget.color == AppTheme.getModalBottomSheetBackgroundColor(theme));
        expect(titleContainer, findsOneWidget);
        expect(
            find.descendant(
                of: titleContainer, matching: find.text(vocabularySample.kana)),
            findsOneWidget);

        // Check details
        final details = find.byType(Details);
        expect(details, findsOneWidget);
        expect(
            find.descendant(
                of: details, matching: find.text(vocabularySample.kana)),
            findsOneWidget);
      });
    });
  });
}
