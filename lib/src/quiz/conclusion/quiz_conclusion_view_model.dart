import 'package:kana_to_kanji/src/quiz/models/question.dart';
import 'package:stacked/stacked.dart';

class QuizConclusionViewModel extends BaseViewModel {
  final List<Question> questions;

  final List<Question> wrongAnswers = [];

  final List<Question> rightAnswers = [];

  QuizConclusionViewModel(this.questions) {
    for (final question in questions) {
      print(question.remainingAttempt);
      if (question.remainingAttempt > 0) {
        rightAnswers.add(question);
      } else {
        wrongAnswers.add(question);
      }
    }
  }
}
