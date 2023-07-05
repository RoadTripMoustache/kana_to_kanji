import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/quiz/constants/question_types.dart';

part 'question.freezed.dart';

@unfreezed
class Question with _$Question {
  factory Question({
    required final Kana question,
    required final QuestionTypes type,
    @Default(3) int remainingAttempt,
  }) = _Question;
}
