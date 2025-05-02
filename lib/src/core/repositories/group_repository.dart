import "package:kana_to_kanji/src/core/constants/alphabets.dart";
import "package:kana_to_kanji/src/core/models/resources/group.dart";
import "package:kana_to_kanji/src/core/models/resources/resource_uid.dart";
import "package:kana_to_kanji/src/core/repositories/resource_repository.dart";
import "package:kana_to_kanji/src/core/services/resources/group_service.dart";

class GroupRepository extends ResourceRepository<Group, GroupService> {
  Future<List<Group>> getGroups(
    Alphabets alphabet, {
    bool reload = false,
  }) async {
    final groups =
        items.where((element) => element.alphabet == alphabet).toList();
    if (reload || groups.isEmpty) {
      items.removeWhere((element) => element.alphabet == alphabet);
      groups
        ..clear()
        ..addAll(await service.getGroups(alphabet));

      items.addAll(groups);
    }

    return groups;
  }

  Future delete(ResourceUid uid) async {
    items.removeWhere((element) => element.uid == uid);
    await service.delete(uid);
  }
}
