import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/src/core/constants/glossary_tab.dart";
import "package:kana_to_kanji/src/core/constants/jlpt_levels.dart";
import "package:kana_to_kanji/src/core/constants/knowledge_level.dart";
import "package:kana_to_kanji/src/core/constants/sort_order.dart";
import "package:kana_to_kanji/src/core/models/kana.dart";
import "package:kana_to_kanji/src/core/models/kanji.dart";
import "package:kana_to_kanji/src/core/models/vocabulary.dart";
import "package:kana_to_kanji/src/core/repositories/kana_repository.dart";
import "package:kana_to_kanji/src/core/repositories/kanji_repository.dart";
import "package:kana_to_kanji/src/core/repositories/vocabulary_repository.dart";
import "package:kana_to_kanji/src/core/services/dialog_service.dart";
import "package:kana_to_kanji/src/glossary/details/details_view.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:stacked/stacked.dart";

class GlossaryViewModel extends FutureViewModel {
  final GoRouter router;
  final TabController _tabController;
  int _currentTab = 0;

  final DialogService _dialogService = locator<DialogService>();
  final KanaRepository _kanaRepository = locator<KanaRepository>();
  final KanjiRepository _kanjiRepository = locator<KanjiRepository>();
  final VocabularyRepository _vocabularyRepository =
      locator<VocabularyRepository>();

  final List<({Kana kana, bool disabled})> _hiraganaList = [];
  final List<({Kana kana, bool disabled})> _katakanaList = [];
  final List<Kanji> _kanjiList = [];
  final List<Vocabulary> _vocabularyList = [];
  final List<JLPTLevel> _selectedJlptLevel = [];
  final List<KnowledgeLevel> _selectedKnowledgeLevel = [];
  String _currentSearch = "";

  List<({Kana kana, bool disabled})> get hiraganaList => _hiraganaList;

  List<({Kana kana, bool disabled})> get katakanaList => _katakanaList;

  List<Kanji> get kanjiList => _kanjiList;

  List<Vocabulary> get vocabularyList => _vocabularyList;

  List<JLPTLevel> get selectedJlptLevel => _selectedJlptLevel;

  List<KnowledgeLevel> get selectedKnowledgeLevel => _selectedKnowledgeLevel;
  SortOrder selectedOrder = SortOrder.japanese;

  GlossaryViewModel(this.router, this._tabController);

  @override
  Future futureToRun() async {
    _tabController.addListener(_handleTabSelection);
    _setToDisplay();
  }

  void _handleTabSelection() {
    if (_currentTab != _tabController.index) {
      _currentTab = _tabController.index;
      _setToDisplay();
    }
  }

  /// Update the current searched text and update the lists to display.
  void searchGlossary(String searchText) {
    _currentSearch = searchText;
    _setToDisplay();
    notifyListeners();
  }

  /// Triggers list update following the change of filters.
  void filterGlossary() {
    _setToDisplay();
    notifyListeners();
  }

  /// Update the selected order and update the lists to display.
  void sortGlossary(SortOrder newSelectedOrder) {
    selectedOrder = newSelectedOrder;
    _setToDisplay();
    notifyListeners();
  }

  /// Update the list of values to display of the current tab.
  void _setToDisplay() {
    switch (GlossaryTab.getValue(_tabController.index)) {
      case GlossaryTab.hiragana:
        _updateHiraganaList();
      case GlossaryTab.katakana:
        _updateKatakanaList();
      case GlossaryTab.kanji:
        _updateKanjiList();
      case GlossaryTab.vocabulary:
        _updateVocabularyList();
    }
  }

  /// Update the hiragana list to display based on the current search
  /// and selected knowledge levels.
  void _updateHiraganaList() {
    if (_hiraganaList.isEmpty) {
      _hiraganaList.addAll(_kanaRepository
          .getHiragana()
          .map((kana) => (kana: kana, disabled: false)));
    }
    final hiraganaIdsFiltered = _kanaRepository
        .searchHiragana(_currentSearch, _selectedKnowledgeLevel)
        .map((e) => e.uid);
    for (final ({Kana kana, bool disabled}) pair in _hiraganaList) {
      _hiraganaList[pair.kana.position] = (
        kana: pair.kana,
        disabled: !hiraganaIdsFiltered.contains(pair.kana.uid)
      );
    }
  }

  /// Update the katakana list to display based on the current search
  /// and selected knowledge levels.
  void _updateKatakanaList() {
    if (_katakanaList.isEmpty) {
      _katakanaList.addAll(_kanaRepository
          .getKatakana()
          .map((kana) => (kana: kana, disabled: false)));
    }
    final katakanaIdsFiltered = _kanaRepository
        .searchKatakana(_currentSearch, _selectedKnowledgeLevel)
        .map((e) => e.uid);
    for (final ({Kana kana, bool disabled}) pair in _katakanaList) {
      _katakanaList[pair.kana.position] = (
        kana: pair.kana,
        disabled: !katakanaIdsFiltered.contains(pair.kana.uid)
      );
    }
  }

  /// Update the kanji list to display based on all the filter/search configurations.
  void _updateKanjiList() {
    _kanjiList
      ..clear()
      ..addAll(_kanjiRepository.searchKanji(
        _currentSearch,
        _selectedKnowledgeLevel,
        _selectedJlptLevel,
        selectedOrder,
      ));
  }

  /// Update the vocabulary list to display based on all the filter/search configurations.
  void _updateVocabularyList() {
    _vocabularyList
      ..clear()
      ..addAll(_vocabularyRepository.searchVocabulary(
        _currentSearch,
        _selectedKnowledgeLevel,
        _selectedJlptLevel,
        selectedOrder,
      ));
  }

  /// Displays a modal with the informations of the selected item.
  Future<void> onTilePressed(dynamic item) async {
    await _dialogService.showModalBottomSheet(
        useSafeArea: true,
        showDragHandle: true,
        isScrollControlled: true,
        builder: (context) => DetailsView(item: item));
  }
}
