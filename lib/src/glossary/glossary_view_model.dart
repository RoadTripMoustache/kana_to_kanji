import 'package:kana_to_kanji/src/core/constants/jlpt_level.dart';
import 'package:kana_to_kanji/src/core/constants/knowledge_level.dart';
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
  final List<JLPTLevel> _selectedJlptLevel = [];
  final List<KnowledgeLevel> _selectedKnowledgeLevel = [];
  String _currentSearch = "";

  List<Kana> get hiraganaList => _hiraganaList;

  List<Kana> get katakanaList => _katakanaList;

  List<Kanji> get kanjiList => _kanjiList;

  List<Vocabulary> get vocabularyList => _vocabularyList;
  List<JLPTLevel> get selectedJlptLevel => _selectedJlptLevel;
  List<KnowledgeLevel> get selectedKnowledgeLevel => _selectedKnowledgeLevel;

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
    _currentSearch = searchText;
    _updateGlossaryList();
    notifyListeners();
  }

  void filterGlossary() async {
    await _updateGlossaryList();
    notifyListeners();
  }

  Future _updateGlossaryList() async {
    final result = await Future.wait([
      _kanaRepository.searchHiragana(_currentSearch, _selectedKnowledgeLevel),
      _kanaRepository.searchKatakana(_currentSearch, _selectedKnowledgeLevel),
      _kanjiRepository.searchKanji(
          _currentSearch, _selectedKnowledgeLevel, _selectedJlptLevel),
      _vocabularyRepository.searchVocabulary(
          _currentSearch, _selectedKnowledgeLevel, _selectedJlptLevel)
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
