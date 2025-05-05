import "dart:async";

import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/src/core/constants/alphabets.dart";
import "package:kana_to_kanji/src/core/constants/jlpt_levels.dart";
import "package:kana_to_kanji/src/core/constants/knowledge_level.dart";
import "package:kana_to_kanji/src/core/constants/sort_order.dart";
import "package:kana_to_kanji/src/core/models/resources/resources.dart";
import "package:kana_to_kanji/src/core/repositories/kana_repository.dart";
import "package:kana_to_kanji/src/core/repositories/kanji_repository.dart";
import "package:kana_to_kanji/src/core/repositories/vocabulary_repository.dart";
import "package:kana_to_kanji/src/core/services/dialog_service.dart";
import "package:kana_to_kanji/src/glossary/constants.dart";
import "package:kana_to_kanji/src/glossary/details/view.dart";
import "package:kana_to_kanji/src/glossary/pagination_helper.dart";
import "package:kana_to_kanji/src/glossary/widgets/sort_filter_by_dialog.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:stacked/stacked.dart";

const String hiraganaStream = "hiragana";
const String katakanaStream = "katakana";

class GlossaryViewModel extends MultipleStreamViewModel {
  final GoRouter router;
  final TabController tabController;

  final List<bool> _visitedTabs = [];

  bool isTabVisited(GlossaryTab tab) => _visitedTabs[tab.index];

  final Map<String, StreamController> _controllers = {
    hiraganaStream: StreamController<KanaMap>(),
    katakanaStream: StreamController<KanaMap>(),
  };

  SortOrder _sortOrder = SortOrder.alphabetical;

  final List<JLPTLevel> _selectedJlptLevel = [];
  final List<KnowledgeLevel> _selectedKnowledgeLevel = [];

  String _search = "";

  final DialogService _dialogService = locator<DialogService>();
  final KanaRepository _kanaRepository = locator<KanaRepository>();

  KanaMap get hiragana => dataMap?[hiraganaStream] ?? {};

  bool get isHiraganaReady => dataReady(hiraganaStream);

  KanaMap get katakana => dataMap?[katakanaStream] ?? {};

  bool get isKatakanaReady => dataReady(katakanaStream);

  final PaginationHelper<Kanji, KanjiRepository> kanji = PaginationHelper();
  final PaginationHelper<Vocabulary, VocabularyRepository> vocabulary =
      PaginationHelper();

  @override
  List<ListenableServiceMixin> get listenableServices => [kanji, vocabulary];

  GlossaryViewModel(this.router, this.tabController) {
    _kanaRepository.addListener(_onKanaUpdate);
    tabController.addListener(_onTabChanged);
    unawaited(_onKanaUpdate());
    _resetVisitedTabs();
  }

  @override
  Map<String, StreamData> get streamsMap => {
    hiraganaStream: StreamData<KanaMap>(
      _controllers[hiraganaStream]!.stream as Stream<KanaMap>,
    ),
    katakanaStream: StreamData<KanaMap>(
      _controllers[katakanaStream]!.stream as Stream<KanaMap>,
    ),
  };

  void _onTabChanged() {
    _visitedTabs[tabController.index] = true;
    notifyListeners();
  }

  bool showBadge(GlossaryTab tab) {
    switch (tab) {
      case GlossaryTab.hiragana:
        return !_visitedTabs[tab.index] && !_kanaFullyDisabled(hiragana);
      case GlossaryTab.katakana:
        return !_visitedTabs[tab.index] && !_kanaFullyDisabled(katakana);
      case GlossaryTab.kanji:
        return !_visitedTabs[tab.index] && kanji.hasData;
      case GlossaryTab.vocabulary:
        return !_visitedTabs[tab.index] && vocabulary.hasData;
    }
  }

  bool _kanaFullyDisabled(KanaMap map) =>
      map.values.every((list) => list.every((item) => item.disabled));

  void _resetVisitedTabs() {
    _visitedTabs
      ..clear()
      ..addAll(GlossaryTab.values.map((_) => _search.isEmpty));
  }

  Future<void> _onKanaUpdate() async {
    _controllers[hiraganaStream]!.add(
      await _processKana(Alphabets.hiragana, hiraganaStream),
    );
    _controllers[katakanaStream]!.add(
      await _processKana(Alphabets.katakana, katakanaStream),
    );
  }

  Future<KanaMap> _processKana(Alphabets alphabet, String streamKey) =>
      _kanaRepository.getSorted(alphabet, _search).then((result) {
        final KanaMap kanaMap = dataMap![streamKey] ?? {};

        // Should only be triggered when a search is started
        if (kanaMap.isNotEmpty) {
          kanaMap.updateAll((key, value) {
            final filtered = result[key]!;

            return value
                .map<KanaDisabled>(
                  (item) => (
                    kana: item.kana,
                    disabled: !filtered.contains(item.kana),
                  ),
                )
                .toList();
          });
          return kanaMap;
        }
        return result.map(
          (key, value) => MapEntry(
            key,
            value.map((kana) => (kana: kana, disabled: false)).toList(),
          ),
        );
      });

  /// Displays a modal with the informations of the selected item.
  Future<void> onTilePressed(dynamic item) async {
    await _dialogService.showModalBottomSheet(
      useSafeArea: true,
      showDragHandle: false,
      isScrollControlled: true,
      builder: (context) => DetailsView(item: item),
    );
  }

  void onSearch(String search) {
    if (search == _search) {
      return;
    }
    _search = search;
    _triggerUpdate(updateKana: true);
  }

  Future<void> onFilterByPressed() async {
    await _dialogService.showModalBottomSheet(
      showDragHandle: true,
      builder:
          (context) => SortFilterByDialog(
            selectedJlptLevel: _selectedJlptLevel,
            selectedKnowledgeLevel: _selectedKnowledgeLevel,
            sortOrder: _sortOrder,
            onSubmit: _updateFilters,
          ),
    );
  }

  void _updateFilters(
    List<JLPTLevel> jlptLevels,
    List<KnowledgeLevel> knowledgeLevels,
    SortOrder sortOrder,
  ) {
    _sortOrder = sortOrder;
    _selectedJlptLevel
      ..clear()
      ..addAll(jlptLevels);
    _selectedKnowledgeLevel
      ..clear()
      ..addAll(knowledgeLevels);
    _triggerUpdate();
  }

  void _triggerUpdate({bool updateKana = false}) {
    kanji.update(_search, _selectedJlptLevel, _sortOrder);
    vocabulary.update(_search, _selectedJlptLevel, _sortOrder);
    if (updateKana) {
      unawaited(_onKanaUpdate());
    }
    _resetVisitedTabs();
    _visitedTabs[tabController.index] = true;
  }

  @override
  Future<void> dispose() async {
    await Future.wait(
      _controllers.values.map((controller) => controller.close()),
    );
    super.dispose();
  }
}
