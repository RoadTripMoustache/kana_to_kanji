import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kana_to_kanji/src/quiz/models/question.dart';
import 'package:kana_to_kanji/src/quiz/widgets/flip_card.dart';
import 'package:kana_to_kanji/src/quiz/widgets/animated_dot.dart';

class QuestionTile extends StatefulWidget {
  final Question question;

  final int maximumAttempts;

  final bool Function(String answer) submitAnswer;

  final VoidCallback nextQuestion;

  const QuestionTile(
      {super.key,
      required this.question,
      required this.submitAnswer,
      required this.nextQuestion,
      required this.maximumAttempts});

  @override
  State<QuestionTile> createState() => _QuestionTileState();
}

class _QuestionTileState extends State<QuestionTile> {
  final TextEditingController _controller = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  onSubmit(String answer) {
    if(answer.isEmpty) {
      _focusNode.requestFocus();
      return;
    }
    final result = widget.submitAnswer(answer);

    if (!result) {
      _controller.clear();
      _focusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

    final nextButton = widget.question.remainingAttempt > 0
        ? TextButton(
            onPressed: widget.nextQuestion,
            child: Text(l10n.quiz_skip_question))
        : ElevatedButton(
            onPressed: widget.nextQuestion,
            child: Text(l10n.quiz_next_question));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 30,
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: widget.maximumAttempts,
              itemBuilder: (context, index) => AnimatedDot(
                  filledOut: index < widget.question.remainingAttempt)),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: FlipCard(
            allowFlip: widget.question.remainingAttempt == 0,
            flipped: widget.question.remainingAttempt == 0,
            front: AutoSizeText(
              widget.question.question,
              style: textTheme.displayLarge!.copyWith(fontSize: 96),
              maxLines: 1,
            ),
            back: AutoSizeText(
              widget.question.answer,
              style: textTheme.displayLarge!,
              maxLines: 1,
            ),
          ),
        ),
        if (widget.question.remainingAttempt > 0)
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                autocorrect: false,
                autofocus: true,
                textAlign: TextAlign.center,
                textInputAction: TextInputAction.send,
                onSubmitted: onSubmit),
          ),
        nextButton
      ],
    );
  }
}
