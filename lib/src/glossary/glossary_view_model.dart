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
    // Hiragana
    final hiraganaDbList = await _kanaRepository.getHiragana();
    _hiraganaList.addAll(hiraganaDbList);

    // Katakana
    final katatanaDbList = await _kanaRepository.getKatakana();
    katakanaList.addAll(katatanaDbList);

    // Kanji
    final kanjiDbList = await _kanjiRepository.getAll();
    kanjiList.addAll(kanjiDbList);

    // Vocabulary
    final vocabularyDbList = await _vocabularyRepository.getAll();
    vocabularyList.addAll(vocabularyDbList);
  }
}
