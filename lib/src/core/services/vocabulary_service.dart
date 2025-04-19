import "dart:convert";

import "package:kana_to_kanji/src/core/models/resource_uid.dart";
import "package:kana_to_kanji/src/core/models/vocabulary.dart";
import "package:kana_to_kanji/src/core/services/database_service.dart";
import "package:kana_to_kanji/src/core/services/resource_data_service.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:logger/logger.dart";
import "package:sqflite/sqflite.dart";

/// Vocabulary table columns
const sqlKanjiColumn = "kanji";
const sqlKanaColumn = "kana";
const sqlJlptLevelColumn = "jlpt_level";
const sqlRomajiColumn = "romaji";
const sqlVersionColumn = "version";
const sqlKanaSyllablesColumn = "kana_syllables";
const sqlMeaningsColumn = "meanings";
const sqlExamplesColumn = "examples";

/// Kanji related table and columns
const sqlRelatedKanjiColumn = "related_kanji";
const sqlRelatedKanjiTable = "vocabulary_related_kanji";
const sqlVocabularyUidColumn = "vocabulary_uid";
const sqlKanjiUidColumn = "kanji_uid";

/// Kanji readings table and columns
const sqlKanjiReadings = "kanji_readings";
const sqlKanjiReadingsTable = "vocabulary_kanji_readings";
const sqlKanjiReadingKanjiColumn = "kanji";
const sqlReadingColumn = "reading";
const sqlReadingsColumns = [sqlKanjiReadingKanjiColumn, sqlReadingColumn];

/// Vocabulary groups table and columns
const sqlVocabularyGroups = "groups";
const sqlVocabularyGroupsTable = "vocabulary_groups";
const sqlGroupUidColumn = "group_uid";

class VocabularyService extends ResourceDataService<Vocabulary> {
  final DatabaseService _databaseService = locator<DatabaseService>();
  final Logger _logger = locator<Logger>();

  VocabularyService()
    : super(
        tableName: "vocabulary",
        transformer: Vocabulary.fromJson,
        resourceColumns: [
          sqlKanjiColumn,
          sqlKanaColumn,
          sqlJlptLevelColumn,
          sqlRomajiColumn,
          sqlVersionColumn,
          sqlKanaSyllablesColumn,
          sqlMeaningsColumn,
          sqlExamplesColumn,
        ],
      );

  /// Get all the vocabulary
  @override
  Future<List<Vocabulary>> getAll() => _databaseService.rawQueryTrans("""
        SELECT
            ${columns.map((c) => 'v.$c').join(",")},
            json_group_array(DISTINCT json_object(${sqlReadingsColumns.map((c) => "'$c', kr.$c")})) AS $sqlKanjiReadings,
            json_group_array(DISTINCT vrk.$sqlVocabularyUidColumn) AS $sqlRelatedKanjiColumn,
            json_group_array(DISTINCT vg.$sqlGroupUidColumn) AS $sqlVocabularyGroups
        FROM $tableName AS v
                 LEFT JOIN $sqlKanjiReadingsTable AS kr
                           ON v.$sqlUidColumn = kr.$sqlVocabularyUidColumn
                 LEFT JOIN $sqlRelatedKanjiTable AS vrk
                           ON v.$sqlUidColumn = vrk.$sqlVocabularyUidColumn
                 LEFT JOIN $sqlVocabularyGroupsTable AS vg
                           ON v.$sqlUidColumn = vg.$sqlVocabularyUidColumn
        GROUP BY
            k.$sqlUidColumn, k.$sqlKanjiColumn
      """, transformer: _transformer);

  @override
  Future<Vocabulary> get(ResourceUid uid) => _databaseService
      .rawQueryTrans(
        """
        SELECT
            ${columns.map((c) => 'v.$c').join(",")},
            json_group_array(DISTINCT json_object(${sqlReadingsColumns.map((c) => "'$c', kr.$c")})) AS $sqlKanjiReadings,
            json_group_array(DISTINCT vrk.$sqlVocabularyUidColumn) AS $sqlRelatedKanjiColumn,
            json_group_array(DISTINCT vg.$sqlGroupUidColumn) AS $sqlVocabularyGroups
        FROM $tableName AS v
                 LEFT JOIN $sqlKanjiReadingsTable AS kr
                           ON v.$sqlUidColumn = kr.$sqlVocabularyUidColumn
                 LEFT JOIN $sqlRelatedKanjiTable AS vrk
                           ON v.$sqlUidColumn = vrk.$sqlVocabularyUidColumn
                 LEFT JOIN $sqlVocabularyGroupsTable AS vg
                           ON v.$sqlUidColumn = vg.$sqlVocabularyUidColumn
        WHERE v.$sqlUidColumn = ?
        LIMIT 1
        GROUP BY
            k.$sqlUidColumn, k.$sqlKanjiColumn
      """,
        transformer: _transformer,
        arguments: [uid.uid],
      )
      .then((result) => result.first);

  @override
  Future<void> upsertAll(
    List<Vocabulary> items, {
    bool forceReload = false,
    Transaction? transaction,
  }) async {
    if (transaction != null) {
      await _upsertAll(items, forceReload, transaction);
    } else {
      await _databaseService.transaction((Transaction txn) async {
        await _upsertAll(items, forceReload, txn);
      });
    }
  }

  Future<void> _upsertAll(
    List<Vocabulary> items,
    bool forceReload,
    Transaction transaction,
  ) async {
    await super.upsertAll(
      items,
      forceReload: forceReload,
      transaction: transaction,
    );
    final batch = transaction.batch();

    for (final item in items) {
      _upsertJoinTables(item, batch);
    }

    await batch.commit(noResult: true);
  }

  /// Upsert (insert with update on conflict) a kanji in the database.
  @override
  Future<void> upsert(Vocabulary item, {Transaction? transaction}) async {
    if (transaction != null) {
      await _upsert(item, transaction);
    } else {
      await _databaseService.transaction((Transaction txn) async {
        await _upsert(item, txn);
      });
    }
  }

  Future<void> _upsert(Vocabulary item, Transaction transaction) async {
    await super.upsert(item, transaction: transaction);

    final batch = transaction.batch();
    _upsertJoinTables(item, batch);

    await batch.commit(noResult: true);
  }

  /// Upsert data related to a kanji but not in the kanji table
  void _upsertJoinTables(Vocabulary item, Batch batch) {
    if (item.relatedKanjis != null) {
      for (final relatedKanjiUid in item.relatedKanjis!) {
        batch.insert(sqlRelatedKanjiTable, {
          sqlVocabularyUidColumn: item.uid.uid,
          sqlKanjiUidColumn: relatedKanjiUid.uid,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }

    // Groups
    for (final groupUid in item.groups) {
      batch.insert(sqlVocabularyGroupsTable, {
        sqlVocabularyUidColumn: item.uid.uid,
        sqlGroupUidColumn: groupUid.uid,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Vocabulary _transformer(Map<String, dynamic> row) {
    _logger.d("VocabularyService - _transformer - received: $row");
    final kanjiReadings = jsonDecode(row[sqlKanjiReadings]);
    final examples = jsonDecode(row[sqlExamplesColumn]);
    final relatedKanji = jsonDecode(row[sqlRelatedKanjiColumn]);
    final groups = jsonDecode(row[sqlVocabularyGroups]);

    return Vocabulary.fromJson({
      ...row,
      sqlKanjiReadings: kanjiReadings,
      sqlRelatedKanjiColumn: relatedKanji,
      sqlVocabularyGroups: groups,
      sqlExamplesColumn: examples,
    });
  }
}
