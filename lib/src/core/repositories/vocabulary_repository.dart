import 'package:kana_to_kanji/src/core/models/vocabulary.dart';
import 'package:kana_to_kanji/src/core/services/vocabulary_service.dart';

class VocabularyRepository {
  final VocabularyService _vocabularyService = VocabularyService();
  final List<Vocabulary> _vocabulary = [];

  Future<List<Vocabulary>> getAll() async {
    if (_vocabulary.isNotEmpty) {
      return _vocabulary;
    }
    print("pouet");
    var vocabulary = await _vocabularyService.getAll();
    _vocabulary.addAll(vocabulary);

    return vocabulary;
  }
}
