import 'package:kana_to_kanji/src/core/models/kanji.dart';
import 'package:kana_to_kanji/src/core/services/kanji_service.dart';

class KanjiRepository {
  final KanjiService _kanjiService = KanjiService();

  final List<Kanji> _kanjis = [];

  Future<List<Kanji>> getAll() async {
    if (_kanjis.isNotEmpty) {
      return _kanjis;
    }
    var kanjis = await _kanjiService.getAll();
    _kanjis.addAll(kanjis);

    return kanjis;
  }
}
