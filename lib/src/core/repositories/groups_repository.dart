import 'package:kana_to_kanji/src/core/services/groups_service.dart';
import 'package:kana_to_kanji/src/core/constants/alphabets.dart';
import 'package:kana_to_kanji/src/core/models/group.dart';

class GroupsRepository {
  final GroupsService _groupsService = GroupsService();

  Future<List<Group>> getGroups(Alphabets alphabet,
      {bool reload = false}) async {
    return _groupsService.getGroups(alphabet, reload: false);
  }
}
