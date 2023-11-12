import 'package:flutter/material.dart';
import 'package:kana_to_kanji/src/core/widgets/app_scaffold.dart';
import 'package:kana_to_kanji/src/glossary/hiragana_tab/hiragana_tab_view_model.dart';
import 'package:stacked/stacked.dart';

class HiraganaTabView extends StatelessWidget {
  const HiraganaTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HiraganaTabViewModel>.reactive(
      viewModelBuilder: () => HiraganaTabViewModel(),
      builder: (context, viewModel, __) => AppScaffold(
          body: SingleChildScrollView(
        child: Column(
            children:
                List.generate(viewModel.hiraganaList.length, (index) => Card(child: Text(viewModel.hiraganaList[index].kana)))),
      )),
    );
  }
}
