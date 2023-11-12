import 'package:flutter/material.dart';
import 'package:kana_to_kanji/src/core/widgets/app_scaffold.dart';
import 'package:kana_to_kanji/src/glossary/katakana_tab/katakana_tab_view_model.dart';
import 'package:stacked/stacked.dart';

class KatakanaTabView extends StatelessWidget {

  const KatakanaTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<KatakanaTabViewModel>.reactive(
      viewModelBuilder: () => KatakanaTabViewModel(),
      builder: (context, viewModel, __) => AppScaffold(
          body: SingleChildScrollView(
            child: Column(
                children:
                List.generate(viewModel.katakanaList.length, (index) => Card(child: Text(viewModel.katakanaList[index].kana)))),
          )),
    );
  }
}
