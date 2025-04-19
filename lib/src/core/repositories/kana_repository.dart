import "package:flutter/foundation.dart";
import "package:kana_to_kanji/src/core/constants/alphabets.dart";
import "package:kana_to_kanji/src/core/constants/knowledge_level.dart";
import "package:kana_to_kanji/src/core/models/kana.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";
import "package:kana_to_kanji/src/core/services/kana_service.dart";

class KanaRepository {
  late final KanaService _kanaService;
  @visibleForTesting
  final List<Kana> kana = [];
  final RegExp alphabeticalRegex = RegExp(r"([a-zA-Z])$");

  /// [kanaService] should only be used for testing
  KanaRepository({KanaService? kanaService}) {
    _kanaService = kanaService ?? KanaService();
  }

  /// Loads kana data asynchronously
  Future<void> loadKana() async {
    if (kana.isEmpty) {
      kana.addAll([
        ...await _kanaService.getHiragana(),
        ...await _kanaService.getKatakana(),
      ]);
    }
  }

  /// Gets kana by group IDs asynchronously
  Future<List<Kana>> getByGroupIds(List<ResourceUid> groupIds) async {
    await loadKana();
    final kanaFiltered =
        kana.where((element) => groupIds.contains(element.groupUid)).toList();

    return kanaFiltered;
  }

  /// Gets kana by a single group ID asynchronously
  Future<List<Kana>> getByGroupId(ResourceUid groupId) async =>
      getByGroupIds([groupId]);

  /// Gets all hiragana characters asynchronously
  Future<List<Kana>> getHiragana() async {
    await loadKana();
    final listKana =
        kana
            .where((element) => Alphabets.hiragana == element.alphabet)
            .toList();

    // ignore: cascade_invocations
    listKana.sort((Kana a, Kana b) => a.position.compareTo(b.position));

    return listKana;
  }

  /// Searches hiragana characters asynchronously
  Future<List<Kana>> searchHiragana(
    String searchTxt,
    List<KnowledgeLevel> selectedKnowledgeLevel,
  ) async {
    /// If is there more than 3 characters in the searchTxt,
    /// return directly an empty list as anything will match.
    if (searchTxt.length > 3) {
      return List.empty();
    }

    await loadKana();
    bool Function(Kana) txtFilter = (Kana element) => true;
    if (searchTxt != "" && alphabeticalRegex.hasMatch(searchTxt)) {
      txtFilter = (Kana element) => element.romaji.contains(searchTxt);
    } else if (searchTxt != "") {
      txtFilter = (Kana element) => element.kana.contains(searchTxt);
    }

    bool Function(Kana) knowledgeLevelFilter = (Kana element) => true;
    if (selectedKnowledgeLevel.isNotEmpty) {
      // TODO : To implement once level is added
      knowledgeLevelFilter = (element) => false;
    }
    final listKana =
        kana
            .where((element) => Alphabets.hiragana == element.alphabet)
            .where(txtFilter)
            .where(knowledgeLevelFilter)
            .toList();

    // ignore: cascade_invocations
    listKana.sort((Kana a, Kana b) => a.position.compareTo(b.position));

    return listKana;
  }

  /// Gets all katakana characters asynchronously
  Future<List<Kana>> getKatakana() async {
    await loadKana();
    final listKana =
        kana
            .where((element) => Alphabets.katakana == element.alphabet)
            .toList();

    // ignore: cascade_invocations
    listKana.sort((Kana a, Kana b) => a.position.compareTo(b.position));

    return listKana;
  }

  /// Searches katakana characters asynchronously
  Future<List<Kana>> searchKatakana(
    String searchTxt,
    List<KnowledgeLevel> selectedKnowledgeLevel,
  ) async {
    /// If is there more than 3 characters in the searchTxt,
    /// return directly an empty list as anything will match.
    if (searchTxt.length > 3) {
      return List.empty();
    }

    await loadKana();
    bool Function(Kana) txtFilter = (element) => true;
    if (searchTxt != "" && alphabeticalRegex.hasMatch(searchTxt)) {
      txtFilter = (element) => element.romaji.contains(searchTxt);
    } else if (searchTxt != "") {
      txtFilter = (element) => element.kana.contains(searchTxt);
    }

    bool Function(Kana) knowledgeLevelFilter = (element) => true;
    if (selectedKnowledgeLevel.isNotEmpty) {
      // TODO : To implement once level is added
      knowledgeLevelFilter = (element) => false;
    }

    final listKana =
        kana
            .where((element) => Alphabets.katakana == element.alphabet)
            .where(txtFilter)
            .where(knowledgeLevelFilter)
            .toList();

    // ignore: cascade_invocations
    listKana.sort((Kana a, Kana b) => a.position.compareTo(b.position));

    return listKana;
  }

  /// Deletes a kana by its UID asynchronously
  Future<void> delete(ResourceUid uid) async {
    kana.removeWhere((element) => element.uid == uid);
    await _kanaService.delete(uid);
  }
}
