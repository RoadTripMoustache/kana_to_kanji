import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/core/models/kanji.dart';
import 'package:kana_to_kanji/src/core/models/vocabulary.dart';
import 'package:kana_to_kanji/src/core/repositories/kana_repository.dart';
import 'package:kana_to_kanji/src/core/repositories/kanji_repository.dart';
import 'package:kana_to_kanji/src/core/repositories/vocabulary_repository.dart';
import 'package:kana_to_kanji/src/locator.dart';
import 'package:stacked/stacked.dart';

class GlossaryViewModel extends FutureViewModel {
  final KanaRepository _kanaRepository = locator<KanaRepository>();
  final KanjiRepository _kanjiRepository = locator<KanjiRepository>();
  final VocabularyRepository _vocabularyRepository =
      locator<VocabularyRepository>();

  final List<({Kana kana, bool disabled})> _hiraganaList = [];
  final List<({Kana kana, bool disabled})> _katakanaList = [];
  final List<Kanji> _kanjiList = [];
  final List<Vocabulary> _vocabularyList = [];

  List<({Kana kana, bool disabled})> get hiraganaList => _hiraganaList;

  List<({Kana kana, bool disabled})> get katakanaList => _katakanaList;

  List<Kanji> get kanjiList => _kanjiList;

  List<Vocabulary> get vocabularyList => _vocabularyList;

  GlossaryViewModel();

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
    RegExp alphabeticalRegex = RegExp(r'([a-zA-Z])$');
    if (searchText == "") {
      _displayAll();
    } else if (alphabeticalRegex.hasMatch(searchText)) {
      _searchLatin(searchText);
    } else {
      _searchJapanese(searchText);
    }
    notifyListeners();
  }

  void _searchLatin(String searchText) {
    _setToDisplay(
        _kanaRepository.searchHiraganaRomaji(searchText),
        _kanaRepository.searchKatakanaRomaji(searchText),
        _kanjiRepository.searchKanjiRomaji(searchText),
        _vocabularyRepository.searchVocabularyRomaji(searchText));
  }

  void _searchJapanese(String searchText) {
    _setToDisplay(
        _kanaRepository.searchHiraganaKana(searchText),
        _kanaRepository.searchKatakanaKana(searchText),
        _kanjiRepository.searchKanjiJapanese(searchText),
        _vocabularyRepository.searchVocabularyJapanese(searchText));
  }

  void _displayAll() {
    _setToDisplay(_kanaRepository.getHiragana(), _kanaRepository.getKatakana(),
        _kanjiRepository.getAll(), _vocabularyRepository.getAll());
  }

  void _setToDisplay(List<Kana> hiragana, List<Kana> katakana,
      List<Kanji> kanji, List<Vocabulary> vocabulary) {
    final hiraganaIdsFiltered = hiragana.map((e) => e.id);
    for (({Kana kana, bool disabled}) pair in _hiraganaList) {
      _hiraganaList[pair.kana.id] = (
        kana: pair.kana,
        disabled: !hiraganaIdsFiltered.contains(pair.kana.id)
      );
    }

    final katakanaIdsFiltered = katakana.map((e) => e.id);
    for (({Kana kana, bool disabled}) pair in _katakanaList) {
      _katakanaList[pair.kana.id - 107] = (
        kana: pair.kana,
        disabled: !katakanaIdsFiltered.contains(pair.kana.id)
      );
    }

    _kanjiList
      ..clear()
      ..addAll(kanji);
    _vocabularyList
      ..clear()
      ..addAll(vocabulary);
  }
}
