import 'package:kana_to_kanji/src/core/constants/jlpt_level.dart';
import 'package:kana_to_kanji/src/core/constants/knowledge_level.dart';
import 'package:kana_to_kanji/src/core/constants/sort_order.dart';
import 'package:kana_to_kanji/src/core/models/vocabulary.dart';
import 'package:kana_to_kanji/src/core/services/vocabulary_service.dart';
import 'package:kana_to_kanji/src/core/utils/kana_utils.dart';

class VocabularyRepository {
  final VocabularyService _vocabularyService = VocabularyService();
  final List<Vocabulary> _vocabulary = [];
  final RegExp alphabeticalRegex = RegExp(r'([a-zA-Z])$');

  Future<List<Vocabulary>> getAll() async {
    if (_vocabulary.isNotEmpty) {
      return _vocabulary;
    }
    var vocabulary = await _vocabularyService.getAll();
    _vocabulary.addAll(vocabulary);

    return vocabulary;
  }

  Future<List<Vocabulary>> searchVocabulary(
      String searchTxt,
      List<KnowledgeLevel> selectedKnowledgeLevel,
      List<JLPTLevel> selectedJLPTLevel,
      SortOrder selectedOrder) async {
    if (_vocabulary.isEmpty) {
      var vocabulary = await _vocabularyService.getAll();
      _vocabulary.addAll(vocabulary);
    }
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

    var vocabularyList = _vocabulary
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
