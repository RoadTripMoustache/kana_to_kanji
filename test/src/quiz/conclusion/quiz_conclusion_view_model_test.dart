import 'package:flutter_test/flutter_test.dart';
import 'package:kana_to_kanji/src/core/constants/alphabets.dart';
import 'package:kana_to_kanji/src/core/constants/resource_type.dart';
import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/core/models/resource_uid.dart';
import 'package:kana_to_kanji/src/core/repositories/settings_repository.dart';
import 'package:kana_to_kanji/src/locator.dart';
import 'package:kana_to_kanji/src/quiz/conclusion/quiz_conclusion_view_model.dart';
import 'package:kana_to_kanji/src/quiz/constants/question_types.dart';
import 'package:kana_to_kanji/src/quiz/models/question.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers.dart';
@GenerateNiceMocks([MockSpec<SettingsRepository>()])
import 'quiz_conclusion_view_model_test.mocks.dart';

void main() {
  group("QuizConclusionViewModel", () {
    final settingsRepositoryMock = MockSettingsRepository();

    const Kana kana = Kana(
        ResourceUid("kana-1", ResourceType.kana),
        Alphabets.hiragana,
        ResourceUid("group-1", ResourceType.group),
        "あ",
        "a",
        "v1",
        1);

    final Question wrongQuestion = Question(
        alphabet: kana.alphabet,
        kana: kana,
        type: QuestionTypes.toJapanese,
        remainingAttempt: 0);
    final Question partiallyWrongQuestion = Question(
        alphabet: kana.alphabet,
        kana: kana,
        type: QuestionTypes.toJapanese,
        remainingAttempt: 2);
    final Question rightQuestion = Question(
        alphabet: kana.alphabet,
        kana: kana,
        type: QuestionTypes.toJapanese,
        remainingAttempt: 3);

    setUpAll(() {
      locator.registerSingleton<SettingsRepository>(settingsRepositoryMock);
      when(settingsRepositoryMock.getMaximumAttemptsByQuestion()).thenReturn(3);
    });

    tearDown(() {
      reset(settingsRepositoryMock);
    });

    tearDownAll(() {
      unregister<SettingsRepository>();
    });

    test("Initialization", () {
      final List<Question> questions = [
        wrongQuestion,
        partiallyWrongQuestion,
        rightQuestion
      ];
      QuizConclusionViewModel viewModel = QuizConclusionViewModel(questions);

      expect(viewModel.questions, containsAll(questions));
      expect(viewModel.rightAnswers,
          containsAll([partiallyWrongQuestion, rightQuestion]));
      expect(viewModel.wrongAnswers,
          containsAll([partiallyWrongQuestion, wrongQuestion]));
    });
  });
}
