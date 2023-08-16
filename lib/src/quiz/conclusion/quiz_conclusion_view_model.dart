import 'package:kana_to_kanji/src/core/repositories/settings_repository.dart';
import 'package:kana_to_kanji/src/locator.dart';
import 'package:kana_to_kanji/src/quiz/models/question.dart';
import 'package:stacked/stacked.dart';

class QuizConclusionViewModel extends BaseViewModel {
  final SettingsRepository _settingsRepository = locator<SettingsRepository>();

  final List<Question> questions;

  final List<Question> wrongAnswers = [];

  final List<Question> rightAnswers = [];

  double get percent => rightAnswers.length / questions.length;

  QuizConclusionViewModel(this.questions) {
    final int maxAttempts = _settingsRepository.getMaximumAttemptsByQuestion();

    for (final question in questions) {
      if (question.remainingAttempt > 0) {
        rightAnswers.add(question);

        if(question.remainingAttempt != maxAttempts) {
          wrongAnswers.add(question);
        }
      } else {
        wrongAnswers.add(question);
      }
    }

    wrongAnswers.sort((a, b) => a.remainingAttempt > b.remainingAttempt ? 1:-1);
  }
}
