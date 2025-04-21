import "package:kana_to_kanji/src/core/constants/alphabets.dart";
import "package:kana_to_kanji/src/core/models/group.dart";
import "package:kana_to_kanji/src/core/services/database_service.dart";
import "package:kana_to_kanji/src/core/services/resource_data_service.dart";
import "package:kana_to_kanji/src/locator.dart";

const sqlGroupsTable = "groups";
const sqlAlphabetColumn = "alphabet";
const sqlNameColumn = "name";
const sqlKanaTypeColumn = "kana_type";
const sqlVersionColumn = "version";
const sqlLocalizedNameColumn = "localized_name";

class GroupService extends ResourceDataService<Group> {
  final DatabaseService _databaseService = locator<DatabaseService>();

  GroupService()
    : super(
        tableName: sqlGroupsTable,
        resourceColumns: [
          sqlAlphabetColumn,
          sqlNameColumn,
          sqlKanaTypeColumn,
          sqlLocalizedNameColumn,
        ],
        transformer: Group.fromJson,
      );

  /// Get all the groups related to the alphabet given in parameter.
  Future<List<Group>> getGroups(Alphabets alphabet) =>
      _databaseService.queryTrans(
        tableName,
        transformer: Group.fromJson,
        columns: columns,
        where: "$sqlAlphabetColumn = ?",
        whereArgs: [alphabet.name],
      );
}
