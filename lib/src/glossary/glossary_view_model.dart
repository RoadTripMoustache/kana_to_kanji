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

  final List<Kana> _hiraganaList = [];
  final List<Kana> _katakanaList = [];
  final List<Kanji> _kanjiList = [];
  final List<Vocabulary> _vocabularyList = [];

  List<Kana> get hiraganaList => _hiraganaList;

  List<Kana> get katakanaList => _katakanaList;

  List<Kanji> get kanjiList => _kanjiList;

  List<Vocabulary> get vocabularyList => _vocabularyList;

  GlossaryViewModel();

  @override
  Future futureToRun() async {
    _hiraganaList.addAll(_kanaRepository.getHiragana());
    _katakanaList.addAll(_kanaRepository.getKatakana());
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
    _hiraganaList
      ..clear()
      ..addAll(_kanaRepository.searchHiraganaRomaji(searchText));
    _katakanaList
      ..clear()
      ..addAll(_kanaRepository.searchKatakanaRomaji(searchText));
    _kanjiList
      ..clear()
      ..addAll(_kanjiRepository.searchKanjiRomaji(searchText));
    _vocabularyList
      ..clear()
      ..addAll(_vocabularyRepository.searchVocabularyRomaji(searchText));
  }

  void _searchJapanese(String searchText) {
    _hiraganaList
      ..clear()
      ..addAll(_kanaRepository.searchHiraganaKana(searchText));
    _katakanaList
      ..clear()
      ..addAll(_kanaRepository.searchKatakanaKana(searchText));
    _kanjiList
      ..clear()
      ..addAll(_kanjiRepository.searchKanjiJapanese(searchText));
    _vocabularyList
      ..clear()
      ..addAll(_vocabularyRepository.searchVocabularyJapanese(searchText));
  }

  void _displayAll() {
    _hiraganaList
      ..clear()
      ..addAll(_kanaRepository.getHiragana());
    _katakanaList
      ..clear()
      ..addAll(_kanaRepository.getKatakana());
    _kanjiList
      ..clear()
      ..addAll(_kanjiRepository.getAll());
    _vocabularyList
      ..clear()
      ..addAll(_vocabularyRepository.getAll());
  }
}
