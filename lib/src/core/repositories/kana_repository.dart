import 'package:kana_to_kanji/src/core/constants/alphabets.dart';
import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/core/services/kana_service.dart';

class KanaRepository {
  final KanaService _kanaService = KanaService();
  final List<Kana> _kana = [];

  void loadKana() {
    if (_kana.isEmpty) {
      _kana.addAll(
          [..._kanaService.getHiragana(), ..._kanaService.getKatakana()]);
    }
  }

  List<Kana> getByGroupIds(List<int> groupIds) {
    loadKana();
    final kana =
        _kana.where((element) => groupIds.contains(element.groupId)).toList();

    return kana;
  }

  List<Kana> getByGroupId(int groupId) {
    loadKana();
    return _kana.where((element) => groupId == element.groupId).toList();
  }

  List<Kana> getHiragana() {
    loadKana();
    return _kana
        .where((element) => Alphabets.hiragana == element.alphabet)
        .toList();
  }

  List<Kana> getKatakana() {
    loadKana();
    return _kana
        .where((element) => Alphabets.katakana == element.alphabet)
        .toList();
  }
}
