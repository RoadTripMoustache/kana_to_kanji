import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kana_to_kanji/src/core/widgets/app_scaffold.dart';
import 'package:kana_to_kanji/src/glossary/glossary_view_model.dart';
import 'package:kana_to_kanji/src/glossary/widgets/kana_list.dart';
import 'package:kana_to_kanji/src/glossary/widgets/kanji_list.dart';
import 'package:kana_to_kanji/src/glossary/widgets/search_bar.dart';
import 'package:kana_to_kanji/src/glossary/widgets/vocabulary_list.dart';
import 'package:stacked/stacked.dart';

class GlossaryView extends StatefulWidget {
  static const routeName = "/glossary";

  const GlossaryView({super.key});

  @override
  State<GlossaryView> createState() => _GlossaryViewState();
}

class _GlossaryViewState extends State<GlossaryView>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    const textIconStyle = TextStyle(fontSize: 26);

    return ViewModelBuilder<GlossaryViewModel>.reactive(
        viewModelBuilder: () => GlossaryViewModel(),
        builder: (context, viewModel, child) {
          return AppScaffold(
              resizeToAvoidBottomInset: false,
              showBottomBar: true,
              appBar: AppBar(
                title:
                    GlossarySearchBar(searchGlossary: viewModel.searchGlossary),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                toolbarHeight: 64,
                bottom: TabBar.secondary(
                  controller: _tabController,
                  tabs: <Widget>[
                    Tab(
                      text: l10n.glossary_tab_hiragana,
                      icon: const Text("あ", style: textIconStyle),
                    ),
                    Tab(
                      text: l10n.glossary_tab_katakana,
                      icon: const Text("ア", style: textIconStyle),
                    ),
                    Tab(
                      text: l10n.glossary_tab_kanji,
                      icon: const Text("語", style: textIconStyle),
                    ),
                    Tab(
                      text: l10n.glossary_tab_vocabulary,
                      icon: const Text("語彙", style: textIconStyle),
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  KanaList(items: viewModel.hiraganaList),
                  KanaList(items: viewModel.katakanaList),
                  KanjiList(items: viewModel.kanjiList),
                  VocabularyList(items: viewModel.vocabularyList),
                ],
              ));
        });
  }
}
