import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/quiz/conclusion/widgets/question_review_tile.dart";
import "package:kana_to_kanji/src/quiz/conclusion/widgets/to_review_section.dart";
import "package:kana_to_kanji/src/quiz/constants/question_types.dart";
import "package:kana_to_kanji/src/quiz/models/question.dart";

import "../../../../dummies/kana.dart";
import "../../../../helpers.dart";

void main() {
  group("ToReviewSection", () {
    final Question kanaQuestionSample = Question(
      alphabet: dummyKatakana.alphabet,
      kana: dummyKatakana,
      type: QuestionTypes.toJapanese,
    );

    final List<Question> questions = [kanaQuestionSample];

    setUp(() {
      for (final question in questions) {
        question.remainingAttempt = 0;
      }
    });

    testWidgets("UI", (WidgetTester tester) async {
      await tester.pumpLocalizedWidget(
        ToReviewSection(questionsToReview: questions),
      );
      await tester.pumpAndSettle();

      final widget = find.byType(ToReviewSection);
      expect(widget, findsOneWidget);

      // Check the text
      final l10n = await setupLocalizations();
      expect(
        find.descendant(
          of: widget,
          matching: find.text(l10n.quiz_conclusion_to_review),
        ),
        findsOneWidget,
        reason: "Should be displaying the section title",
      );

      // Check the list of question to review
      // Don't skip off stage to make sure everything is here.
      expect(
        find.descendant(of: widget, matching: find.byType(QuestionReviewTile)),
        findsNWidgets(questions.length),
        reason: "Should display ${questions.length} question to review tiles",
      );
    });
  });
}
