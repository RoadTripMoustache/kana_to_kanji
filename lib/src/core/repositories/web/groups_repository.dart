import 'package:kana_to_kanji/src/core/repositories/interfaces/groups_repository.dart';
import 'package:kana_to_kanji/src/core/constants/alphabets.dart';
import 'package:kana_to_kanji/src/core/models/group.dart';

class GroupsRepository implements IGroupsRepository {
  @override
  Future<List<Group>> getGroups(Alphabets alphabet,
      {bool reload = false}) async {
    // TODO : To implement
    return Future(() => List.empty());
  }
}
