import "package:isar/isar.dart";
import "package:kana_to_kanji/src/core/models/kanji.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";
import "package:kana_to_kanji/src/locator.dart";

class KanjiService {
  final Isar _isar = locator<Isar>();

  /// Get all the kanji
  List<Kanji> getAll() => _isar.kanjis.where().findAll();

  Future delete(ResourceUid resourceUid) async {
    await _isar.writeAsync(
      (isar) =>
          isar.kanjis
              .where()
              .uid((uid) => uid.uidEqualTo(resourceUid.uid))
              .deleteFirst(),
    );
  }
}
