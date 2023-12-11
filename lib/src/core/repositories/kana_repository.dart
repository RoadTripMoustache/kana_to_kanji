import 'package:kana_to_kanji/src/core/constants/alphabets.dart';
import 'package:kana_to_kanji/src/core/constants/knowledge_level.dart';
import 'package:kana_to_kanji/src/core/constants/sort_order.dart';
import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/core/services/kana_service.dart';
import 'package:kana_to_kanji/src/core/utils/kana_utils.dart';

class KanaRepository {
  final KanaService _kanaService = KanaService();
  final List<Kana> _kana = [];
  final RegExp alphabeticalRegex = RegExp(r'([a-zA-Z])$');

  Future loadKana() async {
    if (_kana.isEmpty) {
      _kana.addAll(await _kanaService.getHiragana());
      _kana.addAll(await _kanaService.getKatakana());
    }
  }

  // ------------------ //
  // ----- GROUPS ----- //
  // ------------------ //
  Future<List<Kana>> getByGroupIds(List<int> groupIds) async {
    await loadKana();
    final kana =
        _kana.where((element) => groupIds.contains(element.groupId)).toList();

    return kana;
  }

  Future<List<Kana>> getByGroupId(int groupId) async {
    await loadKana();
    return _kana.where((element) => groupId == element.groupId).toList();
  }

  // -------------------- //
  // ----- HIRAGANA ----- //
  // -------------------- //
  Future<List<Kana>> getHiragana() async {
    await loadKana();
    return _kana
        .where((element) => Alphabets.hiragana == element.alphabet)
        .toList();
  }

  Future<List<Kana>> searchHiragana(
      String searchTxt,
      List<KnowledgeLevel> selectedKnowledgeLevel,
      SortOrder selectedOrder) async {
    await loadKana();
    var txtFilter = (element) => true;
    if (searchTxt != "" && alphabeticalRegex.hasMatch(searchTxt)) {
      txtFilter = (element) => element.romaji.contains(searchTxt);
    } else if (searchTxt != "") {
      txtFilter = (element) => element.kana.contains(searchTxt);
    }

    var knowledgeLevelFilter = (element) => true;
    if (selectedKnowledgeLevel.isNotEmpty) {
      // TODO : To implement once level is added
      knowledgeLevelFilter = (element) => false;
    }
    var kanaList = _kana
        .where((element) => Alphabets.hiragana == element.alphabet)
        .where(txtFilter)
        .where(knowledgeLevelFilter)
        .toList();

    if (selectedOrder == SortOrder.japanese) {
      kanaList.sort((Kana a, Kana b) => sortBySyllables([a.kana], [b.kana]));
    } else {
      kanaList.sort((Kana a, Kana b) {
        return a.romaji.compareTo(b.romaji);
      });
    }

    return kanaList;
  }

  // -------------------- //
  // ----- KATAKANA ----- //
  // -------------------- //
  Future<List<Kana>> getKatakana() async {
    await loadKana();
    return _kana
        .where((element) => Alphabets.katakana == element.alphabet)
        .toList();
  }

  Future<List<Kana>> searchKatakana(
      String searchTxt,
      List<KnowledgeLevel> selectedKnowledgeLevel,
      SortOrder selectedOrder) async {
    await loadKana();
    var txtFilter = (element) => true;
    if (searchTxt != "" && alphabeticalRegex.hasMatch(searchTxt)) {
      txtFilter = (element) => element.romaji.contains(searchTxt);
    } else if (searchTxt != "") {
      txtFilter = (element) => element.kana.contains(searchTxt);
    }

    var knowledgeLevelFilter = (element) => true;
    if (selectedKnowledgeLevel.isNotEmpty) {
      // TODO : To implement once level is added
      knowledgeLevelFilter = (element) => false;
    }
    var kanaList = _kana
        .where((element) => Alphabets.katakana == element.alphabet)
        .where(txtFilter)
        .where(knowledgeLevelFilter)
        .toList();

    if (selectedOrder == SortOrder.japanese) {
      kanaList.sort((Kana a, Kana b) => sortBySyllables([a.kana], [b.kana]));
    } else {
      kanaList.sort((Kana a, Kana b) {
        return a.romaji.compareTo(b.romaji);
      });
    }

    return kanaList;
  }
}
