import 'package:kana_to_kanji/src/core/services/database_service.dart';
import 'package:kana_to_kanji/src/locator.dart';
import 'package:kana_to_kanji/src/core/constants/alphabets.dart';
import 'package:kana_to_kanji/src/core/constants/group_queries.dart';
import 'package:kana_to_kanji/src/core/models/group.dart';

class IGroupsRepository {

  Future<List<Group>> getGroups(Alphabets alphabet, {bool reload = false}) async {
    return Future(() => List.empty());
  }
}
