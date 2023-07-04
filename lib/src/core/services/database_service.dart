import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:kana_to_kanji/src/locator.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static const _databaseName = "kana_to_kanji.db";
  static const _databaseVersion = 1;

  static const _initialDataFilePath = "assets/database/data.json";

  final Logger _logger = locator<Logger>();

  late final Database _database;

  bool _isInitialized = false;

  Future<void> initialize(List<String> entitiesCreationQueries,
      List<Map<int, String>> entitiesUpgradeQueries) async {
    _database = await openDatabase(
        join(await getDatabasesPath(), _databaseName),
        version: _databaseVersion,
        onConfigure: _onConfigure,
        onCreate: (Database db, int version) =>
            _onCreate(db, entitiesCreationQueries),
        onUpgrade: (Database db, int currentVersion, int newVersion) async {
          _logger.i(
              "$runtimeType - Start upgrading process from $currentVersion to $newVersion");
          List<String> toExecute = [];

          for (Map<int, String> queries in entitiesUpgradeQueries) {
            queries.forEach((key, value) {
              if (key > currentVersion && key <= newVersion) {
                toExecute.add(value);
              }
            });
          }
          _logger.d(
              "$runtimeType - The following queries will be executed to upgrade:\n$toExecute");
          db.rawQuery(toExecute.join(";"));
          _logger.i("$runtimeType - Upgrade to $newVersion finished.");
        });
    _isInitialized = true;
  }

  _onConfigure(Database db) async {
    // Add support for cascade delete
    await db.execute("PRAGMA foreign_keys = ON");
  }

  _onCreate(Database db, List<String> entitiesCreationQueries) async {
    // Database is created, create the table
    _logger.d(
        "Start creation of database.\nCreating ${entitiesCreationQueries.length} tables...");
    Batch batch = db.batch();
    for (String query in entitiesCreationQueries) {
      batch.execute(query);
    }
    await batch.commit();
    _logger.d(await db.rawQuery(
        "SELECT name FROM sqlite_schema WHERE type ='table' AND name NOT LIKE 'sqlite_%';"));

    // populate data
    _logger.d("Tables creation finished.\nStart data population...");
    // Load JSON file
    final rawData =
        jsonDecode(await rootBundle.loadString(_initialDataFilePath))
            as Map<String, dynamic>;

    batch = db.batch();
    for (final entry in rawData.entries) {
      if (entry.value is Iterable) {
        for (final Map<String, dynamic> data in entry.value) {
          batch.insert(entry.key, data);
        }
      } else {
        _logger.d("Skipping ${entry.key} data. Not a list");
      }
    }
    _logger.d("Data loaded. Start inserting...");
    await batch.commit(noResult: true);
    _logger.d("Database creation finished");
  }

  Future<T?> get<T>(String query, Function fromJson,
      {List<Object?> arguments = const []}) async {
    if (!_isInitialized) {
      throw Error();
    }

    final data = await _database.rawQuery(query, _sanitizeArguments(arguments));

    if (data.isEmpty) {
      return null;
    }

    return fromJson(data);
  }

  Future<List<T>> getMultiple<T>(String query, Function fromJson,
      {List<Object?> arguments = const []}) async {
    if (!_isInitialized) {
      throw Error();
    }

    final data = await _database.rawQuery(query, _sanitizeArguments(arguments));

    if (data.isEmpty) {
      return [];
    }

    return data.map<T>((e) => fromJson(e)).toList(growable: false);
  }

  Future<void> insert(String table, Map<String, Object?> values) async {
    await _database.insert(table, values,
        conflictAlgorithm: ConflictAlgorithm.fail);
  }

  Future<int> delete(String table, String whereQuery, List<Object?> arguments) {
    _logger.d("Deletion $table, where: $whereQuery, $arguments");
    return _database.delete(table, where: whereQuery, whereArgs: arguments);
  }

  List<Object?> _sanitizeArguments(List<Object?> arguments) {
    final sanitizedArguments = [];
    for (Object? argument in arguments) {
      if (argument is List) {
        sanitizedArguments.add(argument.join(","));
      } else {
        sanitizedArguments.add(argument);
      }
    }

    return sanitizedArguments;
  }
}
