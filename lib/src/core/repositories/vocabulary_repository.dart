import 'package:kana_to_kanji/src/core/models/vocabulary.dart';
import 'package:kana_to_kanji/src/core/services/vocabulary_service.dart';

class VocabularyRepository {
  final VocabularyService _vocabularyService = VocabularyService();

  Future<List<Vocabulary>> getAll() {
    return _vocabularyService.getAll();
  }
}
