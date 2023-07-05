import 'package:flutter/material.dart';
import 'package:kana_to_kanji/src/quiz/models/question.dart';
import 'package:kana_to_kanji/src/quiz/widgets/flip_card.dart';

class QuestionTile extends StatefulWidget {
  final Question question;

  final Function(String answer) submitAnswer;

  const QuestionTile(
      {super.key, required this.question, required this.submitAnswer});

  @override
  State<QuestionTile> createState() => _QuestionTileState();
}

class _QuestionTileState extends State<QuestionTile> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FlipCard(
          front: Text(
            widget.question.question,
            style: textTheme.displayLarge!.copyWith(fontSize: 96),
          ),
          back: Text(
            widget.question.answer,
            style: textTheme.displayLarge!,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: TextField(
                autocorrect: false,
                autofocus: true,
                textAlign: TextAlign.center,
                textInputAction: TextInputAction.next,
                onSubmitted: widget.submitAnswer),
          ),
        )
      ],
    );
  }
}
