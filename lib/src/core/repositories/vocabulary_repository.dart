import 'package:flutter/foundation.dart';
import 'package:kana_to_kanji/src/core/constants/jlpt_levels.dart';
import 'package:kana_to_kanji/src/core/constants/knowledge_level.dart';
import 'package:kana_to_kanji/src/core/constants/regexp.dart';
import 'package:kana_to_kanji/src/core/constants/sort_order.dart';
import 'package:kana_to_kanji/src/core/models/vocabulary.dart';
import 'package:kana_to_kanji/src/core/services/vocabulary_service.dart';
import 'package:kana_to_kanji/src/core/utils/kana_utils.dart';

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

  List<Vocabulary> searchVocabulary(
      String searchTxt,
      List<KnowledgeLevel> selectedKnowledgeLevel,
      List<JLPTLevel> selectedJLPTLevel,
      SortOrder selectedOrder) {
    getAll();
    var txtFilter = (Vocabulary element) => true;
    if (searchTxt != "" && alphabeticalRegex.hasMatch(searchTxt)) {
      txtFilter = (Vocabulary vocabulary) =>
          vocabulary.romaji.contains(searchTxt) ||
          vocabulary.meanings
              .where((String meaning) => meaning.contains(searchTxt))
              .toList()
              .isNotEmpty;
    } else if (searchTxt != "") {
      txtFilter = (Vocabulary vocabulary) =>
          vocabulary.kanji.contains(searchTxt) ||
          vocabulary.kana.contains(searchTxt);
    }

    var knowledgeLevelFilter = (element) => true;
    if (selectedKnowledgeLevel.isNotEmpty) {
      // TODO : To implement once level is added
      knowledgeLevelFilter = (element) => false;
    }

    var jlptLevelFilter = (element) => true;
    if (selectedJLPTLevel.isNotEmpty) {
      jlptLevelFilter = (vocabulary) =>
          selectedJLPTLevel.contains(JLPTLevel.getValue(vocabulary.jlptLevel));
    }

    final vocabularyList = vocabularies
        .where(txtFilter)
        .where(knowledgeLevelFilter)
        .where(jlptLevelFilter)
        .toList();

    if (selectedOrder == SortOrder.japanese) {
      vocabularyList.sort((Vocabulary a, Vocabulary b) =>
          sortBySyllables(a.kanaSyllables, b.kanaSyllables));
    } else {
      vocabularyList.sort((Vocabulary a, Vocabulary b) {
        return a.romaji.compareTo(b.romaji);
      });
    }

    return vocabularyList;
  }
}
