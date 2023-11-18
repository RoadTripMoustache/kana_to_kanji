import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kana_to_kanji/src/core/widgets/app_scaffold.dart';
import 'package:kana_to_kanji/src/glossary/glossary_view_model.dart';
import 'package:kana_to_kanji/src/glossary/hiragana_tab/hiragana_tab_view.dart';
import 'package:kana_to_kanji/src/glossary/kanji_tab/kanji_tab_view.dart';
import 'package:kana_to_kanji/src/glossary/katakana_tab/katakana_tab_view.dart';
import 'package:kana_to_kanji/src/glossary/vocabulary_tab/vocabulary_tab_view.dart';
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

    return ViewModelBuilder<GlossaryViewModel>.reactive(
        viewModelBuilder: () => GlossaryViewModel(),
        builder: (context, viewModel, child) {
          return AppScaffold(
              resizeToAvoidBottomInset: true,
              showBottomBar: true,
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () => {},
                  icon: const Icon(Icons.search),
                ),
                title: Text(l10n.glossary_page_title),
                actions: [
                  IconButton(
                    onPressed: () => {},
                    icon: const Icon(Icons.filter_list_rounded),
                  ),
                  IconButton(
                    onPressed: () => {},
                    icon: const Icon(Icons.tune),
                  ),
                ],
                centerTitle: true,
                backgroundColor: Colors.transparent,
                bottom: TabBar.secondary(
                  controller: _tabController,
                  tabs: <Widget>[
                    Tab(
                      text: l10n.glossary_tab_hiragana,
                      icon: const Icon(IconData(0x3041)),
                    ),
                    Tab(
                      text: l10n.glossary_tab_katakana,
                      icon: const Icon(IconData(0x30a2)),
                    ),
                    Tab(
                      text: l10n.glossary_tab_kanji,
                      icon: const Icon(IconData(0x8a9e)),
                    ),
                    Tab(
                        text: l10n.glossary_tab_vocabulary,
                        icon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(IconData(0x8a9e)),
                            Icon(IconData(0x5f59)),
                          ],
                        )
                    ),
                  ],
                ),
              ),
              body:
                  TabBarView(
                      controller: _tabController,
                      children: const <Widget>[
                        HiraganaTabView(),
                        KatakanaTabView(),
                        KanjiTabView(),
                        VocabularyTabView(),
                      ],
                    )
              );
        });
  }
}
