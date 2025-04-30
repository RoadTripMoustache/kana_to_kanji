import "package:kana_to_kanji/src/core/constants/alphabets.dart";
import "package:kana_to_kanji/src/core/constants/knowledge_level.dart";
import "package:kana_to_kanji/src/core/models/resources/kana.dart";
import "package:kana_to_kanji/src/core/models/resources/resource_uid.dart";
import "package:kana_to_kanji/src/core/repositories/resource_repository.dart";
import "package:kana_to_kanji/src/core/services/resources/kana_service.dart";

class KanaRepository extends ResourceRepository<Kana, KanaService> {
  final RegExp alphabeticalRegex = RegExp(r"([a-zA-Z])$");

  /// [kanaService] should only be used for testing
  KanaRepository({KanaService? kanaService})
    : super(service: kanaService ?? KanaService());

  /// Loads kana data asynchronously
  Future<void> loadKana() async {
    if (items.isEmpty) {
      items.addAll([
        ...await service.getHiragana(),
        ...await service.getKatakana(),
      ]);
    }
  }

  /// Gets kana by group IDs asynchronously
  Future<List<Kana>> getByGroupIds(List<ResourceUid> groupIds) async {
    await loadKana();
    final kanaFiltered =
        items.where((element) => groupIds.contains(element.groupUid)).toList();

    return kanaFiltered;
  }

  /// Gets kana by a single group ID asynchronously
  Future<List<Kana>> getByGroupId(ResourceUid groupId) async =>
      getByGroupIds([groupId]);

  /// Gets all hiragana characters asynchronously
  Future<List<Kana>> getHiragana() async {
    await loadKana();
    final listKana =
        items
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
        items
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
        items
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
        items
            .where((element) => Alphabets.katakana == element.alphabet)
            .where(txtFilter)
            .where(knowledgeLevelFilter)
            .toList();

    // ignore: cascade_invocations
    listKana.sort((Kana a, Kana b) => a.position.compareTo(b.position));

    return listKana;
  }
}
