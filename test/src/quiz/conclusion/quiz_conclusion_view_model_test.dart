import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/repositories/settings_repository.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:kana_to_kanji/src/quiz/conclusion/quiz_conclusion_view_model.dart";
import "package:kana_to_kanji/src/quiz/constants/question_types.dart";
import "package:kana_to_kanji/src/quiz/models/question.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

import "../../../dummies/kana.dart";
import "../../../helpers.dart";
@GenerateNiceMocks([MockSpec<SettingsRepository>()])
import "quiz_conclusion_view_model_test.mocks.dart";

void main() {
  group("QuizConclusionViewModel", () {
    final settingsRepositoryMock = MockSettingsRepository();

    final Question wrongQuestion = Question(
      alphabet: dummyKatakana.alphabet,
      kana: dummyKatakana,
      type: QuestionTypes.toJapanese,
      remainingAttempt: 0,
    );
    final Question partiallyWrongQuestion = Question(
      alphabet: dummyKatakana.alphabet,
      kana: dummyKatakana,
      type: QuestionTypes.toJapanese,
      remainingAttempt: 2,
    );
    final Question rightQuestion = Question(
      alphabet: dummyKatakana.alphabet,
      kana: dummyKatakana,
      type: QuestionTypes.toJapanese,
    );

    setUpAll(() {
      locator.registerSingleton<SettingsRepository>(settingsRepositoryMock);
      when(settingsRepositoryMock.getMaximumAttemptsByQuestion()).thenReturn(3);
    });

    tearDown(() {
      reset(settingsRepositoryMock);
    });

    tearDownAll(() async {
      await unregister<SettingsRepository>();
    });

    test("Initialization", () {
      final List<Question> questions = [
        wrongQuestion,
        partiallyWrongQuestion,
        rightQuestion,
      ];
      final QuizConclusionViewModel viewModel = QuizConclusionViewModel(
        questions,
      );

      expect(viewModel.questions, containsAll(questions));
      expect(
        viewModel.rightAnswers,
        containsAll([partiallyWrongQuestion, rightQuestion]),
      );
      expect(
        viewModel.wrongAnswers,
        containsAll([partiallyWrongQuestion, wrongQuestion]),
      );
    });
  });
}
