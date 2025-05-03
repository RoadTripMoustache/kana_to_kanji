import "dart:convert";
import "dart:math";

import "package:kana_to_kanji/src/core/constants/jlpt_levels.dart";
import "package:kana_to_kanji/src/core/dataloaders/kanji_dataloader.dart";
import "package:kana_to_kanji/src/core/models/paginated_data.dart";
import "package:kana_to_kanji/src/core/models/resources/resources.dart"
    show Kanji, ResourceUid;
import "package:kana_to_kanji/src/core/services/database_service.dart";
import "package:kana_to_kanji/src/core/services/resources/resource_data_service.dart";
import "package:kana_to_kanji/src/core/utils/sql/sql_column.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:sqflite/sqflite.dart";

/// Main table columns
const sqlKanjiTable = "kanjis";
const sqlKanjiColumn = "kanji";
const sqlJlptLevelColumn = "jlpt_level";
const sqlNumberOfStrokesColumn = "number_of_strokes";
const sqlGradeColumn = "grade";
const sqlMainReadingColumn = "main_reading";
const sqlMainMeaningColumn = "main_meaning";
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

enum KanjiColumn implements SqlColumn {
  uid("k.$sqlUidColumn"),
  kanji("k.$sqlKanjiColumn"),
  jlptLevel("k.$sqlJlptLevelColumn"),
  numberOfStrokes("k.$sqlNumberOfStrokesColumn"),
  grade("k.$sqlGradeColumn"),
  mainMeaning("k.$sqlMainMeaningColumn"),

  // Only used for sorting
  mainReading("k.$sqlMainReadingColumn");

  @override
  final String column;

  const KanjiColumn(this.column);
}

const Map<Type, String> kKanjiColumnsAliases = {JLPTLevel: sqlJlptLevelColumn};

class KanjiService extends ResourceDataService<Kanji> {
  final DatabaseService _databaseService = locator<DatabaseService>();

  /// [dataLoader] should only be used for testing
  KanjiService({KanjiDataLoader? dataLoader})
    : super(
        tableName: sqlKanjiTable,
        transformer: Kanji.fromJson,
        resourceColumns: [
          sqlKanjiColumn,
          sqlJlptLevelColumn,
          sqlNumberOfStrokesColumn,
          sqlGradeColumn,
          sqlMainMeaningColumn,
          sqlPronunciationsColumn,
        ],
        dataLoader: dataLoader ?? KanjiDataLoader(),
      );

  @override
  Future<PaginatedData<Kanji>> getPaginated(
    int page, {
    int pageSize = 100,
    String? orderBy,
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final snapshot = await _databaseService.rawQueryTrans(
      _buildSelectQuery(
        where: where,
        orderBy: orderBy,
        limit: pageSize,
        offset: max((page - 1) * pageSize, 0),
      ),
      arguments: whereArgs ?? [],
      transformer: _transformer,
    );

    return PaginatedData<Kanji>(
      data: snapshot,
      next:
          snapshot.length == pageSize
              ? () => getPage(page + 1, pageSize: pageSize)
              : null,
    );
  }

  /// Retrieve all the kanji.
  /// Be aware that this will load ALL the kanji of the database in memory.
  @override
  Future<List<Kanji>> getAll() => _databaseService.rawQueryTrans(
    _buildSelectQuery(),
    transformer: _transformer,
  );

  /// Retrieve all the kanji
  @override
  Future<Kanji> get(ResourceUid uid) => _databaseService
      .rawQueryTrans(
        _buildSelectQuery(where: "k.$sqlUidColumn = ?", limit: 1),
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
        ..putIfAbsent(
          sqlMainReadingColumn,
          () => item.pronunciations.first.readings.first,
        )
        ..update(
          sqlPronunciationsColumn,
          (_) => jsonEncode(item.pronunciations),
        );

  Kanji _transformer(Map<String, dynamic> row) {
    final pronunciations = jsonDecode(row[sqlPronunciationsColumn]);
    final relatedVocabulary =
        jsonDecode(row[sqlRelatedVocabularyColumn]) as List<dynamic>
          ..remove(null);
    final groups =
        jsonDecode(row[sqlKanjiGroups]) as List<dynamic>..remove(null);

    return Kanji.fromJson({
      ...row,
      sqlPronunciationsColumn: pronunciations ?? [],
      sqlRelatedVocabularyColumn: relatedVocabulary,
      sqlKanjiGroups: groups,
    });
  }

  /// Build the select query for kanji.
  /// For the [where] clause, 'k' is the alias for the kanji table.
  String _buildSelectQuery({
    String? where,
    String? orderBy,
    int? limit,
    int? offset,
  }) {
    final extra = [];

    if (where != null && where.isNotEmpty) {
      extra.add("WHERE $where");
    }
    extra.add("GROUP BY k.$sqlUidColumn, k.$sqlKanjiColumn");
    if (orderBy != null && orderBy.isNotEmpty) {
      extra.add("ORDER BY $orderBy");
    }
    if (limit != null) {
      extra.add("LIMIT $limit");
    }
    if (offset != null) {
      extra.add("OFFSET $offset");
    }

    return """
    SELECT
        ${columns.map((c) => 'k.$c').join(",")},
        json_group_array(DISTINCT krv.$sqlVocabularyUidColumn) AS $sqlRelatedVocabularyColumn,
        json_group_array(DISTINCT kg.$sqlGroupUidColumn) AS $sqlKanjiGroups
    FROM $tableName AS k
             LEFT JOIN $sqlRelatedVocabularyTable AS krv
                       ON k.$sqlUidColumn = krv.$sqlKanjiUidColumn
             LEFT JOIN $sqlKanjiGroupsTable AS kg
                       ON k.$sqlUidColumn = kg.$sqlKanjiUidColumn
    ${extra.join("\n")}
    """;
  }
}
