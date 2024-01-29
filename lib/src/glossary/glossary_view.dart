import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
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
        viewModelBuilder: () => GlossaryViewModel(GoRouter.of(context)),
        builder: (context, viewModel, child) {
          return AppScaffold(
            showBottomBar: true,
            appBar: AppBar(
              title: GlossarySearchBar(
                searchGlossary: viewModel.searchGlossary,
                filterGlossary: viewModel.filterGlossary,
                selectedJlptLevel: viewModel.selectedJlptLevel,
                selectedKnowledgeLevel: viewModel.selectedKnowledgeLevel,
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              toolbarHeight: kToolbarHeight,
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
            body: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  KanaList(
                      items: viewModel.hiraganaList,
                      onPressed: viewModel.onTilePressed),
                  KanaList(
                      items: viewModel.katakanaList,
                      onPressed: viewModel.onTilePressed),
                  KanjiList(
                      items: viewModel.kanjiList,
                      onPressed: viewModel.onTilePressed),
                  VocabularyList(
                      items: viewModel.vocabularyList,
                      onPressed: viewModel.onTilePressed),
                ],
              ),
            ),
          );
        });
  }
}
