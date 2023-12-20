import 'package:isar/isar.dart';
import 'package:kana_to_kanji/src/core/constants/alphabets.dart';
import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/locator.dart';

class KanaService {
  final Isar _isar = locator<Isar>();

  /// Get all the kana related to the group ids given in parameter.
  List<Kana> getByGroupIds(List<int> groupIds) {
    if (groupIds.isEmpty) {
      return _isar.kanas.where().findAll();
    }

    var kanaQuery = _isar.kanas.where().groupIdEqualTo(groupIds[0]);

    for (var i = 1; i < groupIds.length; i++) {
      kanaQuery = kanaQuery.or().groupIdEqualTo(groupIds[i]);
    }

    return kanaQuery.findAll();
  }

  /// Get all the kana related to the group id given in parameter.
  List<Kana> getByGroupId(int groupId) {
    return getByGroupIds([groupId]);
  }

  List<Kana> getKana(Alphabets alphabet) {
    var kanaQuery = _isar.kanas.where().alphabetEqualTo(alphabet);

    return kanaQuery.findAll();
  }

  List<Kana> getHiragana() {
    return getKana(Alphabets.hiragana);
  }

  List<Kana> getKatakana() {
    return getKana(Alphabets.katakana);
  }
}
