import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:kana_to_kanji/src/core/models/group.dart';
import 'package:kana_to_kanji/src/core/widgets/app_scaffold.dart';
import 'package:kana_to_kanji/src/quiz/quiz_view_model.dart';
import 'package:kana_to_kanji/src/quiz/widgets/question_tile.dart';
import 'package:kana_to_kanji/src/quiz/widgets/rounded_linear_progress_indicator.dart';
import 'package:stacked/stacked.dart';

class QuizView extends StatelessWidget {
  static const routeName = "/quiz/questions";

  final List<Group> groups;

  const QuizView({super.key, this.groups = const []});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return ViewModelBuilder<QuizViewModel>.reactive(
        viewModelBuilder: () => QuizViewModel(groups, GoRouter.of(context)),
        builder: (context, viewModel, child) => AppScaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => context.pop(),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: RoundedLinearProgressIndicator(
                      minHeight: 12.0,
                      value: viewModel.quizLength > 0
                          ? (viewModel.questionNumber / viewModel.quizLength)
                          : 0.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      l10n.quiz_length(
                          viewModel.questionNumber, viewModel.quizLength),
                      style: textTheme.titleMedium,
                    ),
                  )
                ],
              ),
            ),
            body: viewModel.isBusy
                ? const CircularProgressIndicator()
                : Column(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            QuestionTile(
                              question: viewModel.current,
                              submitAnswer: viewModel.validateAnswer,
                              maximumAttempts: viewModel.attemptMaxNumber,
                              nextQuestion: viewModel.nextQuestion,
                            ),
                          ],
                        ),
                      )
                    ],
                  )));
  }
}
