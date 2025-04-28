import "package:flutter/foundation.dart";
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
    final snapshot = await _databaseService.queryTrans(
      tableName,
      transformer: (Map<String, Object?> map) => map,
      columns: [sqlVersionColumn],
      limit: 1,
      orderBy: "$sqlVersionColumn DESC",
    );

    return snapshot.isNotEmpty
        ? snapshot[0][sqlVersionColumn]! as String
        : null;
  }

  Future<bool> exists(Transaction txn, T item) async =>
      firstIntValue(
        await txn.query(
          tableName,
          columns: [sqlCountColumn],
          where: sqlWhereUidColumn,
          whereArgs: [item.uid.uid],
        ),
      ) ==
      1;

  Future<List<ResourceUid>> existsAll(
    List<T> items,
    Transaction transaction,
  ) async {
    final result = await transaction.query(
      tableName,
      columns: [sqlUidColumn],
      where: "$sqlUidColumn IN (${items.map((e) => "?").join(",")})",
      whereArgs: items.map((e) => e.uid.uid).toList(),
    );

    return result
        .map((e) => ResourceUid.fromJson(e[sqlUidColumn]! as String))
        .toList();
  }

  Future<List<T>> getAll() => _databaseService.queryTrans(
    tableName,
    transformer: transformer,
    columns: columns,
  );

  /// Retrieve a specific item from the database.
  ///
  /// @throws Exception if the item is not found.
  Future<T> get(ResourceUid uid) => _databaseService
      .queryTrans(
        tableName,
        transformer: transformer,
        columns: columns,
        where: sqlWhereUidColumn,
        whereArgs: [uid.uid],
        limit: 1,
      )
      .then((result) => result.first)
      .catchError((error) {
        if (error is StateError) {
          throw Exception("Item not found");
        }
        throw error;
      });

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
    final batch = transaction.batch();
    upsertData(item, batch, exists: await exists(transaction, item));
    await batch.commit(noResult: true);
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
      existingUids.addAll(await existsAll(items, transaction));
    }

    for (final item in items) {
      upsertData(item, batch, exists: existingUids.contains(item.uid));
    }

    await batch.commit(noResult: true);
  }

  /// Upsert item and related data into the [batch]
  @protected
  void upsertData(T item, Batch batch, {required bool exists}) {
    if (exists) {
      batch.update(
        tableName,
        item.toJson(),
        where: sqlWhereUidColumn,
        whereArgs: [item.uid.uid],
      );
    } else {
      batch.insert(tableName, item.toJson());
    }
  }

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

  Future<void> deleteAll(List<ResourceUid> resourceUids, {Batch? batch}) async {
    if (batch != null) {
      batch.delete(
        tableName,
        where: "$sqlUidColumn IN (${resourceUids.map((e) => "?").join(",")})",
        whereArgs: resourceUids.map((e) => e.uid).toList(),
      );
    } else {
      await _databaseService.transaction((Transaction txn) async {
        await txn.delete(
          tableName,
          where: "$sqlUidColumn IN (${resourceUids.map((e) => "?").join(",")})",
          whereArgs: resourceUids.map((e) => e.uid).toList(),
        );
      });
    }
  }
}
