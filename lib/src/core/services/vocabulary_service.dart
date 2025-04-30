import "dart:convert";

import "package:kana_to_kanji/src/core/dataloaders/vocabulary_dataloader.dart";
import "package:kana_to_kanji/src/core/models/resources/resources.dart"
    show ResourceUid, Vocabulary;
import "package:kana_to_kanji/src/core/services/database_service.dart";
import "package:kana_to_kanji/src/core/services/resource_data_service.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:sqflite/sqflite.dart";

/// Vocabulary table columns
const sqlVocabularyTable = "vocabulary";
const sqlKanjiColumn = "kanji";
const sqlKanaColumn = "kana";
const sqlJlptLevelColumn = "jlpt_level";
const sqlRomajiColumn = "romaji";
const sqlVersionColumn = "version";
const sqlKanaSyllablesColumn = "kana_syllables";
const sqlMeaningsColumn = "meanings";

/// Kanji related table and columns
const sqlRelatedKanjiColumn = "related_kanjis";
const sqlRelatedKanjiTable = "vocabulary_related_kanjis";
const sqlVocabularyUidColumn = "vocabulary_uid";
const sqlKanjiUidColumn = "kanji_uid";

/// Kanji readings table and columns
const sqlKanjiReadings = "kanji_readings";
const sqlKanjiReadingsTable = "vocabulary_kanji_readings";
const sqlKanjiReadingKanjiColumn = "kanji";
const sqlReadingColumn = "reading";
const sqlReadingsColumns = [
  sqlKanjiUidColumn,
  sqlKanjiReadingKanjiColumn,
  sqlReadingColumn,
];

/// Vocabulary groups table and columns
const sqlVocabularyGroups = "groups";
const sqlVocabularyGroupsTable = "vocabulary_groups";
const sqlGroupUidColumn = "group_uid";

/// Vocabulary groups table and columns
const sqlVocabularyExamples = "examples";
const sqlVocabularyExamplesTable = "vocabulary_examples";
const sqlExampleUidColumn = "example_uid";

class VocabularyService extends ResourceDataService<Vocabulary> {
  final DatabaseService _databaseService = locator<DatabaseService>();

  /// [dataLoader] should only be used for testing
  VocabularyService({VocabularyDataLoader? dataLoader})
    : super(
        tableName: sqlVocabularyTable,
        transformer: Vocabulary.fromJson,
        resourceColumns: [
          sqlKanjiColumn,
          sqlKanaColumn,
          sqlJlptLevelColumn,
          sqlRomajiColumn,
          sqlVersionColumn,
          sqlKanaSyllablesColumn,
          sqlMeaningsColumn,
        ],
        dataLoader: dataLoader ?? VocabularyDataLoader(),
      );

  /// Get all the vocabulary
  @override
  Future<List<Vocabulary>> getAll() => _databaseService.rawQueryTrans("""
        SELECT
            ${columns.map((c) => 'v.$c').join(",")},
            json_group_array(DISTINCT json_object(${sqlReadingsColumns.map((c) => "'$c', kr.$c").join(",")})) AS $sqlKanjiReadings,
            json_group_array(DISTINCT vrk.$sqlKanjiUidColumn) AS $sqlRelatedKanjiColumn,
            json_group_array(DISTINCT vg.$sqlGroupUidColumn) AS $sqlVocabularyGroups
        FROM $tableName AS v
                 LEFT JOIN $sqlKanjiReadingsTable AS kr
                           ON v.$sqlUidColumn = kr.$sqlVocabularyUidColumn
                 LEFT JOIN $sqlRelatedKanjiTable AS vrk
                           ON v.$sqlUidColumn = vrk.$sqlVocabularyUidColumn
                 LEFT JOIN $sqlVocabularyGroupsTable AS vg
                           ON v.$sqlUidColumn = vg.$sqlVocabularyUidColumn
        GROUP BY v.$sqlUidColumn
      """, transformer: _transformer);

