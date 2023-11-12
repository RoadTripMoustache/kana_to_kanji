import 'package:isar/isar.dart';
import 'package:kana_to_kanji/src/core/constants/alphabets.dart';
import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/core/models/kanji.dart';
import 'package:kana_to_kanji/src/core/models/vocabulary.dart';
import 'package:kana_to_kanji/src/locator.dart';

class VocabularyService {
  final Isar _isar = locator<Isar>();

  /// Get all the vocabulary
  Future<List<Vocabulary>> getAll() async {
    return Future.value(_isar.vocabularys.where().findAll());
  }
}
