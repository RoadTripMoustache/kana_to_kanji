import "package:kana_to_kanji/src/core/constants/jlpt_levels.dart";
import "package:kana_to_kanji/src/core/constants/sort_order.dart";
import "package:kana_to_kanji/src/core/models/paginated_data.dart";
import "package:kana_to_kanji/src/core/models/resources/vocabulary.dart";
import "package:kana_to_kanji/src/core/repositories/resource_repository.dart";
import "package:kana_to_kanji/src/core/services/resources/vocabulary_service.dart";
import "package:kana_to_kanji/src/core/utils/sql/order_by.dart";
import "package:kana_to_kanji/src/core/utils/sql/where.dart";

class VocabularyRepository
    extends ResourceRepository<Vocabulary, VocabularyService> {
  final RegExp alphabeticalRegex = RegExp(r"([a-zA-Z])$");

  /// Retrieve all the vocabulary
  Future<List<Vocabulary>> getAll() async {
    if (items.isNotEmpty) {
      return items;
    }

    items.addAll(await service.getAll());

    return items;
  }

  /// Retrieve vocabulary from the database following given criteria
  ///
  /// [where] is a Map{Type, List} List of filters accepted
  ///   -> [JLPTLevel]: List of JLPT levels.
  ///   -> [String]: Search text.
  /// [orderBy] is a [SortOrder]
  @override
  Future<PaginatedData<Vocabulary>> get({
    dynamic where = const <Type, dynamic>{},
    dynamic orderBy,
  }) async {
    assert(
      where is Map<Type, dynamic>,
      "Where should be a Map<Type, List<dynamic>>",
    );
    assert(orderBy is SortOrder, "OrderBy should be a SortOrder");
    final VocabularyColumn by =
        orderBy == SortOrder.japanese
            ? VocabularyColumn.kana
            : VocabularyColumn.romaji;
    // ignore: avoid_dynamic_calls Ignore here as assert is present.
    final List<JLPTLevel> jlptFilter = where[JLPTLevel] ?? [];
    // ignore: avoid_dynamic_calls
    final String searchText = where[String] ?? "";

    final List<Where> wheres = [
      if (jlptFilter.isNotEmpty)
        Where<VocabularyColumn, List<JLPTLevel>>(
          VocabularyColumn.jlptLevel,
          WhereOperator.inList,
          jlptFilter,
        ),
      if (searchText.isNotEmpty)
        ..._buildSearchWhere(searchText, jlptFilter.isNotEmpty),
    ];

    final List<OrderBy> orderBys = [
      OrderBy<VocabularyColumn>(
        VocabularyColumn.jlptLevel,
        direction: OrderByDirection.desc,
      ),
      OrderBy<VocabularyColumn>(by),
    ];

    return super.get(where: wheres, orderBy: orderBys);
  }

  List<Where> _buildSearchWhere(String searchText, bool isSecondWhere) {
    if (alphabeticalRegex.hasMatch(searchText)) {
      return [
        Where(
          VocabularyColumn.meanings,
          WhereOperator.like,
          searchText,
          condition: isSecondWhere ? WhereCondition.and : null,
        ),
        Where(
          VocabularyColumn.romaji,
          WhereOperator.like,
          searchText,
          condition: WhereCondition.or,
        ),
      ];
    }
    return [
      Where(
        VocabularyColumn.kanji,
        WhereOperator.like,
        searchText,
        condition: isSecondWhere ? WhereCondition.and : null,
      ),
      Where(
        VocabularyColumn.kana,
        WhereOperator.like,
        searchText,
        condition: WhereCondition.or,
      ),
    ];
  }
}
