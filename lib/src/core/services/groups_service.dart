import 'package:isar/isar.dart';
import 'package:kana_to_kanji/src/core/constants/alphabets.dart';
import 'package:kana_to_kanji/src/core/models/group.dart';
import 'package:kana_to_kanji/src/core/models/resource_uid.dart';
import 'package:kana_to_kanji/src/locator.dart';

class GroupsService {
  final Isar _isar = locator<Isar>();

  /// Get all the groups related to the alphabet given in parameter.
  Future<List<Group>> getGroups(Alphabets alphabet,
      {bool reload = false}) async {
    return Future.value(
        _isar.groups.where().alphabetEqualTo(alphabet).findAll());
  }

  Future delete(ResourceUid resourceUid) async {
    await _isar.writeAsync((isar) {
      return isar.groups
          .where()
          .uid((uid) => uid.uidEqualTo(resourceUid.uid))
          .deleteFirst();
    });
  }
}
