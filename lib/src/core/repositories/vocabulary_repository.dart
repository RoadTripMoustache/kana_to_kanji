import 'package:kana_to_kanji/src/core/models/vocabulary.dart';
import 'package:kana_to_kanji/src/core/services/vocabulary_service.dart';

class VocabularyRepository {
  final VocabularyService _vocabularyService = VocabularyService();
  final List<Vocabulary> _vocabulary = [];

  Future<List<Vocabulary>> getAll() async {
    if (_vocabulary.isNotEmpty) {
      return _vocabulary;
    }
    var vocabulary = await _vocabularyService.getAll();
    _vocabulary.addAll(vocabulary);

    return vocabulary;
  }

  Future<List<Vocabulary>> searchVocabularyRomaji(String searchTxt) async {
    return _vocabulary
        .where((vocabulary) => vocabulary.romaji.contains(searchTxt) || vocabulary.meanings.where((meaning) => meaning.contains(searchTxt)).toList().isNotEmpty )
        .toList();
  }

  Future<List<Vocabulary>> searchVocabularyJapanese(String searchTxt) async {
    return _vocabulary
        .where((vocabulary) => vocabulary.kanji.contains(searchTxt) || vocabulary.kana.contains(searchTxt) )
        .toList();
  }
}
