import "package:isar/isar.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";
import "package:kana_to_kanji/src/core/models/vocabulary.dart";
import "package:kana_to_kanji/src/locator.dart";

class VocabularyService {
  final Isar _isar = locator<Isar>();

  /// Get all the vocabulary
  List<Vocabulary> getAll() => _isar.vocabularys.where().findAll();

  Future delete(ResourceUid resourceUid) async {
    await _isar.writeAsync(
      (isar) =>
          isar.vocabularys
              .where()
              .uid((uid) => uid.uidEqualTo(resourceUid.uid))
              .deleteFirst(),
    );
  }
}
