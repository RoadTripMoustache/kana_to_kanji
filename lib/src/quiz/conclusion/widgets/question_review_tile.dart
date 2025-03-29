import "package:flutter/material.dart";
import "package:flutter_rtm/flutter_rtm.dart";
import "package:kana_to_kanji/l10n/app_localizations.dart";
import "package:kana_to_kanji/src/core/utils/extensions.dart";
import "package:kana_to_kanji/src/quiz/models/question.dart";

class QuestionReviewTile extends StatelessWidget {
  final Question question;

  const QuestionReviewTile({required this.question, super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final AppLocalizations l10n = AppLocalizations.of(context);

    final String text =
        question.alphabet.isKana()
            ? l10n.quiz_conclusion_kana(question.question, question.answer)
            : question.question;
    final Icon icon =
        question.remainingAttempt == 0
            ? const Icon(Icons.close_rounded, color: Colors.red)
            : const Icon(Icons.warning_rounded, color: Colors.orange);

    return RTMCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: ColoredBox(
          color: Colors.transparent,
          child: Row(
            children: [
              Padding(padding: const EdgeInsets.only(right: 4.0), child: icon),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      style: textTheme.bodyLarge?.copyWith(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
