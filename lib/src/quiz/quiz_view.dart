import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kana_to_kanji/src/core/models/group.dart';
import 'package:kana_to_kanji/src/core/widgets/app_scaffold.dart';
import 'package:kana_to_kanji/src/quiz/quiz_view_model.dart';
import 'package:kana_to_kanji/src/quiz/widgets/question_tile.dart';
import 'package:stacked/stacked.dart';

class QuizView extends StatelessWidget {
  static const routeName = "/quiz";

  final List<Group> groups;

  const QuizView({super.key, this.groups = const []});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return ViewModelBuilder<QuizViewModel>.reactive(
        viewModelBuilder: () => QuizViewModel(groups),
        builder: (context, viewModel, child) => AppScaffold(
            resizeToAvoidBottomInset: true,
            body: viewModel.isBusy
                ? const CircularProgressIndicator()
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.quiz_length(
                                viewModel.questionNumber, viewModel.quizLength),
                            style: textTheme.titleMedium,
                          )
                        ],
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            QuestionTile(
                                question: viewModel.current,
                                submitAnswer: viewModel.validateAnswer),
                          ],
                        ),
                      )
                    ],
                  )));
  }
}
