import 'package:kana_to_kanji/src/core/models/vocabulary.dart';
import 'package:kana_to_kanji/src/core/services/vocabulary_service.dart';

class VocabularyRepository {
  final VocabularyService _vocabularyService = VocabularyService();
  final List<Vocabulary> _vocabulary = [];

  List<Vocabulary> getAll() {
    if (_vocabulary.isNotEmpty) {
      return _vocabulary;
    }
    var vocabulary = _vocabularyService.getAll();
    _vocabulary.addAll(vocabulary);

    return vocabulary;
  }
}
