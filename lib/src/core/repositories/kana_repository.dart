import 'package:flutter/foundation.dart';
import 'package:kana_to_kanji/src/core/constants/alphabets.dart';
import 'package:kana_to_kanji/src/core/constants/knowledge_level.dart';
import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/core/services/kana_service.dart';

class KanaRepository {
  late final KanaService _kanaService;
  @visibleForTesting
  final List<Kana> kana = [];
  final RegExp alphabeticalRegex = RegExp(r'([a-zA-Z])$');

  /// [kanaService] should only be used for testing
  KanaRepository({KanaService? kanaService}) {
    _kanaService = kanaService ?? KanaService();
  }

  void loadKana() {
    if (kana.isEmpty) {
      kana.addAll(
          [..._kanaService.getHiragana(), ..._kanaService.getKatakana()]);
    }
  }

  List<Kana> getByGroupIds(List<int> groupIds) {
    loadKana();
    final kanaFiltered =
        kana.where((element) => groupIds.contains(element.groupId)).toList();

    return kanaFiltered;
  }

  List<Kana> getByGroupId(int groupId) {
    return getByGroupIds([groupId]);
  }

  List<Kana> getHiragana() {
    loadKana();
    return kana
        .where((element) => Alphabets.hiragana == element.alphabet)
        .toList();
  }

  List<Kana> searchHiragana(
      String searchTxt, List<KnowledgeLevel> selectedKnowledgeLevel) {
    /// If is there more than 3 characters in the searchTxt, return directly an empty list as anything will match.
    if (searchTxt.length > 3) {
      return List.empty(growable: false);
    }

    loadKana();
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
    return kana
        .where((element) => Alphabets.hiragana == element.alphabet)
        .where(txtFilter)
        .where(knowledgeLevelFilter)
        .toList();
  }

  List<Kana> getKatakana() {
    loadKana();
    return kana
        .where((element) => Alphabets.katakana == element.alphabet)
        .toList();
  }

  List<Kana> searchKatakana(
      String searchTxt, List<KnowledgeLevel> selectedKnowledgeLevel) {
    /// If is there more than 3 characters in the searchTxt, return directly an empty list as anything will match.
    if (searchTxt.length > 3) {
      return List.empty(growable: false);
    }

    loadKana();
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
    return kana
        .where((element) => Alphabets.katakana == element.alphabet)
        .where(txtFilter)
        .where(knowledgeLevelFilter)
        .toList();
  }
}
