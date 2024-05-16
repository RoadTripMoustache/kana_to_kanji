import "package:go_router/go_router.dart";
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

  GlossaryViewModel(this.router);

  @override
  Future futureToRun() async {
    _hiraganaList.addAll(_kanaRepository
        .getHiragana()
        .map((kana) => (kana: kana, disabled: false)));
    _katakanaList.addAll(_kanaRepository
        .getKatakana()
        .map((kana) => (kana: kana, disabled: false)));
    _kanjiList.addAll(_kanjiRepository.getAll());
    _vocabularyList.addAll(_vocabularyRepository.getAll());
  }

  void searchGlossary(String searchText) {
    _currentSearch = searchText;
    _setToDisplay();
    notifyListeners();
  }

  void filterGlossary() {
    _setToDisplay();
    notifyListeners();
  }

  void sortGlossary(SortOrder newSelectedOrder) {
    selectedOrder = newSelectedOrder;
    _setToDisplay();
    notifyListeners();
  }

  void _setToDisplay() {
    final hiraganaIdsFiltered = _kanaRepository
        .searchHiragana(_currentSearch, _selectedKnowledgeLevel)
        .map((e) => e.id);
    for (final ({Kana kana, bool disabled}) pair in _hiraganaList) {
      _hiraganaList[pair.kana.id] = (
        kana: pair.kana,
        disabled: !hiraganaIdsFiltered.contains(pair.kana.id)
      );
    }

    final katakanaIdsFiltered = _kanaRepository
        .searchKatakana(_currentSearch, _selectedKnowledgeLevel)
        .map((e) => e.id);
    for (final ({Kana kana, bool disabled}) pair in _katakanaList) {
      _katakanaList[pair.kana.id - _hiraganaList.length] = (
        kana: pair.kana,
        disabled: !katakanaIdsFiltered.contains(pair.kana.id)
      );
    }

    _kanjiList
      ..clear()
      ..addAll(_kanjiRepository.searchKanji(_currentSearch,
          _selectedKnowledgeLevel, _selectedJlptLevel, selectedOrder));
    _vocabularyList
      ..clear()
      ..addAll(_vocabularyRepository.searchVocabulary(_currentSearch,
          _selectedKnowledgeLevel, _selectedJlptLevel, selectedOrder));
  }

  Future<void> onTilePressed(dynamic item) async {
    await _dialogService.showModalBottomSheet(
        useSafeArea: true,
        showDragHandle: true,
        isScrollControlled: true,
        builder: (context) => DetailsView(item: item));
  }
}
