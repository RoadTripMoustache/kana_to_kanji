import 'package:flutter/material.dart';
import 'package:kana_to_kanji/src/quiz/quiz_view_model.dart';
import 'package:stacked/stacked.dart';

class QuizView extends StatelessWidget {
  const QuizView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<QuizViewModel>.reactive(
        viewModelBuilder: () => QuizViewModel(),
        builder: (context, viewModel, child) => const Placeholder());
  }
}
