import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/core/models/kanji.dart';
import 'package:kana_to_kanji/src/core/services/kana_service.dart';
import 'package:kana_to_kanji/src/core/services/kanji_service.dart';

class KanjiRepository {
  final KanjiService _kanjiService = KanjiService();

  Future<List<Kanji>> getAll() {
    return _kanjiService.getAll();
  }
}
