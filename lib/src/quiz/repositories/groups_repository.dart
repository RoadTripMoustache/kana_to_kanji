import 'package:kana_to_kanji/src/core/constants/alphabets.dart';
import 'package:kana_to_kanji/src/core/constants/group_queries.dart';
import 'package:kana_to_kanji/src/core/models/group.dart';
import 'package:kana_to_kanji/src/core/services/database_service.dart';
import 'package:kana_to_kanji/src/locator.dart';

class GroupsRepository {
  final DatabaseService _databaseService = locator<DatabaseService>();

  final List<Group> _groups = [];

  Future<List<Group>> getGroups(Alphabets alphabet,
      {bool reload = false}) async {
    final groups =
        _groups.where((element) => element.alphabet == alphabet).toList();
    if (reload || groups.isEmpty) {
      _groups.removeWhere((element) => element.alphabet == alphabet);
      groups.clear();

      groups.addAll(await _databaseService.getMultiple(
          getGroupsQuery, Group.fromJson,
          arguments: [alphabet.value]));
      _groups.addAll(groups);
    }

    return groups;
  }
}