  @override
  Future<Vocabulary> get(ResourceUid uid) => _databaseService
      .rawQueryTrans(
        """
        SELECT
            ${columns.map((c) => 'v.$c').join(",")},
            json_group_array(DISTINCT json_object(${sqlReadingsColumns.map((c) => "'$c', kr.$c").join(",")})) AS $sqlKanjiReadings,
            json_group_array(DISTINCT vrk.$sqlKanjiUidColumn) AS $sqlRelatedKanjiColumn,
            json_group_array(DISTINCT vg.$sqlGroupUidColumn) AS $sqlVocabularyGroups
        FROM $tableName AS v
                 LEFT JOIN $sqlKanjiReadingsTable AS kr
                           ON v.$sqlUidColumn = kr.$sqlVocabularyUidColumn
                 LEFT JOIN $sqlRelatedKanjiTable AS vrk
                           ON v.$sqlUidColumn = vrk.$sqlVocabularyUidColumn
                 LEFT JOIN $sqlVocabularyGroupsTable AS vg
                           ON v.$sqlUidColumn = vg.$sqlVocabularyUidColumn
        WHERE v.$sqlUidColumn = ?
        GROUP BY v.$sqlUidColumn
        LIMIT 1
      """,
        transformer: _transformer,
        arguments: [uid.uid],
      )
      .then((result) => result.first)
      .catchError((error) {
        if (error is StateError) {
          throw Exception("Item not found");
        }
        throw error;
      });

  /// Upsert vocabulary  and related data into the [batch]
  @override
  void upsertData(Vocabulary item, Batch batch, {required bool exists}) {
    if (exists) {
      batch.update(
        tableName,
        _buildMainColumns(item),
        where: sqlWhereUidColumn,
        whereArgs: [item.uid.uid],
      );
    } else {
      batch.insert(tableName, _buildMainColumns(item));
    }

    // Kanji
    for (final relatedKanjiUid in item.relatedKanjis) {
      batch.insert(sqlRelatedKanjiTable, {
        sqlVocabularyUidColumn: item.uid.uid,
        sqlKanjiUidColumn: relatedKanjiUid.uid,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    // Groups
    for (final groupUid in item.groups) {
      batch.insert(sqlVocabularyGroupsTable, {
        sqlVocabularyUidColumn: item.uid.uid,
        sqlGroupUidColumn: groupUid.uid,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Map<String, dynamic> _buildMainColumns(Vocabulary item) =>
      item.toJson()
        ..removeWhere(
          (key, _) => [
            sqlRelatedKanjiColumn,
            sqlVocabularyGroups,
            sqlKanjiReadings,
            sqlVocabularyExamples,
          ].contains(key),
        )
        ..update(sqlMeaningsColumn, (_) => jsonEncode(item.meanings))
        ..update(sqlKanaSyllablesColumn, (_) => jsonEncode(item.kanaSyllables));

  Vocabulary _transformer(Map<String, dynamic> row) {
    final kanjiReadings =
        jsonDecode(row[sqlKanjiReadings]) as List<dynamic>..removeWhere(
          (e) => e is Map<String, dynamic> && e[sqlReadingColumn] == null,
        );
    final relatedKanji =
        jsonDecode(row[sqlRelatedKanjiColumn]) as List<dynamic>..remove(null);
    final groups =
        jsonDecode(row[sqlVocabularyGroups]) as List<dynamic>..remove(null);
    final kanaSyllables = jsonDecode(row[sqlKanaSyllablesColumn]);
    final meanings = jsonDecode(row[sqlMeaningsColumn]);

    return Vocabulary.fromJson({
      ...row,
      sqlKanjiReadings: kanjiReadings,
      sqlRelatedKanjiColumn: relatedKanji,
      sqlVocabularyGroups: groups,
      sqlKanaSyllablesColumn: kanaSyllables,
      sqlMeaningsColumn: meanings,
    });
  }
}
