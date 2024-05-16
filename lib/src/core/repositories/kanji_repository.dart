import "package:flutter/foundation.dart";
import "package:kana_to_kanji/src/core/constants/jlpt_levels.dart";
import "package:kana_to_kanji/src/core/constants/knowledge_level.dart";
import "package:kana_to_kanji/src/core/constants/sort_order.dart";
import "package:kana_to_kanji/src/core/models/kanji.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";
import "package:kana_to_kanji/src/core/services/kanji_service.dart";
import "package:kana_to_kanji/src/core/utils/kana_utils.dart";

class KanjiRepository {
  late final KanjiService _kanjiService;

  @visibleForTesting
  final List<Kanji> kanjis = [];
  final RegExp alphabeticalRegex = RegExp(r"([a-zA-Z])$");

  /// [kanjiService] should only be used for testing
  KanjiRepository({KanjiService? kanjiService}) {
    _kanjiService = kanjiService ?? KanjiService();
  }

  /// Retrieve all the kanji from the database
  List<Kanji> getAll() {
    if (kanjis.isNotEmpty) {
      return kanjis;
    }
    kanjis.addAll(_kanjiService.getAll());

    return kanjis;
  }

  List<Kanji> searchKanji(
      String searchTxt,
      List<KnowledgeLevel> selectedKnowledgeLevel,
      List<JLPTLevel> selectedJLPTLevel,
      SortOrder selectedOrder) {
    getAll();

    var txtFilter = (Kanji element) => true;
    if (searchTxt != "" && alphabeticalRegex.hasMatch(searchTxt)) {
      txtFilter = (kanji) => kanji.meanings
          .where((meaning) => meaning.contains(searchTxt))
          .toList()
          .isNotEmpty;
    } else if (searchTxt != "") {
      txtFilter = (kanji) =>
          kanji.kanji == searchTxt ||
          kanji.kunReadings
              .where((String reading) => reading.contains(searchTxt))
              .toList()
              .isNotEmpty ||
          kanji.onReadings
              .where((String reading) => reading.contains(searchTxt))
              .toList()
              .isNotEmpty;
    }

    var knowledgeLevelFilter = (Kanji element) => true;
    if (selectedKnowledgeLevel.isNotEmpty) {
      // TODO : To implement once level is added
      knowledgeLevelFilter = (Kanji element) => false;
    }

    var jlptLevelFilter = (Kanji element) => true;
    if (selectedJLPTLevel.isNotEmpty) {
      jlptLevelFilter = (Kanji kanji) =>
          selectedJLPTLevel.contains(JLPTLevel.getValue(kanji.jlptLevel));
    }
    final kanjiList = kanjis
        .where(txtFilter)
        .where(knowledgeLevelFilter)
        .where(jlptLevelFilter)
        .toList();

    if (selectedOrder == SortOrder.japanese) {
      kanjiList.sort((Kanji a, Kanji b) =>
          sortBySyllables(a.jpSortSyllables, b.jpSortSyllables));
    } else {
      kanjiList
          .sort((Kanji a, Kanji b) => a.meanings[0].compareTo(b.meanings[0]));
    }

    return kanjiList;
  }

  Future delete(ResourceUid uid) async {
    kanjis.removeWhere((element) => element.uid == uid);
    await _kanjiService.delete(uid);
  }
}
