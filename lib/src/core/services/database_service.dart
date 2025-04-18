import "dart:async";
import "dart:io";

import "package:flutter/services.dart";
import "package:path/path.dart";
import "package:sqflite/sqflite.dart";

class DatabaseService {
  late final Database _db;

  Future<void> initialize() async {
    // get the application documents directory
    final dir = await getDatabasesPath();
    // build the database path
    final dbPath = join(dir, "kana_to_kanji_local.db");

    // Make sure the directory exists
    await Directory(dir).create(recursive: true);

    // await deleteDatabase(dbPath);

    // open the database
    _db = await openDatabase(
      dbPath,
      version: 1,
      onConfigure: _onConfigure,
      onCreate: _onCreate,
    );
  }

  Future<void> _onConfigure(Database database) async {
    await database.rawQuery("PRAGMA foreign_keys = ON");
  }

  Future<void> _onCreate(Database database, int version) async {
    final rawSQL = await rootBundle.loadString(
      join("assets", "db", "create.sql"),
    );
    final Batch batch = database.batch();

    rawSQL.split(";").forEach((sql) {
      batch.rawQuery(sql.trim());
    });

    await batch.commit(noResult: true, continueOnError: true);
  }

  Future<T> transaction<T>(
    Future<T> Function(Transaction transaction) action,
  ) => _db.transaction<T>(action);

  Future<List<T>> query<T>(
    String table, {
    required T Function(Map<String, Object?>) transformer,
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final List<Map<String, Object?>> result = await _db.query(
      table,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );

    return result.map<T>(transformer).toList();
  }

  Future<List<T>> rawQueryTrans<T>(
    String query, {
    required T Function(Map<String, Object?>) transformer,
    List<dynamic> arguments = const [],
  }) async {
    final List<Map<String, dynamic>> result = await rawQuery(
      query,
      arguments: arguments,
    );

    return result.map<T>(transformer).toList();
  }

  Future<List<Map<String, Object?>>> rawQuery(
    String query, {
    List<dynamic> arguments = const [],
  }) => _db.rawQuery(query, arguments);

  Future<int> insert(
    String table,
    Map<String, Object?> values, {
    String? nullColumnHack,
    ConflictAlgorithm? conflictAlgorithm = ConflictAlgorithm.fail,
  }) => _db.insert(
    table,
    values,
    nullColumnHack: nullColumnHack,
    conflictAlgorithm: conflictAlgorithm,
  );

  Future<int> update(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
    ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.fail,
  }) => _db.update(
    table,
    values,
    where: where,
    whereArgs: whereArgs,
    conflictAlgorithm: conflictAlgorithm,
  );

  Future<int> delete(String table, {String? where, List<Object?>? whereArgs}) =>
      _db.delete(table, where: where, whereArgs: whereArgs);
}
