import "package:flutter/material.dart";
import "package:flutter_rtm/flutter_rtm.dart";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/src/core/models/group.dart";
import "package:kana_to_kanji/src/core/widgets/app_scaffold.dart";
import "package:kana_to_kanji/src/practice/quiz/widgets/quiz_app_bar.dart";
import "package:kana_to_kanji/src/quiz/quiz_view_model.dart";
import "package:kana_to_kanji/src/quiz/widgets/question_tile.dart";
import "package:stacked/stacked.dart";

class QuizView extends StatelessWidget {
  static const routeName = "/quiz/questions";

  final List<Group> groups;

  const QuizView({super.key, this.groups = const []});

  @override
  Widget build(BuildContext context) =>
      ViewModelBuilder<QuizViewModel>.reactive(
        viewModelBuilder: () => QuizViewModel(groups, GoRouter.of(context)),
        builder:
            (context, viewModel, child) => AppScaffold(
              resizeToAvoidBottomInset: true,
              appBar: QuizAppBar(
                onClosePressed: () => context.pop(),
                onSkipPressed: viewModel.skipQuestion,
                progressBarValue:
                    viewModel.quizLength > 0
                        ? (viewModel.questionNumber / viewModel.quizLength)
                        : 0.0,
              ),
              body:
                  viewModel.isBusy
                      ? const RTMSpinner()
                      : Column(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                QuestionTile(
                                  question: viewModel.current,
                                  submitAnswer: viewModel.validateAnswer,
                                  maximumAttempts: viewModel.attemptMaxNumber,
                                  nextQuestion: viewModel.nextQuestion,
                                  skipQuestion: viewModel.skipQuestion,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
            ),
      );
}
