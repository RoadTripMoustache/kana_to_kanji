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
    final result = await Future.wait([
      _kanjiRepository.getAll(),
      _vocabularyRepository.getAll(),
      _kanaRepository.loadKana()
    ]);

    _hiraganaList.addAll(await _kanaRepository.getHiragana());
    _katakanaList.addAll(await _kanaRepository.getKatakana());
    _kanjiList.addAll(result[0] as List<Kanji>);
    _vocabularyList.addAll(result[1] as List<Vocabulary>);
  }

  void searchGlossary(String searchText) async {
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

  void _searchLatin(String searchText) async {
    final result = await Future.wait([
      _kanaRepository.searchHiraganaRomaji(searchText),
      _kanaRepository.searchKatakanaRomaji(searchText)
    ]);

    _hiraganaList.clear();
    _hiraganaList.addAll(result[0]);
    _katakanaList.clear();
    _katakanaList.addAll(result[1]);
    _kanjiList.clear();
    _kanjiList.addAll(_kanjiRepository.searchKanjiRomaji(searchText));
    _vocabularyList.clear();
    _vocabularyList
        .addAll(_vocabularyRepository.searchVocabularyRomaji(searchText));
  }

  void _searchJapanese(String searchText) async {
    final result = await Future.wait([
      _kanaRepository.searchHiraganaKana(searchText),
      _kanaRepository.searchKatakanaKana(searchText)
    ]);

    _hiraganaList.clear();
    _hiraganaList.addAll(result[0]);
    _katakanaList.clear();
    _katakanaList.addAll(result[1]);
    _kanjiList.clear();
    _kanjiList.addAll(_kanjiRepository.searchKanjiJapanese(searchText));
    _vocabularyList.clear();
    _vocabularyList
        .addAll(_vocabularyRepository.searchVocabularyJapanese(searchText));
  }

  void _displayAll() async {
    final result = await Future.wait([
      _kanaRepository.getHiragana(),
      _kanaRepository.getKatakana(),
      _kanjiRepository.getAll(),
      _vocabularyRepository.getAll()
    ]);

    _hiraganaList.clear();
    _hiraganaList.addAll(result[0] as List<Kana>);
    _katakanaList.clear();
    _katakanaList.addAll(result[1] as List<Kana>);
    _kanjiList.clear();
    _kanjiList.addAll(result[2] as List<Kanji>);
    _vocabularyList.clear();
    _vocabularyList.addAll(result[3] as List<Vocabulary>);
  }
}
