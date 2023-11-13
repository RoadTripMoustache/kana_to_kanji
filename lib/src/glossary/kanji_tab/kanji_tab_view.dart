import 'package:flutter/material.dart';
import 'package:kana_to_kanji/src/core/widgets/app_scaffold.dart';
import 'package:kana_to_kanji/src/glossary/kanji_tab/kanji_tab_view_model.dart';
import 'package:stacked/stacked.dart';

class KanjiTabView extends StatelessWidget {
  const KanjiTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<KanjiTabViewModel>.reactive(
      viewModelBuilder: () => KanjiTabViewModel(),
      builder: (context, viewModel, __) => AppScaffold(
          body: SingleChildScrollView(
        child: Column(
            children: List.generate(
                viewModel.kanjiList.length,
                (index) =>
                    Card(child: Text(viewModel.kanjiList[index].kanji)))),
      )),
    );
  }
}
