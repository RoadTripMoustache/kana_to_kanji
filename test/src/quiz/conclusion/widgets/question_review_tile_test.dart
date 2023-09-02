import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kana_to_kanji/src/core/constants/alphabets.dart';
import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/quiz/conclusion/widgets/question_review_tile.dart';
import 'package:kana_to_kanji/src/quiz/constants/question_types.dart';
import 'package:kana_to_kanji/src/quiz/models/question.dart';

import '../../../../helpers.dart';

void main() {
  group("QuestionReviewTile", () {
    group("Question is about kana", () {
      final Kana kana = Kana(
          0,
          Alphabets.hiragana,
          0,
          "あ",
          "a");

      final Question question = Question(
          alphabet: kana.alphabet,
          kana: kana,
          type: QuestionTypes.toJapanese,
          remainingAttempt: 0);

      setUp(() {
        question.remainingAttempt = 3;
      });

      testWidgets("Failed to answer (remainingAttempt = 0)",
          (WidgetTester tester) async {
        question.remainingAttempt = 0;

        await tester.pumpWidget(
            LocalizedWidget(child: QuestionReviewTile(question: question)));
        await tester.pumpAndSettle();

        final widget = find.byType(QuestionReviewTile);
        expect(widget, findsOneWidget);

        // Check the icon.
        final icon = find.descendant(
            of: widget, matching: find.byIcon(Icons.close_rounded));
        expect(icon, findsOneWidget,
            reason: "Because remainingAttempt = 0, should show a ❌");
        expect((tester.firstWidget(icon) as Icon).color, Colors.red,
            reason: "The icon should be red");

        // Check the text.
        final l10n = await setupLocalizations();
        expect(
            find.descendant(
                of: widget,
                matching: find.text(l10n.quiz_conclusion_kana(
                    question.question, question.answer))),
            findsOneWidget,
            reason: "Should be displaying the kana and the romaji");
      });

      testWidgets(
          "Answered correctly after one or multiple try (remainingAttempt > 0)",
          (WidgetTester tester) async {
        question.remainingAttempt = 1;

        await tester.pumpWidget(
            LocalizedWidget(child: QuestionReviewTile(question: question)));
        await tester.pumpAndSettle();

        final widget = find.byType(QuestionReviewTile);
        expect(widget, findsOneWidget);

        // Check the icon.
        final icon = find.descendant(
            of: widget, matching: find.byIcon(Icons.warning_rounded));
        expect(icon, findsOneWidget,
            reason: "Because remainingAttempt = 0, should show a ⚠️");
        expect((tester.firstWidget(icon) as Icon).color, Colors.orange,
            reason: "The icon should be orange");

        // Check the text.
        final l10n = await setupLocalizations();
        expect(
            find.descendant(
                of: widget,
                matching: find.text(l10n.quiz_conclusion_kana(
                    question.question, question.answer))),
            findsOneWidget,
            reason: "Should be displaying the kana and the romaji");
      });
    });
  });
}
