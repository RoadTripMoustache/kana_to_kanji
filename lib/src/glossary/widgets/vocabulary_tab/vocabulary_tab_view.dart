import 'package:flutter/material.dart';
import 'package:kana_to_kanji/src/core/widgets/app_scaffold.dart';
import 'package:kana_to_kanji/src/glossary/widgets/vocabulary_tab/vocabulary_tab_view_model.dart';
import 'package:stacked/stacked.dart';

class VocabularyTabView extends StatelessWidget {
  const VocabularyTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<VocaabularyTabViewModel>.reactive(
      viewModelBuilder: () => VocaabularyTabViewModel(),
      builder: (context, viewModel, __) => AppScaffold(
          body: SingleChildScrollView(
        child: Column(
            children:
                List.generate(viewModel.vocabularyList.length, (index) => Card(child: Text(viewModel.vocabularyList[index].kana)))),
      )),
    );
  }
}
