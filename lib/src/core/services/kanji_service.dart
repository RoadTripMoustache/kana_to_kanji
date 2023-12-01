import 'package:isar/isar.dart';
import 'package:kana_to_kanji/src/core/models/kanji.dart';
import 'package:kana_to_kanji/src/locator.dart';

class KanjiService {
  final Isar _isar = locator<Isar>();

  /// Get all the kanji
  Future<List<Kanji>> getAll() async {
    return Future.value(_isar.kanjis.where().findAll());
  }
}
