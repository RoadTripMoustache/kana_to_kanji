import 'package:kana_to_kanji/src/core/constants/alphabets.dart';
import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/core/services/kana_service.dart';

class KanaRepository {
  final KanaService _kanaService = KanaService();
  final List<Kana> _kana = [];

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

  Future<List<Kana>> searchHiraganaRomaji(String searchTxt) async {
    await loadKana();
    return _kana
        .where((element) =>
            Alphabets.hiragana == element.alphabet &&
            element.romaji.contains(searchTxt))
        .toList();
  }

  Future<List<Kana>> searchHiraganaKana(String searchTxt) async {
    await loadKana();
    return _kana
        .where((element) =>
            Alphabets.hiragana == element.alphabet &&
            element.kana.contains(searchTxt))
        .toList();
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

  Future<List<Kana>> searchKatakanaRomaji(String searchTxt) async {
    await loadKana();
    return _kana
        .where((element) =>
            Alphabets.katakana == element.alphabet &&
            element.romaji.contains(searchTxt))
        .toList();
  }

  Future<List<Kana>> searchKatakanaKana(String searchTxt) async {
    await loadKana();
    return _kana
        .where((element) =>
            Alphabets.katakana == element.alphabet &&
            element.kana.contains(searchTxt))
        .toList();
  }
}
