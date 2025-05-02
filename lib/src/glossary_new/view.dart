import "package:flutter/material.dart";
import "package:flutter_rtm/flutter_rtm.dart";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/l10n/app_localizations.dart";
import "package:kana_to_kanji/src/core/widgets/app_scaffold.dart";
import "package:kana_to_kanji/src/glossary_new/view_model.dart";
import "package:kana_to_kanji/src/glossary_new/widgets/kana_list.dart";
import "package:kana_to_kanji/src/glossary_new/widgets/kanji_list.dart";
import "package:kana_to_kanji/src/glossary_new/widgets/loading_tab.dart";
import "package:kana_to_kanji/src/glossary_new/widgets/vocabulary_list.dart";
import "package:stacked/stacked.dart";

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

    return ViewModelBuilder<GlossaryViewModel>.reactive(
      viewModelBuilder:
          () => GlossaryViewModel(GoRouter.of(context), _tabController),
      builder:
          (context, viewModel, child) => AppScaffold(
            showBottomBar: true,
            appBar: AppBar(
              actions: [
                RTMIconButton(
                  onPressed: viewModel.onFilterByPressed,
                  icon: const Icon(Icons.filter_list_rounded),
                ),
              ],
              bottom: TabBar.secondary(
                controller: _tabController,
                tabs: <Widget>[
                  Tab(text: l10n.glossary_tab_hiragana, icon: const Text("あ")),
                  Tab(text: l10n.glossary_tab_katakana, icon: const Text("ア")),
                  Tab(text: l10n.glossary_tab_kanji, icon: const Text("語")),
                  Tab(
                    text: l10n.glossary_tab_vocabulary,
                    icon: const Text("語彙"),
                  ),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TabBarView(
                controller: _tabController,
                children: [
                  LoadingTab(
                    isDataReady: viewModel.isHiraganaReady,
                    child: KanaList(
                      items: viewModel.hiragana,
                      onPressed: viewModel.onTilePressed,
                    ),
                  ),
                  LoadingTab(
                    isDataReady: viewModel.isKatakanaReady,
                    child: KanaList(
                      items: viewModel.katakana,
                      onPressed: viewModel.onTilePressed,
                    ),
                  ),
                  KanjiList(
                    onPressed: viewModel.onTilePressed,
                    pagination: viewModel.kanji,
                  ),
                  VocabularyList(
                    onPressed: viewModel.onTilePressed,
                    pagination: viewModel.vocabulary,
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
