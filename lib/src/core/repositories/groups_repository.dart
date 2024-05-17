import "package:kana_to_kanji/src/core/constants/alphabets.dart";
import "package:kana_to_kanji/src/core/models/group.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";
import "package:kana_to_kanji/src/core/services/groups_service.dart";

class GroupsRepository {
  final GroupsService _groupsService = GroupsService();
  final List<Group> _groups = [];

  Future<List<Group>> getGroups(Alphabets alphabet,
      {bool reload = false}) async {
    final groups =
        _groups.where((element) => element.alphabet == alphabet).toList();
    if (reload || groups.isEmpty) {
      _groups.removeWhere((element) => element.alphabet == alphabet);
      groups
        ..clear()
        ..addAll(await _groupsService.getGroups(alphabet));

      _groups.addAll(groups);
    }

    return groups;
  }

  Future delete(ResourceUid uid) async {
    _groups.removeWhere((element) => element.uid == uid);
    await _groupsService.delete(uid);
  }
}
