import "package:kana_to_kanji/src/core/constants/alphabets.dart";
import "package:kana_to_kanji/src/core/models/kana.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";
import "package:kana_to_kanji/src/core/services/database_service.dart";
import "package:kana_to_kanji/src/core/services/resource_data_service.dart";
import "package:kana_to_kanji/src/locator.dart";

const sqlAlphabetColumn = "alphabet";
const sqlGroupUidColumn = "group_uid";
const sqlKanaColumn = "kana";
const sqlRomajiColumn = "romaji";
const sqlPositionColumn = "position";

class KanaService extends ResourceDataService<Kana> {
  final DatabaseService _databaseService = locator<DatabaseService>();

  KanaService()
    : super(
        tableName: "kana",
        resourceColumns: [
          sqlAlphabetColumn,
          sqlGroupUidColumn,
          sqlKanaColumn,
          sqlRomajiColumn,
          sqlPositionColumn,
        ],
        transformer: Kana.fromJson,
      );

  /// Get all the kana related to the group ids given in parameter.
  Future<List<Kana>> getByGroupIds(List<ResourceUid> groupIds) async {
    if (groupIds.isEmpty) {
      return _databaseService.queryTrans(
        tableName,
        columns: columns,
        transformer: Kana.fromJson,
      );
    }

    final List<String> groupUids =
        groupIds.map((groupId) => groupId.uid).toList();

    return _databaseService.queryTrans(
      tableName,
      transformer: Kana.fromJson,
      columns: columns,
      where: "group_uid IN (${List.filled(groupUids.length, '?').join(',')})",
      whereArgs: groupUids,
    );
  }

  /// Get all the kana related to the group id given in parameter.
  Future<List<Kana>> getByGroupId(ResourceUid groupId) =>
      getByGroupIds([groupId]);

  Future<List<Kana>> getKana(Alphabets alphabet) async =>
      _databaseService.queryTrans(
        tableName,
        transformer: Kana.fromJson,
        columns: columns,
        where: "$sqlAlphabetColumn = ?",
        whereArgs: [alphabet.name],
      );

  Future<List<Kana>> getHiragana() => getKana(Alphabets.hiragana);

  Future<List<Kana>> getKatakana() => getKana(Alphabets.katakana);
}
