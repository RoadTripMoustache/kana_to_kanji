import 'package:isar/isar.dart';
import 'package:kana_to_kanji/src/core/constants/alphabets.dart';
import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/locator.dart';

class KanaService {
  final Isar _isar = locator<Isar>();

  /// Get all the kana related to the group ids given in parameter.
  Future<List<Kana>> getByGroupIds(List<int> groupIds) async {
    if (groupIds.isEmpty) {
      return Future.value(_isar.kanas.where().findAll());
    }

    var kanaQuery = _isar.kanas.where().groupIdEqualTo(groupIds[0]);

    for (var i = 1; i < groupIds.length; i++) {
      kanaQuery = kanaQuery.or().groupIdEqualTo(groupIds[i]);
    }

    return Future.value(kanaQuery.findAll());
  }

  /// Get all the kana related to the group id given in parameter.
  Future<List<Kana>> getByGroupId(int groupId) async {
    return getByGroupIds([groupId]);
  }

  Future<List<Kana>> getKana(Alphabets alphabet) async {
    var kanaQuery = _isar.kanas.where().alphabetEqualTo(alphabet);

    return Future.value(kanaQuery.findAll());
  }

  Future<List<Kana>> getHiragana() async {
    return getKana(Alphabets.hiragana);
  }

  Future<List<Kana>> getKatakana() async {
    return getKana(Alphabets.katakana);
  }

}
