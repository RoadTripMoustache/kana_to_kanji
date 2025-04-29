import "dart:convert";

import "package:kana_to_kanji/src/core/dataloaders/kanji_dataloader.dart";
import "package:kana_to_kanji/src/core/models/kanji.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";
import "package:kana_to_kanji/src/core/services/database_service.dart";
import "package:kana_to_kanji/src/core/services/resource_data_service.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:sqflite/sqflite.dart";

/// Main table columns
const sqlKanjiTable = "kanjis";
const sqlKanjiColumn = "kanji";
const sqlJlptLevelColumn = "jlpt_level";
const sqlNumberOfStrokesColumn = "number_of_strokes";
const sqlGradeColumn = "grade";
const sqlJpSortSyllablesColumn = "jp_sort_syllables";
const sqlMainMeaningColumn = "main_meaning";
const sqlOnReadingsColumn = "on_readings";
const sqlKunReadingsColumn = "kun_readings";
const sqlPronunciationsColumn = "pronunciations";

/// Related vocabulary table and columns
const sqlRelatedVocabularyTable = "kanji_related_vocabulary";
const sqlRelatedVocabularyColumn = "related_vocabulary";
const sqlKanjiUidColumn = "kanji_uid";
const sqlVocabularyUidColumn = "vocabulary_uid";

/// Kanji groups table and columns
const sqlKanjiGroupsTable = "kanji_groups";
const sqlKanjiGroups = "groups";
const sqlGroupUidColumn = "group_uid";

/// Kanji examples table and columns
const sqlKanjiExamplesTable = "kanji_examples";
const sqlKanjiExamples = "examples";
const sqlExampleUidColumn = "example_uid";

class KanjiService extends ResourceDataService<Kanji> {
  final DatabaseService _databaseService = locator<DatabaseService>();

  KanjiService()
    : super(
        tableName: sqlKanjiTable,
        transformer: Kanji.fromJson,
        resourceColumns: [
          sqlKanjiColumn,
          sqlJlptLevelColumn,
          sqlNumberOfStrokesColumn,
          sqlGradeColumn,
          sqlJpSortSyllablesColumn,
          sqlMainMeaningColumn,
          sqlOnReadingsColumn,
          sqlKunReadingsColumn,
          sqlPronunciationsColumn,
        ],
        dataLoader: KanjiDataLoader(),
      );

  /// Retrieve all the kanji
  @override
  Future<List<Kanji>> getAll() => _databaseService.rawQueryTrans("""
        SELECT
            ${columns.map((c) => 'k.$c').join(",")},
            json_group_array(DISTINCT krv.$sqlVocabularyUidColumn) AS $sqlRelatedVocabularyColumn,
            json_group_array(DISTINCT kg.$sqlGroupUidColumn) AS $sqlKanjiGroups
        FROM $tableName AS k
                 LEFT JOIN $sqlRelatedVocabularyTable AS krv
                           ON k.$sqlUidColumn = krv.$sqlKanjiUidColumn
                 LEFT JOIN $sqlKanjiGroupsTable AS kg
                           ON k.$sqlUidColumn = kg.$sqlKanjiUidColumn
        GROUP BY
            k.$sqlUidColumn, k.$sqlKanjiColumn
      """, transformer: _transformer);

  /// Retrieve all the kanji
  @override
  Future<Kanji> get(ResourceUid uid) => _databaseService
      .rawQueryTrans(
        """
        SELECT
            ${columns.map((c) => 'k.$c').join(",")},
            json_group_array(DISTINCT krv.$sqlVocabularyUidColumn) AS $sqlRelatedVocabularyColumn,
            json_group_array(DISTINCT kg.$sqlGroupUidColumn) AS $sqlKanjiGroups
        FROM $tableName AS k
                 LEFT JOIN $sqlRelatedVocabularyTable AS krv
                           ON k.$sqlUidColumn = krv.$sqlKanjiUidColumn
                 LEFT JOIN $sqlKanjiGroupsTable AS kg
                           ON k.$sqlUidColumn = kg.$sqlKanjiUidColumn
        WHERE k.$sqlUidColumn = ?
        GROUP BY k.$sqlUidColumn, k.$sqlKanjiColumn
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

  /// Upsert kanji and related data into the [batch]
  @override
  void upsertData(Kanji item, Batch batch, {required bool exists}) {
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

    // Vocabulary
    for (final relatedVocabularyUid in item.relatedVocabulary) {
      batch.insert(sqlRelatedVocabularyTable, {
        sqlKanjiUidColumn: item.uid.uid,
        sqlVocabularyUidColumn: relatedVocabularyUid.uid,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    // Groups
    for (final groupUid in item.groups) {
      batch.insert(sqlKanjiGroupsTable, {
        sqlKanjiUidColumn: item.uid.uid,
        sqlGroupUidColumn: groupUid.uid,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Map<String, dynamic> _buildMainColumns(Kanji item) =>
      item.toJson()
        ..removeWhere(
          (key, _) => [
            sqlRelatedVocabularyColumn,
            sqlKanjiGroups,
            sqlKanjiExamples,
          ].contains(key),
        )
        ..update(
          sqlPronunciationsColumn,
          (_) => jsonEncode(item.pronunciations),
        )
        ..update(sqlOnReadingsColumn, (_) => jsonEncode(item.onReadings))
        ..update(sqlKunReadingsColumn, (_) => jsonEncode(item.kunReadings))
        ..update(
          sqlJpSortSyllablesColumn,
          (_) => jsonEncode(item.jpSortSyllables),
        );

  Kanji _transformer(Map<String, dynamic> row) {
    final pronunciations = jsonDecode(row[sqlPronunciationsColumn]);
    final relatedVocabulary =
        jsonDecode(row[sqlRelatedVocabularyColumn]) as List<dynamic>
          ..remove(null);
    final groups =
        jsonDecode(row[sqlKanjiGroups]) as List<dynamic>..remove(null);
    final sortSyllables = jsonDecode(row[sqlJpSortSyllablesColumn]);
    // TODO delete once migrated to "pronunciations"
    final onReadings = jsonDecode(row[sqlOnReadingsColumn]);
    final kunReadings = jsonDecode(row[sqlKunReadingsColumn]);

    return Kanji.fromJson({
      ...row,
      sqlPronunciationsColumn: pronunciations ?? [],
      sqlRelatedVocabularyColumn: relatedVocabulary,
      sqlKanjiGroups: groups,
      sqlJpSortSyllablesColumn: sortSyllables,
      sqlOnReadingsColumn: onReadings,
      sqlKunReadingsColumn: kunReadings,
    });
  }
}
