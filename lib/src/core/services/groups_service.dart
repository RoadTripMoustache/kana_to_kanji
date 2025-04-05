import "package:isar/isar.dart";
import "package:kana_to_kanji/src/core/constants/alphabets.dart";
import "package:kana_to_kanji/src/core/models/group.dart";
import "package:kana_to_kanji/src/core/models/group.dart" as sm;
import "package:kana_to_kanji/src/core/models/resource_uid.dart";
import "package:kana_to_kanji/src/core/services/database_service.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:sembast/sembast.dart" as sembast;

class GroupsService {
  final Isar _isar = locator<Isar>();

  /// Get all the groups related to the alphabet given in parameter.
  Future<List<Group>> getGroups(
    Alphabets alphabet, {
    bool reload = false,
  }) async =>
      Future.value(_isar.groups.where().alphabetEqualTo(alphabet).findAll());

  Future delete(ResourceUid resourceUid) async {
    await _isar.writeAsync(
      (isar) =>
          isar.groups
              .where()
              .uid((uid) => uid.uidEqualTo(resourceUid.uid))
              .deleteFirst(),
    );
  }
}

class SembastGroupsService {
  final DatabaseService _databaseService = locator<DatabaseService>();

  final sembast.StoreRef store = sembast.stringMapStoreFactory.store('groups');

  /// Get all the groups related to the alphabet given in parameter.
  Future<List<sm.Group>> getGroups(
    Alphabets alphabet, {
    bool reload = false,
  }) async {
    final finder = sembast.Finder(
      filter: sembast.Filter.greaterThan('alphabet', alphabet),
      sortOrders: [sembast.SortOrder('name')],
    );

    final records = await store.find(_databaseService.db, finder: finder);

    return records.map(_transformer).toList();
  }

  Future delete(ResourceUid resourceUid) async {
    await store.record(resourceUid.uid).delete(_databaseService.db);
  }

  sm.Group _transformer(sembast.RecordSnapshot snapshot) =>
      sm.Group.fromJson(snapshot.value! as Map<String, dynamic>);
}
