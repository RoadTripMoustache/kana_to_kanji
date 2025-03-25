import "package:isar/isar.dart";
import "package:kana_to_kanji/src/core/constants/alphabets.dart";
import "package:kana_to_kanji/src/core/models/kana.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";
import "package:kana_to_kanji/src/locator.dart";

class KanaService {
  final Isar _isar = locator<Isar>();

  /// Get all the kana related to the group ids given in parameter.
  List<Kana> getByGroupIds(List<ResourceUid> groupIds) {
    if (groupIds.isEmpty) {
      return _isar.kanas.where().findAll();
    }

    var kanaQuery = _isar.kanas.where().groupUid(
      (q) => q.uidEqualTo(groupIds[0].uid),
    );

    for (var i = 1; i < groupIds.length; i++) {
      kanaQuery = kanaQuery.or().groupUid((q) => q.uidEqualTo(groupIds[i].uid));
    }

    return kanaQuery.findAll();
  }

  /// Get all the kana related to the group id given in parameter.
  List<Kana> getByGroupId(ResourceUid groupId) => getByGroupIds([groupId]);

  List<Kana> getKana(Alphabets alphabet) {
    final kanaQuery = _isar.kanas.where().alphabetEqualTo(alphabet);

    return kanaQuery.findAll();
  }

  List<Kana> getHiragana() => getKana(Alphabets.hiragana);

  List<Kana> getKatakana() => getKana(Alphabets.katakana);

  Future delete(ResourceUid resourceUid) async {
    await _isar.writeAsync(
      (isar) =>
          isar.kanas
              .where()
              .uid((uid) => uid.uidEqualTo(resourceUid.uid))
              .deleteFirst(),
    );
  }
}
