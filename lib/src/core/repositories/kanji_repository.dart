import 'package:flutter/foundation.dart';
import 'package:kana_to_kanji/src/core/constants/jlpt_levels.dart';
import 'package:kana_to_kanji/src/core/constants/knowledge_level.dart';
import 'package:kana_to_kanji/src/core/models/kanji.dart';
import 'package:kana_to_kanji/src/core/services/kanji_service.dart';

class KanjiRepository {
  late final KanjiService _kanjiService;

  @visibleForTesting
  final List<Kanji> kanjis = [];
  final RegExp alphabeticalRegex = RegExp(r'([a-zA-Z])$');

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
      List<JLPTLevel> selectedJLPTLevel) {
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
    return kanjis
        .where(txtFilter)
        .where(knowledgeLevelFilter)
        .where(jlptLevelFilter)
        .toList();
  }
}
