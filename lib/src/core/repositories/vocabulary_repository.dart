import "package:kana_to_kanji/src/core/constants/jlpt_levels.dart";
import "package:kana_to_kanji/src/core/constants/knowledge_level.dart";
import "package:kana_to_kanji/src/core/constants/sort_order.dart";
import "package:kana_to_kanji/src/core/models/resources/vocabulary.dart";
import "package:kana_to_kanji/src/core/repositories/resource_repository.dart";
import "package:kana_to_kanji/src/core/services/resources/vocabulary_service.dart";

class VocabularyRepository
    extends ResourceRepository<Vocabulary, VocabularyService> {
  final RegExp alphabeticalRegex = RegExp(r"([a-zA-Z])$");

  /// Retrieve all the vocabulary
  Future<List<Vocabulary>> getAll() async {
    if (items.isNotEmpty) {
      return items;
    }

    items.addAll(await service.getAll());

    return items;
  }

  Future<List<Vocabulary>> searchVocabulary(
    String searchTxt,
    List<KnowledgeLevel> selectedKnowledgeLevel,
    List<JLPTLevel> selectedJLPTLevel,
    SortOrder selectedOrder,
  ) async {
    await getAll();
    bool Function(Vocabulary) txtFilter = (element) => true;
    if (searchTxt != "" && alphabeticalRegex.hasMatch(searchTxt)) {
      txtFilter =
          (vocabulary) =>
              vocabulary.romaji.contains(searchTxt) ||
              vocabulary.meanings
                  .where((String meaning) => meaning.contains(searchTxt))
                  .toList()
                  .isNotEmpty;
    } else if (searchTxt != "") {
      txtFilter =
          (vocabulary) =>
              vocabulary.kanji.contains(searchTxt) ||
              vocabulary.kana.contains(searchTxt);
    }

    bool Function(Vocabulary) knowledgeLevelFilter = (element) => true;
    if (selectedKnowledgeLevel.isNotEmpty) {
      // TODO : To implement once level is added
      knowledgeLevelFilter = (element) => false;
    }

    bool Function(Vocabulary) jlptLevelFilter = (element) => true;
    if (selectedJLPTLevel.isNotEmpty) {
      jlptLevelFilter =
          (vocabulary) => selectedJLPTLevel.contains(
            JLPTLevel.getValue(vocabulary.jlptLevel),
          );
    }

    final vocabularyList =
        items
            .where(txtFilter)
            .where(knowledgeLevelFilter)
            .where(jlptLevelFilter)
            .toList();

    // TODO: fix sortBySyllables to use kanjiReadings
    // if (selectedOrder == SortOrder.japanese) {
    //   vocabularyList.sort(
    //     (Vocabulary a, Vocabulary b) =>
    //         sortBySyllables(a.kanaSyllables, b.kanaSyllables),
    //   );
    // } else {
    //   vocabularyList.sort(
    //     (Vocabulary a, Vocabulary b) => a.romaji.compareTo(b.romaji),
    //   );
    // }

    return vocabularyList;
  }
}
