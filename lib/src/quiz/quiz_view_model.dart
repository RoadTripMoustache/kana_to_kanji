import 'package:go_router/go_router.dart';
import 'package:kana_to_kanji/src/core/models/group.dart';
import 'package:kana_to_kanji/src/core/repositories/kana_repository.dart';
import 'package:kana_to_kanji/src/core/repositories/settings_repository.dart';
import 'package:kana_to_kanji/src/locator.dart';
import 'package:kana_to_kanji/src/quiz/conclusion/quiz_conclusion_view.dart';
import 'package:kana_to_kanji/src/quiz/constants/question_types.dart';
import 'package:kana_to_kanji/src/quiz/models/question.dart';
import 'package:stacked/stacked.dart';

class QuizViewModel extends FutureViewModel {
  final KanaRepository _kanaRepository = locator<KanaRepository>();

  final SettingsRepository _settingsRepository = locator<SettingsRepository>();

  final GoRouter router;

  final List<Group> groups;

  final List<Question> _questions = [];

  int get quizLength => _questions.length;

  int _currentQuestionIndex = 0;

  int get questionNumber => _currentQuestionIndex + 1;

  int get attemptMaxNumber =>
      _settingsRepository.getMaximumAttemptsByQuestion();

  Question get current => _questions[_currentQuestionIndex];

  QuizViewModel(this.groups, this.router);

  @override
  Future futureToRun() async {
    final kana = await _kanaRepository
        .getByGroupIds(groups.map((e) => e.id).toList(growable: false));

    _questions.addAll(kana.map((element) => Question(
        alphabet: element.alphabet,
        kana: element,
        type: QuestionTypes.toRomaji,
        remainingAttempt: _settingsRepository.getMaximumAttemptsByQuestion())));
    _questions.shuffle();
  }

  void skipQuestion() {
    _questions[_currentQuestionIndex].remainingAttempt = 0;
    nextQuestion();
  }

  bool validateAnswer(String answer) {
    final question = _questions[_currentQuestionIndex];

    if (answer != question.answer) {
      question.remainingAttempt -= 1;
      notifyListeners();
      return false;
    } else {
      nextQuestion();
    }
    return true;
  }

  nextQuestion() {
    if (_currentQuestionIndex + 1 == _questions.length) {
      router.pushReplacement(QuizConclusionView.routeName, extra: _questions);
    } else {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }
}
