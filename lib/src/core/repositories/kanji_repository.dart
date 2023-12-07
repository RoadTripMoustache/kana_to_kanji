import 'package:kana_to_kanji/src/core/constants/jlpt_level.dart';
import 'package:kana_to_kanji/src/core/constants/knowledge_level.dart';
import 'package:kana_to_kanji/src/core/models/kanji.dart';
import 'package:kana_to_kanji/src/core/services/kanji_service.dart';

class KanjiRepository {
  final KanjiService _kanjiService = KanjiService();
  final List<Kanji> _kanjis = [];
  final RegExp alphabeticalRegex = RegExp(r'([a-zA-Z])$');

  Future<List<Kanji>> getAll() async {
    if (_kanjis.isNotEmpty) {
      return _kanjis;
    }
    var kanjis = await _kanjiService.getAll();
    _kanjis.addAll(kanjis);

    return kanjis;
  }

  Future<List<Kanji>> searchKanji(
      String searchTxt,
      List<KnowledgeLevel> selectedKnowledgeLevel,
      List<JLPTLevel> selectedJLPTLevel) async {
    if (_kanjis.isEmpty) {
      var kanjis = await _kanjiService.getAll();
      _kanjis.addAll(kanjis);
    }

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
    return _kanjis
        .where(txtFilter)
        .where(knowledgeLevelFilter)
        .where(jlptLevelFilter)
        .toList();
  }
}
