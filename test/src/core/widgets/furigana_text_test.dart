import "package:flutter/cupertino.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/widgets/furigana_text.dart";

import "../../../dummies/kanji.dart";
import "../../../dummies/vocabulary.dart";
import "../../../helpers.dart";

void main() {
  group("FuriganaText", () {
    Future<Finder> pump(WidgetTester tester, Widget widget) async {
      await tester.pumpLocalizedWidget(widget);
      await tester.pumpAndSettle();

      return find.byType(FuriganaText);
    }

    group("Furigana", () {
      const text = "本";
      const furigana = "ほん";

      testWidgets("Should show furigana if provided and showFurigana true", (
        WidgetTester tester,
      ) async {
        final widget = await pump(
          tester,
          const FuriganaText(
            text: text,
            furigana: furigana,
            showFurigana: true,
          ),
        );

        expect(widget, findsOneWidget);
        expect(
          find.descendant(of: widget, matching: find.text(text)),
          findsOneWidget,
        );
        expect(
          find.descendant(of: widget, matching: find.text(furigana)),
          findsOneWidget,
          reason: "Furigana should be showed",
        );
      });

      testWidgets("Should not show furigana if showFurigana false", (
        WidgetTester tester,
      ) async {
        final widget = await pump(
          tester,
          const FuriganaText(text: text, furigana: furigana),
        );

        expect(widget, findsOneWidget);
        expect(
          find.descendant(of: widget, matching: find.byType(Column)),
          findsNothing,
          reason: "Only present when furigana is showed",
        );
        expect(
          find.descendant(of: widget, matching: find.text(text)),
          findsOneWidget,
        );
        expect(
          find.descendant(of: widget, matching: find.text(furigana)),
          findsNothing,
          reason: "Furigana should not be showed",
        );
      });

      testWidgets("Should not show furigana if not provided", (
        WidgetTester tester,
      ) async {
        final widget = await pump(
          tester,
          const FuriganaText(text: text, showFurigana: true),
        );

        expect(widget, findsOneWidget);
        expect(
          find.descendant(of: widget, matching: find.byType(Column)),
          findsNothing,
          reason: "Only present when furigana is showed",
        );
        expect(
          find.descendant(of: widget, matching: find.text(text)),
          findsOneWidget,
        );
        expect(
          find.descendant(of: widget, matching: find.text(furigana)),
          findsNothing,
          reason: "Furigana should not be showed",
        );
      });

      testWidgets("Furigana default size should be 12", (
        WidgetTester tester,
      ) async {
        final widget = await pump(
          tester,
          const FuriganaText(
            text: text,
            furigana: furigana,
            showFurigana: true,
          ),
        );

        final furiganaTextFound = find.descendant(
          of: widget,
          matching: find.text(furigana),
        );
        final furiganaTextWidget =
            tester.firstWidget(furiganaTextFound) as Text;

        expect(furiganaTextFound, findsOneWidget);
        expect(furiganaTextWidget.style!.fontSize, 12);
      });
    });

    group("Factories constructor", () {
      group("Kanji", () {
        testWidgets("Kun reading should be used if available", (
          WidgetTester tester,
        ) async {
          final widget = await pump(
            tester,
            FuriganaText.kanji(dummyKanji, showFurigana: true),
          );

          expect(
            find.descendant(
              of: widget,
              matching: find.text(dummyKanji.kunReadings[0]),
            ),
            findsOneWidget,
            reason:
                "When furigana isn't precised and kun reading are available, "
                "the first kun reading should be used as furigana",
          );
          expect(
            find.descendant(of: widget, matching: find.text(dummyKanji.kanji)),
            findsOneWidget,
            reason: "Kanji should be used as main text",
          );
        });

        testWidgets("On reading should be used if there is no kun reading", (
          WidgetTester tester,
        ) async {
          final widget = await pump(
            tester,
            FuriganaText.kanji(dummyKanjiWithoutOnMeaning, showFurigana: true),
          );

          expect(
            find.descendant(
              of: widget,
              matching: find.text(dummyKanjiWithoutOnMeaning.onReadings[0]),
            ),
            findsOneWidget,
            reason:
                "When furigana isn't precised and kun reading unavailable, "
                "the first on reading should be used as furigana",
          );
          expect(
            find.descendant(
              of: widget,
              matching: find.text(dummyKanjiWithoutOnMeaning.kanji),
            ),
            findsOneWidget,
            reason: "Kanji should be used as main text",
          );
        });

        testWidgets("Furigana should be override", (WidgetTester tester) async {
          const furiganaOverride = "あ";

          final widget = await pump(
            tester,
            FuriganaText.kanji(
              dummyKanji,
              furigana: furiganaOverride,
              showFurigana: true,
            ),
          );

          expect(
            find.descendant(of: widget, matching: find.text(furiganaOverride)),
            findsOneWidget,
            reason:
                "When furigana is precised, it should override "
                "kun and on reading",
          );
          expect(
            find.descendant(of: widget, matching: find.text(dummyKanji.kanji)),
            findsOneWidget,
            reason: "Kanji should be used as main text",
          );
        });
      });

      group("Vocabulary", () {
        testWidgets("Should have main text and furigana", (
          WidgetTester tester,
        ) async {
          final widget = await pump(
            tester,
            FuriganaText.vocabulary(dummyVocabulary),
          );

          expect(
            find.descendant(
              of: widget,
              matching: find.text(dummyVocabulary.kana),
            ),
            findsOneWidget,
            reason:
                "Kana should always be used as furigana "
                "if kanji isn't empty",
          );
          expect(
            find.descendant(
              of: widget,
              matching: find.text(dummyVocabulary.kanji),
            ),
            findsOneWidget,
            reason: "Kanji should be use as main text when available",
          );
        });

        testWidgets("Should only have main text", (WidgetTester tester) async {
          final widget = await pump(
            tester,
            FuriganaText.vocabulary(dummyVocabularyWithoutKanji),
          );

          expect(
            find.descendant(of: widget, matching: find.byType(Text)),
            findsOneWidget,
            reason: "Should only have one text meaning no furigana",
          );
          expect(
            find.descendant(
              of: widget,
              matching: find.text(dummyVocabularyWithoutKanji.kana),
            ),
            findsOneWidget,
            reason: "Kana should be use as main text when kanji is empty",
          );
        });
      });
    });
  });
}
