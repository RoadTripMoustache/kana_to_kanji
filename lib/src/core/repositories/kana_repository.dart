import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/core/services/kana_service.dart';

class KanaRepository {
  final KanaService _kanaService = KanaService();
  final List<Kana> _kana = [];

  Future<List<Kana>> getByGroupIds(List<int> groupIds) async {
    final kana =
        _kana.where((element) => groupIds.contains(element.groupId)).toList();

    if (kana.isEmpty) {
      kana.addAll(await _kanaService.getByGroupIds(groupIds));
      _kana.addAll(kana);
    }

    return kana;
  }

  Future<List<Kana>> getByGroupId(int groupId) async {
    return _kanaService.getByGroupId(groupId);
  }

  Future<List<Kana>> getHiragana() async {
    return _kanaService.getHiragana();
  }

  Future<List<Kana>> getKatakana() async {
    return _kanaService.getKatakana();
  }
}
