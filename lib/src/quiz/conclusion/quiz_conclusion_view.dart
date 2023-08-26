import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:kana_to_kanji/src/core/widgets/app_scaffold.dart';
import 'package:kana_to_kanji/src/quiz/conclusion/quiz_conclusion_view_model.dart';
import 'package:kana_to_kanji/src/core/widgets/arc_progress_indicator.dart';
import 'package:kana_to_kanji/src/quiz/conclusion/widgets/to_review_section.dart';
import 'package:kana_to_kanji/src/quiz/models/question.dart';
import 'package:stacked/stacked.dart';

class QuizConclusionView extends StatelessWidget {
  static const routeName = "/quiz/conclusion";

  static const _kArcProgressIndicatorSize = 200.0;

  final List<Question> questions;

  const QuizConclusionView({super.key, required this.questions});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    final maxTopPaddingIndicator =
        (MediaQuery.of(context).size.height) / 2 - _kArcProgressIndicatorSize;

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: viewModel.wrongAnswers.isNotEmpty
                            ? 20.0
                            : maxTopPaddingIndicator,
                        bottom: 20.0),
                    child: ArcProgressIndicator(
                        value: viewModel.percent,
                        radius: _kArcProgressIndicatorSize,
                        alternativeText: l10n.quiz_length(
                            viewModel.rightAnswers.length,
                            viewModel.questions.length)),
                  ),
                ),
                if (viewModel.wrongAnswers.isNotEmpty)
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
