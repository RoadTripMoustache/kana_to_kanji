import "dart:convert";

import "package:kana_to_kanji/src/core/constants/preference_flags.dart";
import "package:kana_to_kanji/src/core/dataloaders/resource_dataloader.dart";
import "package:kana_to_kanji/src/core/models/paginated_data.dart";
import "package:kana_to_kanji/src/core/models/resources/resources.dart"
    show ResourceUid, Vocabulary;
import "package:kana_to_kanji/src/core/services/database_service.dart";
import "package:kana_to_kanji/src/core/services/resources/resource_data_service.dart";
import "package:kana_to_kanji/src/core/utils/sql/sql_column.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:sqflite/sqflite.dart";

/// Vocabulary table columns
const sqlVocabularyTable = "vocabulary";
const sqlKanjiColumn = "kanji";
const sqlKanaColumn = "kana";
const sqlJlptLevelColumn = "jlpt_level";
const sqlRomajiColumn = "romaji";
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

enum VocabularyColumn implements SqlColumn {
  uid(sqlUidColumn),
  kanji(sqlKanjiColumn),
  kana(sqlKanaColumn),
  jlptLevel(sqlJlptLevelColumn),
  romaji(sqlRomajiColumn),
  meanings(sqlMeaningsColumn);

  @override
  final String column;

  @override
  final String prefix = "v";

  const VocabularyColumn(this.column);

  /// Returns the column name with the prefix.
  @override
  String get selectColumn => "$prefix.$column";
}

class VocabularyService extends ResourceDataService<Vocabulary> {
  final DatabaseService _databaseService = locator<DatabaseService>();

  /// [dataLoader] should only be used for testing
  VocabularyService({ResourceDataLoader<Vocabulary>? dataLoader})
    : super(
        tableName: sqlVocabularyTable,
        transformer: Vocabulary.fromJson,
        resourceColumns: [
          sqlKanjiColumn,
          sqlKanaColumn,
          sqlJlptLevelColumn,
          sqlRomajiColumn,
          sqlMeaningsColumn,
        ],
        dataLoader:
            dataLoader ??
            ResourceDataLoader<Vocabulary>(
              fromJson: Vocabulary.fromJson,
              apiResourceType: sqlVocabularyTable,
            ),
        syncFlag: PreferenceFlags.vocabularyLastVersionSynced,
      );

  /// Get all the vocabulary
  @override
  Future<PaginatedData<Vocabulary>> getPaginated(
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

    return PaginatedData<Vocabulary>(
      data: snapshot,
      next:
          snapshot.length == pageSize
              ? () => getPaginated(
                page + 1,
                pageSize: pageSize,
                orderBy: orderBy,
                where: where,
                whereArgs: whereArgs,
              )
              : null,
    );
  }

  /// Get all the vocabulary
  @override
  Future<List<Vocabulary>> getAll() => _databaseService.rawQueryTrans(
    _buildSelectQuery(),
    transformer: _transformer,
  );

  @override
  Future<Vocabulary> get(ResourceUid uid) => _databaseService
      .rawQueryTrans(
        _buildSelectQuery(where: "v.$sqlUidColumn = ?", limit: 1),
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
        ..update(sqlMeaningsColumn, (_) => jsonEncode(item.meanings));

  Vocabulary _transformer(Map<String, dynamic> row) {
    final kanjiReadings =
        jsonDecode(row[sqlKanjiReadings]) as List<dynamic>..removeWhere(
          (e) => e is Map<String, dynamic> && e[sqlReadingColumn] == null,
        );
    final relatedKanji =
        jsonDecode(row[sqlRelatedKanjiColumn]) as List<dynamic>..remove(null);
    final groups =
        jsonDecode(row[sqlVocabularyGroups]) as List<dynamic>..remove(null);
    final meanings = jsonDecode(row[sqlMeaningsColumn]) as List<dynamic>;

    return Vocabulary.fromJson({
      ...row,
      sqlKanjiReadings: kanjiReadings,
      sqlRelatedKanjiColumn: relatedKanji,
      sqlVocabularyGroups: groups,
      sqlMeaningsColumn: meanings,
    });
  }

  /// Build the select query for vocabulary.
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
    extra.add("GROUP BY v.$sqlUidColumn");
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
       DISTINCT ${columns.map((c) => 'v.$c').join(",")},
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
    ${extra.join("\n")}
    """;
  }
}
