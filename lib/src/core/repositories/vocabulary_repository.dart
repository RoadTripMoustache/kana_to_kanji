import 'package:flutter/foundation.dart';
import 'package:kana_to_kanji/src/core/models/vocabulary.dart';
import 'package:kana_to_kanji/src/core/services/vocabulary_service.dart';

class VocabularyRepository {
  late final VocabularyService _vocabularyService;
  @visibleForTesting
  final List<Vocabulary> vocabularies = [];

  /// [vocabularyService] should only be specified for testing purpose
  VocabularyRepository({VocabularyService? vocabularyService}) {
    _vocabularyService = vocabularyService ?? VocabularyService();
  }

  /// Retrieve all the vocabulary
  List<Vocabulary> getAll() {
    if (vocabularies.isNotEmpty) {
      return vocabularies;
    }

    vocabularies.addAll(_vocabularyService.getAll());

    return vocabularies;
  }

  List<Vocabulary> searchVocabularyRomaji(String searchTxt) {
    return _vocabulary
        .where((vocabulary) =>
            vocabulary.romaji.contains(searchTxt) ||
            vocabulary.meanings
                    .lastIndexWhere((meaning) => meaning.contains(searchTxt)) >=
                0)
        .toList();
  }

  List<Vocabulary> searchVocabularyJapanese(String searchTxt) {
    return _vocabulary
        .where((vocabulary) =>
            vocabulary.kanji.contains(searchTxt) ||
            vocabulary.kana.contains(searchTxt))
        .toList();
  }
}
