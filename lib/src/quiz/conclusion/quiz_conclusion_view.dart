import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:kana_to_kanji/src/core/widgets/app_scaffold.dart';
import 'package:kana_to_kanji/src/quiz/conclusion/quiz_conclusion_view_model.dart';
import 'package:kana_to_kanji/src/quiz/conclusion/widgets/arc_progress_indicator.dart';
import 'package:kana_to_kanji/src/quiz/conclusion/widgets/question_review_tile.dart';
import 'package:kana_to_kanji/src/quiz/conclusion/widgets/to_review_section.dart';
import 'package:kana_to_kanji/src/quiz/models/question.dart';
import 'package:stacked/stacked.dart';

class QuizConclusionView extends StatelessWidget {
  static const routeName = "/quiz/conclusion";

  final List<Question> questions;

  const QuizConclusionView({super.key, required this.questions});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return ViewModelBuilder<QuizConclusionViewModel>.reactive(
        viewModelBuilder: () => QuizConclusionViewModel(questions),
        builder: (context, viewModel, child) => AppScaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
                centerTitle: true,
                surfaceTintColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => context.pop(),
                ),
                title: Text(l10n.quiz_conclusion)),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                    child: ArcProgressIndicator(
                        value: viewModel.percent,
                        radius: 200,
                        alternativeText: l10n.quiz_length(
                            viewModel.rightAnswers.length,
                            viewModel.questions.length)),
                  ),
                ),
                Expanded(
                    child: ToReviewSection(
                        questionsToReview: viewModel.wrongAnswers)),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () => context.pop(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 8.0),
                            child: Text(
                              l10n.button_continue.toUpperCase(),
                              style: textTheme.headlineSmall,
                            ),
                          )),
                    ],
                  ),
                )
              ],
            )));
  }
}
