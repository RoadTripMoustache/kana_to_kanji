import "dart:convert";

import "package:kana_to_kanji/src/core/constants/preference_flags.dart";
import "package:kana_to_kanji/src/core/dataloaders/example_dataloader.dart";
import "package:kana_to_kanji/src/core/models/paginated_data.dart";
import "package:kana_to_kanji/src/core/models/resources/example.dart";
import "package:kana_to_kanji/src/core/models/resources/resource_uid.dart";
import "package:kana_to_kanji/src/core/services/resources/resource_data_service.dart";
import "package:kana_to_kanji/src/core/utils/sql/order_by.dart";
import "package:kana_to_kanji/src/core/utils/sql/sql_column.dart";
import "package:kana_to_kanji/src/core/utils/sql/where.dart";
import "package:sqflite/sqflite.dart";

enum ExampleColumn implements SqlColumn {
  uid,
  sentence,
  translation,
  kanji,
  reading,
  version;

  @override
  final String prefix = "e";

  const ExampleColumn();

  /// Returns the column name with the prefix.
  @override
  String get selectColumn => "$prefix.$name";

  @override
  String get column => name;
}

enum KanjiExampleColumn implements SqlColumn {
  exampleUid("example_uid"),
  kanjiUid("kanji_uid");

  @override
  final String column;

  @override
  final String prefix = "ke";

  const KanjiExampleColumn(this.column);

  /// Returns the column name with the prefix.
  @override
  String get selectColumn => "$prefix.$column";
}

enum VocabularyExampleColumn implements SqlColumn {
  exampleUid("example_uid"),
  vocabularyUid("vocabulary_uid");

  @override
  final String column;

  @override
  final String prefix = "ve";

  const VocabularyExampleColumn(this.column);

  /// Returns the column name with the prefix.
  @override
  String get selectColumn => "$prefix.$column";
}

class ExampleService extends ResourceDataService<Example> {
  ExampleService()
    : super(
        tableName: "examples",
        transformer: _transformer,
        dataLoader: ExampleDataLoader(),
        resourceColumns: ExampleColumn.values.map((e) => e.column).toList(),
        syncFlag: PreferenceFlags.exampleLastVersionSynced,
      );

  /// Fetch examples from the API and save them to the database before
  /// returning them.
  ///
  /// To retrieve examples linked to a specific resource, use a [Where] with
  /// either [KanjiExampleColumn.kanjiUid] or
  /// [VocabularyExampleColumn.vocabularyUid].
  ///
  /// Currently [orderBy] is not supported.
  @override
  Future<PaginatedData<Example>> getPage(
    int page, {
    int pageSize = 100,
    List<OrderBy> orderBy = const [],
    List<Where> where = const [],
    List<dynamic>? whereArgs,
  }) async {
    if (where.isEmpty) {
      return _getNextPage(
        () => dataLoader.fetchAll(page: page + 1, pageSize: pageSize),
      );
    }
    final resourceUid = where.first.right;

    if (resourceUid is! ResourceUid) {
      throw ArgumentError(
        "Currently [where] only supports a ResourceUid as right parameter",
      );
    }

    return _getNextPage(
      () =>
          (dataLoader as ExampleDataLoader).fetchResourceExamples(resourceUid),
      onData:
          (examples, batch) =>
              _upsertExampleResourceLink(resourceUid, examples, batch),
    );
  }

  Future<PaginatedData<Example>> _getNextPage(
    FetchNextPageCallback<Example> next, {
    void Function(List<Example>, Batch batch)? onData,
  }) async {
    final PaginatedData<Example> examples = await next.call();
    await databaseService.transaction((Transaction transaction) async {
      final Batch batch = transaction.batch();
      for (final example in examples.data) {
        upsertData(example, batch, exists: false);
      }
      if (onData != null) {
        onData(examples.data, batch);
      }

      return batch.commit();
    });

    return examples.copyWith(
      next: examples.hasMore ? () => _getNextPage(examples.next!) : null,
    );
  }

  /// Upsert inside the join table between the [linkedTo] resource type
  /// and the example.
  void _upsertExampleResourceLink(
    ResourceUid linkedTo,
    List<Example> examples,
    Batch batch,
  ) {
    for (final example in examples) {
      batch.insert(
        "${linkedTo.resourceType.name}_examples",
        {
          "${linkedTo.resourceType.name}_uid": linkedTo.uid,
          "example_uid": example.uid.uid,
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }

  @override
  void upsertData(Example item, Batch batch, {required bool exists}) {
    if (exists) {
      batch.update(
        tableName,
        _buildMainColumns(item),
        where: sqlWhereUidColumn,
        whereArgs: [item.uid.uid],
      );
    } else {
      batch.insert(
        tableName,
        _buildMainColumns(item),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }

  Map<String, dynamic> _buildMainColumns(Example item) =>
      item.toJson()
        ..update(ExampleColumn.kanji.column, (_) => jsonEncode(item.kanji))
        ..update(ExampleColumn.reading.column, (_) => jsonEncode(item.reading));

  static Example _transformer(Map<String, dynamic> row) {
    final reading = jsonDecode(row[ExampleColumn.reading.name]);
    final kanji = jsonDecode(row[ExampleColumn.kanji.name]);

    return Example.fromJson({...row, kanji: kanji, reading: reading});
  }
}
