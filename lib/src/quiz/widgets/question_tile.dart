import "package:auto_size_text/auto_size_text.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:kana_to_kanji/src/quiz/models/question.dart";
import "package:kana_to_kanji/src/quiz/widgets/animated_dot.dart";
import "package:kana_to_kanji/src/quiz/widgets/flip_card.dart";

class QuestionTile extends StatefulWidget {
  final Question question;

  final int maximumAttempts;

  final Future<bool> Function(String answer) submitAnswer;

  final VoidCallback nextQuestion;

  final VoidCallback skipQuestion;

  const QuestionTile(
      {required this.question,
      required this.submitAnswer,
      required this.nextQuestion,
      required this.skipQuestion,
      required this.maximumAttempts,
      super.key});

  @override
  State<QuestionTile> createState() => _QuestionTileState();
}

class _QuestionTileState extends State<QuestionTile> {
  final TextEditingController _controller = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  bool _showSuccess = false;

  Future<void> onSubmit(String answer) async {
    if (answer.isEmpty) {
      _focusNode.requestFocus();
      return;
    }
    final result = await widget.submitAnswer(answer);

    _controller.clear();

    if (result) {
      setState(() {
        _showSuccess = true;
      });
      Future.delayed(
          const Duration(milliseconds: 500),
          () => setState(() {
                _showSuccess = false;
                _focusNode.requestFocus();
              }));
    } else {
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
            onPressed: widget.skipQuestion,
            child: Text(l10n.quiz_skip_question))
        : ElevatedButton(
            onPressed: widget.nextQuestion, child: Text(l10n.button_continue));

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
            allowTapToFlip: widget.question.remainingAttempt == 0,
            flipped: widget.question.remainingAttempt == 0,
            front: AutoSizeText(
              widget.question.question,
              key: ValueKey("q${widget.question.kana.id}"),
              style: textTheme.displayLarge!.copyWith(fontSize: 96),
              maxLines: 1,
            ),
            back: AutoSizeText(
              widget.question.answer,
              key: ValueKey("a${widget.question.kana.id}"),
              style: textTheme.displayLarge,
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
                decoration: InputDecoration(
                    enabledBorder: _showSuccess
                        ? const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green))
                        : null,
                    suffixIcon: _showSuccess
                        ? const Icon(Icons.check, color: Colors.green)
                        : null),
                onSubmitted: onSubmit),
          ),
        nextButton
      ],
    );
  }
}
