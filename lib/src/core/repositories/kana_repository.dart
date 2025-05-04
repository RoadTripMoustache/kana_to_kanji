import "dart:async";

import "package:kana_to_kanji/src/core/constants/alphabets.dart";
import "package:kana_to_kanji/src/core/constants/kana_type.dart";
import "package:kana_to_kanji/src/core/models/resources/kana.dart";
import "package:kana_to_kanji/src/core/models/resources/resource_uid.dart";
import "package:kana_to_kanji/src/core/repositories/resource_repository.dart";
import "package:kana_to_kanji/src/core/services/resources/kana_service.dart";

const _mainKanaLastId = 46;
const _dakutenLastId = 71;

class KanaRepository extends ResourceRepository<Kana, KanaService> {
  final RegExp alphabeticalRegex = RegExp(r"([a-zA-Z])$");

  final Map<KanaTypes, List<Kana>> _sortedHiragana = {};
  final Map<KanaTypes, List<Kana>> _sortedKatakana = {};

  /// Loads kana data asynchronously
  Future<void> initialize() async {
    if (items.isEmpty && !service.isSyncing) {
      items.addAll(await service.getAll());
    }
  }

  @override
  void onServiceUpdate() {
    super.onServiceUpdate();
    unawaited(initialize());
    notifyListeners();
  }

  /// Gets kana by group IDs asynchronously
  Future<List<Kana>> getByGroupIds(List<ResourceUid> groupIds) async {
    final kanaFiltered =
        items.where((element) => groupIds.contains(element.groupUid)).toList();

    return kanaFiltered;
  }

  /// Gets kana by a single group ID asynchronously
  Future<List<Kana>> getByGroupId(ResourceUid groupId) async =>
      getByGroupIds([groupId]);

  /// Retrieve and sort kana by alphabet.
  ///
  /// Note that if the kana aren't loaded yet (e.g. during a sync),
  /// this method will return an empty map.
  Future<Map<KanaTypes, List<Kana>>> getSorted(
    Alphabets alphabet, [
    String search = "",
  ]) async {
    // Skipping as the kana aren't loaded. This can only happen during a sync
    if (items.isEmpty) {
      if (service.isSyncing) {
        return {};
      }
      await initialize();
    }
    final bool isHiragana = alphabet == Alphabets.hiragana;
    final Map<KanaTypes, List<Kana>> sorted =
        isHiragana ? _sortedHiragana : _sortedKatakana;

    if (sorted.isEmpty) {
      final listKana =
          items.where((element) => alphabet == element.alphabet).toList()
            ..sort((Kana a, Kana b) => a.position.compareTo(b.position));

      sorted.addAll({
        KanaTypes.main: listKana.sublist(0, _mainKanaLastId),
        KanaTypes.dakuten: listKana.sublist(_mainKanaLastId, _dakutenLastId),
        KanaTypes.combination: listKana.sublist(_dakutenLastId),
      });
    }

    if (search.isEmpty) {
      return sorted;
    }

    return {
      KanaTypes.main:
          sorted[KanaTypes.main]!
              .where((kana) => _searchKana(search, kana))
              .toList(),
      KanaTypes.dakuten:
          sorted[KanaTypes.dakuten]!
              .where((kana) => _searchKana(search, kana))
              .toList(),
      KanaTypes.combination:
          sorted[KanaTypes.combination]!
              .where((kana) => _searchKana(search, kana))
              .toList(),
    };
  }

  bool _searchKana(String search, Kana kana) {
    if (kana.romaji.contains(search.toLowerCase())) {
      return true;
    }
    if (kana.kana.contains(search)) {
      return true;
    }
    return false;
  }

  /// Gets all hiragana characters asynchronously
  Future<List<Kana>> getHiragana() async {
    final listKana =
        items
            .where((element) => Alphabets.hiragana == element.alphabet)
            .toList();

    // ignore: cascade_invocations
    listKana.sort((Kana a, Kana b) => a.position.compareTo(b.position));

    return listKana;
  }

  /// Gets all katakana characters asynchronously
  Future<List<Kana>> getKatakana() async {
    final listKana =
        items
            .where((element) => Alphabets.katakana == element.alphabet)
            .toList();

    // ignore: cascade_invocations
    listKana.sort((Kana a, Kana b) => a.position.compareTo(b.position));

    return listKana;
  }
}
