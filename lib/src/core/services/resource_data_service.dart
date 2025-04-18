import "package:kana_to_kanji/src/core/models/resource.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";
import "package:kana_to_kanji/src/core/services/database_service.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:sqflite/sqflite.dart";
import "package:sqflite/utils/utils.dart";

const sqlUidColumn = "uid";
const sqlVersionColumn = "version";
const sqlWhereUidColumn = "uid = ?";

abstract class ResourceDataService<T extends Resource> {
  final DatabaseService _databaseService = locator<DatabaseService>();

  final String tableName;

  final List<String> columns;

  final T Function(Map<String, Object?>) transformer;

  ResourceDataService({
    required this.tableName,
    required this.transformer,
    List<String> resourceColumns = const [],
  }) : columns = [sqlUidColumn, ...resourceColumns, sqlVersionColumn];

  Future<String?> get latestVersion async {
    final snapshot = await _databaseService.query(
      tableName,
      transformer: (Map<String, Object?> map) => map,
      columns: [sqlVersionColumn],
      limit: 1,
      orderBy: "DESC",
    );

    return snapshot.isNotEmpty
        ? snapshot[0][sqlVersionColumn]! as String
        : null;
  }

  Future<bool> _exists(Transaction txn, T item) async =>
      firstIntValue(
        await txn.query(
          tableName,
          columns: [sqlCountColumn],
          where: sqlWhereUidColumn,
          whereArgs: [item.uid.uid],
        ),
      ) ==
      1;

  Future<List<ResourceUid>> _existsAll(
    List<T> items,
    Transaction transaction,
  ) async {
    final result = await transaction.query(
      tableName,
      columns: [sqlUidColumn],
      where: "$sqlUidColumn IN ?",
      whereArgs: [items.map((e) => e.uid.uid).toList()],
    );

    return result
        .map((e) => ResourceUid.fromString(e[sqlUidColumn]! as String))
        .toList();
  }

  Future<List<T>> getAll() => _databaseService.query(
    tableName,
    transformer: transformer,
    columns: columns,
  );

  Future<T> get(ResourceUid uid) => _databaseService
      .query(
        tableName,
        transformer: transformer,
        columns: columns,
        where: sqlWhereUidColumn,
        whereArgs: [uid.uid],
      )
      .then((result) => result.first);

  /// Upsert (insert with replace on conflict) an item in the database.
  ///
  /// Note that this method only works for simple resource that are contained in
  /// a single table (no join or secondary table).
  Future<void> upsert(T item, {Transaction? transaction}) async {
    if (transaction != null) {
      await _upsert(item, transaction);
    } else {
      await _databaseService.transaction((Transaction txn) async {
        await _upsert(item, txn);
      });
    }
  }

  Future<void> _upsert(T item, Transaction transaction) async {
    if (await _exists(transaction, item)) {
      await transaction.update(
        tableName,
        item.toJson(),
        where: sqlWhereUidColumn,
        whereArgs: [item.uid.uid],
      );
    } else {
      await transaction.insert(tableName, item.toJson());
    }
  }

  /// Upsert a batch of items in the storage.
  ///
  /// Note that this method only works for simple resource that are contained in
  /// a single table (no join or secondary table).
  Future<void> upsertAll(
    List<T> items, {
    bool forceReload = false,
    Transaction? transaction,
  }) async {
    if (transaction != null) {
      await _upsertAll(items, transaction, forceReload);
    } else {
      await _databaseService.transaction((Transaction txn) async {
        await _upsertAll(items, txn, forceReload);
      });
    }
  }

  Future<void> _upsertAll(
    List<T> items,
    Transaction transaction,
    bool forceReload,
  ) async {
    final existingUids = [];
    final batch = transaction.batch();

    if (forceReload) {
      batch.delete(tableName);
    } else {
      existingUids.addAll(await _existsAll(items, transaction));
    }

    final List<T> itemsToInsert =
        items.where((item) => !existingUids.contains(item.uid)).toList();

    for (final item in itemsToInsert) {
      if (existingUids.contains(item.uid)) {
        batch.update(
          tableName,
          item.toJson(),
          where: sqlWhereUidColumn,
          whereArgs: [item.uid.uid],
        );
        existingUids.remove(item.uid);
      } else {
        batch.insert(tableName, item.toJson());
      }
    }

    await batch.commit(noResult: true);

    Future<void> delete(
      ResourceUid resourceUid, {
      Transaction? transaction,
    }) async {
      if (transaction != null) {
        await transaction.delete(
          tableName,
          where: sqlWhereUidColumn,
          whereArgs: [resourceUid.uid],
        );
        return;
      }
      await _databaseService.delete(
        tableName,
        where: sqlWhereUidColumn,
        whereArgs: [resourceUid.uid],
      );
    }
  }
}
