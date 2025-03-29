import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/constants/app_theme.dart";
import "package:kana_to_kanji/src/glossary/details/details_view.dart";
import "package:kana_to_kanji/src/glossary/details/widgets/details.dart";

import "../../../dummies/kana.dart";
import "../../../dummies/kanji.dart";
import "../../../dummies/vocabulary.dart";
import "../../../helpers.dart";

void main() {
  group("DetailsView", () {
    Future<Finder> pump(WidgetTester tester, Widget widget) async {
      await tester.pumpLocalizedWidget(widget);
      await tester.pumpAndSettle();

      return find.byType(DetailsView);
    }

    testWidgets("Should only accept Kana, Kanji, and Vocabulary", (
      WidgetTester tester,
    ) async {
      expect(() async {
        await pump(tester, DetailsView(item: 0));
      }, throwsAssertionError);
      expect(() async {
        await pump(tester, DetailsView(item: ""));
      }, throwsAssertionError);
    });

    testWidgets("Kana", (WidgetTester tester) async {
      await pump(tester, const DetailsView(item: dummyHiragana));
      final theme = AppTheme.lightTheme;

      // Check title section
      final title = find.text(dummyHiragana.kana);
      expect(title, findsOneWidget);
      expect(
        find.ancestor(
          of: title,
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is ColoredBox &&
                widget.color ==
                    AppTheme.getModalBottomSheetBackgroundColor(theme),
          ),
        ),
        findsOneWidget,
      );

      // Check details
      final details = find.byType(Details);
      expect(details, findsOneWidget);
      expect(
        find.descendant(of: details, matching: find.text(dummyHiragana.romaji)),
        findsOneWidget,
      );
    });

    testWidgets("Kanji", (WidgetTester tester) async {
      final theme = AppTheme.lightTheme;
      await pump(tester, const DetailsView(item: dummyKanji));

      // Check title section
      final titleContainer = find.byWidgetPredicate(
        (widget) =>
            widget is ColoredBox &&
            widget.color == AppTheme.getModalBottomSheetBackgroundColor(theme),
      );
      expect(titleContainer, findsOneWidget);
      expect(
        find.descendant(
          of: titleContainer,
          matching: find.text(dummyKanji.kanji),
        ),
        findsOneWidget,
      );

      // Check details
      final details = find.byType(Details);
      expect(details, findsOneWidget);
      expect(
        find.descendant(
          of: details,
          matching: find.text(dummyKanji.meanings[0]),
        ),
        findsOneWidget,
      );
    });

    group("Vocabulary", () {
      testWidgets("With kanji", (WidgetTester tester) async {
        final theme = AppTheme.lightTheme;
        await pump(tester, const DetailsView(item: dummyVocabulary));

        // Check title section
        final titleContainer = find.byWidgetPredicate(
          (widget) =>
              widget is ColoredBox &&
              widget.color ==
                  AppTheme.getModalBottomSheetBackgroundColor(theme),
        );
        expect(titleContainer, findsOneWidget);
        expect(
          find.descendant(
            of: titleContainer,
            matching: find.text(dummyVocabulary.kanji),
          ),
          findsOneWidget,
        );

        // Check details
        final details = find.byType(Details);
        expect(details, findsOneWidget);
        expect(
          find.descendant(
            of: details,
            matching: find.text(dummyVocabulary.kana),
          ),
          findsOneWidget,
        );
      });

      testWidgets("Without kanji", (WidgetTester tester) async {
        final theme = AppTheme.lightTheme;
        await pump(
          tester,
          const DetailsView(item: dummyVocabularyWithoutKanji),
        );

        // Check title section
        final titleContainer = find.byWidgetPredicate(
          (widget) =>
              widget is ColoredBox &&
              widget.color ==
                  AppTheme.getModalBottomSheetBackgroundColor(theme),
        );
        expect(titleContainer, findsOneWidget);
        expect(
          find.descendant(
            of: titleContainer,
            matching: find.text(dummyVocabularyWithoutKanji.kana),
          ),
          findsOneWidget,
        );

        // Check details
        final details = find.byType(Details);
        expect(details, findsOneWidget);
        expect(
          find.descendant(
            of: details,
            matching: find.text(dummyVocabularyWithoutKanji.kana),
          ),
          findsOneWidget,
        );
      });
    });
  });
}
