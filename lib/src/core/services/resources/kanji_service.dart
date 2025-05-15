import "dart:convert";

import "package:kana_to_kanji/src/core/constants/jlpt_levels.dart";
import "package:kana_to_kanji/src/core/constants/preference_flags.dart";
import "package:kana_to_kanji/src/core/dataloaders/resource_dataloader.dart";
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

const _sqlReadingsColumn = "readings";
const _sqlMeaningsColumn = "meanings";

/// Related vocabulary table and columns
const sqlRelatedVocabularyTable = "kanji_related_vocabulary";
const sqlRelatedVocabularyColumn = "related_vocabulary";
const sqlKanjiUidColumn = "kanji_uid";
const sqlVocabularyUidColumn = "vocabulary_uid";

/// Kanji groups table and columns
const sqlKanjiGroupsTable = "kanji_groups";
const sqlKanjiGroups = "groups";
const sqlGroupUidColumn = "group_uid";

enum KanjiColumn implements SqlColumn {
  uid(sqlUidColumn),
  kanji(sqlKanjiColumn),
  jlptLevel(sqlJlptLevelColumn),
  numberOfStrokes(sqlNumberOfStrokesColumn),
  grade(sqlGradeColumn),
  mainMeaning(sqlMainMeaningColumn),

  // Only used for sorting
  mainReading(sqlMainReadingColumn),

  // Only used for search
  meanings(_sqlMeaningsColumn),
  readings(_sqlReadingsColumn);

  @override
  final String column;

  @override
  final String prefix = "k";

  const KanjiColumn(this.column);

  /// Returns the column name with the prefix.
  @override
  String get selectColumn => "$prefix.$column";
}

enum KanjiPronunciationColumn implements SqlColumn {
  kanjiUid("kanji_uid"),
  position("position"),
  reading("reading"),
  meanings("meanings"),
  examples("examples");

  static String table = "kanji_pronunciations";

  @override
  final String column;

  @override
  final String prefix = "kp";

  const KanjiPronunciationColumn(this.column);

  /// Returns the column name with the prefix.
  @override
  String get selectColumn => "$prefix.$column";
}

const Map<Type, String> kKanjiColumnsAliases = {JLPTLevel: sqlJlptLevelColumn};

class KanjiService extends ResourceDataService<Kanji> {
  final DatabaseService _databaseService = locator<DatabaseService>();

  /// [dataLoader] should only be used for testing
  KanjiService({ResourceDataLoader<Kanji>? dataLoader})
    : super(
        tableName: sqlKanjiTable,
        transformer: Kanji.fromJson,
        resourceColumns: [
          sqlKanjiColumn,
          sqlJlptLevelColumn,
          sqlNumberOfStrokesColumn,
          sqlGradeColumn,
          sqlMainMeaningColumn,
        ],
        dataLoader:
            dataLoader ??
            ResourceDataLoader<Kanji>(
              fromJson: Kanji.fromJson,
              apiResourceType: sqlKanjiTable,
            ),
        syncFlag: PreferenceFlags.kanjiLastVersionSynced,
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
        offset: page * pageSize,
      ),
      arguments: whereArgs ?? [],
      transformer: _transformer,
    );

    return PaginatedData<Kanji>(
      data: snapshot,
      next:
          snapshot.length == pageSize
              ? () => getPaginated(
                page + 1,
                pageSize: pageSize,
                where: where,
                orderBy: orderBy,
                whereArgs: whereArgs,
              )
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

    // Pronunciations
    for (final pronunciation in item.pronunciations) {
      batch.insert(
        KanjiPronunciationColumn.table,
        {
          KanjiPronunciationColumn.kanjiUid.column: item.uid.uid,
          KanjiPronunciationColumn.reading.column: pronunciation.reading,
          KanjiPronunciationColumn.position.column: pronunciation.position,
          KanjiPronunciationColumn.meanings.column: jsonEncode(
            pronunciation.meanings,
          ),
          KanjiPronunciationColumn.examples.column: jsonEncode(
            pronunciation.examples,
          ),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
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
            sqlPronunciationsColumn,
          ].contains(key),
        )
        ..putIfAbsent(
          sqlMainReadingColumn,
          () => item.pronunciations.first.reading,
        )
        ..putIfAbsent(
          _sqlMeaningsColumn,
          () => jsonEncode(
            item.pronunciations
                .map((p) => p.meanings)
                .expand((m) => m)
                .toList(),
          ),
        )
        ..putIfAbsent(
          _sqlReadingsColumn,
          () => jsonEncode(item.pronunciations.map((p) => p.reading).toList()),
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

    final pronunciationsColumn = KanjiPronunciationColumn.values
        .where((c) => c != KanjiPronunciationColumn.kanjiUid)
        .map((c) {
          final column =
              [
                    KanjiPronunciationColumn.meanings,
                    KanjiPronunciationColumn.examples,
                  ].contains(c)
                  ? "json(${c.selectColumn})"
                  : c.selectColumn;
          return "'${c.column}', $column";
        })
        .join(",");

    return """
    SELECT
        DISTINCT ${columns.map((c) => 'k.$c').join(",")},
        json_group_array(DISTINCT json_object($pronunciationsColumn)) AS $sqlPronunciationsColumn,
        json_group_array(DISTINCT krv.$sqlVocabularyUidColumn) AS $sqlRelatedVocabularyColumn,
        json_group_array(DISTINCT kg.$sqlGroupUidColumn) AS $sqlKanjiGroups
    FROM $tableName AS k
             LEFT JOIN ${KanjiPronunciationColumn.table} AS kp
                       ON k.$sqlUidColumn = ${KanjiPronunciationColumn.kanjiUid.selectColumn}
             LEFT JOIN $sqlRelatedVocabularyTable AS krv
                       ON k.$sqlUidColumn = krv.$sqlKanjiUidColumn
             LEFT JOIN $sqlKanjiGroupsTable AS kg
                       ON k.$sqlUidColumn = kg.$sqlKanjiUidColumn
    ${extra.join("\n")}
    """;
  }
}
