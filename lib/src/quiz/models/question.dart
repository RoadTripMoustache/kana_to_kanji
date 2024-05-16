import "package:freezed_annotation/freezed_annotation.dart";
import "package:kana_to_kanji/src/core/constants/alphabets.dart";
import "package:kana_to_kanji/src/core/models/kana.dart";
import "package:kana_to_kanji/src/quiz/constants/question_types.dart";

part "question.freezed.dart";

@unfreezed
class Question with _$Question {
  Question._();

  factory Question({
    required final Alphabets alphabet,
    required final Kana kana,
    required final QuestionTypes type,
    @Default(3) int remainingAttempt,
  }) = _Question;

  String get question {
    switch (type) {
      case QuestionTypes.toJapanese:
        return kana.romaji;
      case QuestionTypes.toRomaji:
        return kana.kana;
      case QuestionTypes.translate:
        throw UnimplementedError();
    }
  }

  String get answer {
    switch (type) {
      case QuestionTypes.toJapanese:
        return kana.kana;
      case QuestionTypes.toRomaji:
        return kana.romaji;
      case QuestionTypes.translate:
        throw UnimplementedError();
    }
  }
}
