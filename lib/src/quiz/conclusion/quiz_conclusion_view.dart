import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:kana_to_kanji/src/core/widgets/app_scaffold.dart';
import 'package:kana_to_kanji/src/quiz/conclusion/quiz_conclusion_view_model.dart';
import 'package:kana_to_kanji/src/quiz/models/question.dart';
import 'package:stacked/stacked.dart';

class QuizConclusionView extends StatelessWidget {
  static const routeName = "/quiz/conclusion";

  final List<Question> questions;

  const QuizConclusionView({super.key, required this.questions});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ViewModelBuilder<QuizConclusionViewModel>.reactive(
        viewModelBuilder: () => QuizConclusionViewModel(questions),
        builder: (context, viewModel, child) => AppScaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => context.pop(),
              ),
              title: Text(l10n.quiz_conclusion),
            ),
            body: Center(
                child: Text(l10n.quiz_conclusion_percent(viewModel.percent)))));
  }
}
