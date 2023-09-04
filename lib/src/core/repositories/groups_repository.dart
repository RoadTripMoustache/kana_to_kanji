import 'package:kana_to_kanji/src/core/services/groups_service.dart';
import 'package:kana_to_kanji/src/core/constants/alphabets.dart';
import 'package:kana_to_kanji/src/core/models/group.dart';

class GroupsRepository {
  final GroupsService _groupsService = GroupsService();
  final List<Group> _groups = [];

  Future<List<Group>> getGroups(Alphabets alphabet,
      {bool reload = false}) async {
    final groups =
        _groups.where((element) => element.alphabet == alphabet).toList();
    if (reload || groups.isEmpty) {
      _groups.removeWhere((element) => element.alphabet == alphabet);
      groups.clear();

      groups.addAll(await _groupsService.getGroups(alphabet, reload: false));

      _groups.addAll(groups);
    }

    return groups;
  }
}
