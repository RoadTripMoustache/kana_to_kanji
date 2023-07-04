import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kana_to_kanji/src/core/models/group.dart';
import 'package:kana_to_kanji/src/quiz/quiz_view_model.dart';
import 'package:stacked/stacked.dart';

class QuizView extends StatelessWidget {
  static const routeName = "/quiz";

  final List<Group> groups;

  const QuizView({super.key, this.groups = const []});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<QuizViewModel>.reactive(
        viewModelBuilder: () => QuizViewModel(groups),
        builder: (context, viewModel, child) =>
            Center(child: Text(jsonEncode(viewModel.groups.length))));
  }
}
