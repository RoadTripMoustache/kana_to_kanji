import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:kana_to_kanji/src/quiz/conclusion/widgets/question_review_tile.dart";
import "package:kana_to_kanji/src/quiz/models/question.dart";

class ToReviewSection extends StatelessWidget {
  static const double _kTileHeight = 54.1;

  final List<Question> questionsToReview;

  const ToReviewSection({required this.questionsToReview, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final tileWidth = (MediaQuery.of(context).size.width - 24) / 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.quiz_conclusion_to_review,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const Divider(thickness: 0, indent: 0, endIndent: 150),
        Expanded(
          child: Scrollbar(
            thumbVisibility: true,
            child: SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: List.generate(
                    questionsToReview.length,
                    (index) => SizedBox(
                      width: tileWidth,
                      height: _kTileHeight,
                      child: QuestionReviewTile(
                        question: questionsToReview[index],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
