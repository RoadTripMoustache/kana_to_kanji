import "package:kana_to_kanji/src/core/constants/alphabets.dart";
import "package:kana_to_kanji/src/core/models/group.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";
import "package:kana_to_kanji/src/core/services/group_service.dart";

class GroupRepository {
  final GroupService _groupsService;
  final List<Group> _groups = [];

  GroupRepository({GroupService? groupService})
    : _groupsService = groupService ?? GroupService() {
    _groupsService.addListener(_groups.clear);
  }

  Future<List<Group>> getGroups(
    Alphabets alphabet, {
    bool reload = false,
  }) async {
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
