import "package:kana_to_kanji/src/core/constants/jlpt_levels.dart";
import "package:kana_to_kanji/src/core/constants/sort_order.dart";
import "package:kana_to_kanji/src/core/models/paginated_data.dart";
import "package:kana_to_kanji/src/core/models/resources/kanji.dart";
import "package:kana_to_kanji/src/core/repositories/resource_repository.dart";
import "package:kana_to_kanji/src/core/services/resources/kanji_service.dart";
import "package:kana_to_kanji/src/core/utils/sql/order_by.dart";
import "package:kana_to_kanji/src/core/utils/sql/where.dart";

class KanjiRepository extends ResourceRepository<Kanji, KanjiService> {
  final RegExp alphabeticalRegex = RegExp(r"([a-zA-Z])$");

  /// Retrieve all the kanji from the database
  Future<List<Kanji>> getAll() async {
    if (items.isNotEmpty) {
      return items;
    }
    items.addAll(await service.getAll());

    return items;
  }

  /// Retrieve kanji from the database following given criteria
  ///
  /// [where] is a Map{Type, List}. List of filters accepted
  ///   -> [JLPTLevel]: List of JLPT levels.
  ///   -> [String]: Search text.
  /// [orderBy] is a [SortOrder]
  @override
  Future<PaginatedData<Kanji>> getMultiple({
    dynamic where = const <Type, dynamic>{},
    dynamic orderBy,
  }) async {
    assert(
      where is Map<Type, dynamic>,
      "Where should be a Map<Type, List<dynamic>>",
    );
    assert(orderBy is SortOrder, "OrderBy should be a SortOrder");
    final KanjiColumn by =
        orderBy == SortOrder.japanese
            ? KanjiColumn.mainReading
            : KanjiColumn.mainMeaning;
    // ignore: avoid_dynamic_calls Ignore here as assert is present.
    final List<JLPTLevel> jlptFilter = where[JLPTLevel] ?? [];
    // ignore: avoid_dynamic_calls
    final String searchText = where[String] ?? "";

    final List<Where> wheres = [
      if (jlptFilter.isNotEmpty)
        Where<KanjiColumn, List<JLPTLevel>>(
          KanjiColumn.jlptLevel,
          WhereOperator.inList,
          jlptFilter,
        ),
      if (searchText.isNotEmpty)
        ..._buildSearchWhere(searchText, jlptFilter.isNotEmpty),
    ];

    final List<OrderBy> orderBys = [
      OrderBy<KanjiColumn>(
        KanjiColumn.jlptLevel,
        direction: OrderByDirection.desc,
      ),
      OrderBy<KanjiColumn>(by),
    ];

    return super.getMultiple(where: wheres, orderBy: orderBys);
  }

  List<Where> _buildSearchWhere(String searchText, bool isSecondWhere) {
    if (alphabeticalRegex.hasMatch(searchText)) {
      return [
        Where(
          KanjiColumn.meanings,
          WhereOperator.like,
          searchText,
          condition: isSecondWhere ? WhereCondition.and : null,
        ),
        Where(
          KanjiColumn.mainMeaning,
          WhereOperator.like,
          searchText,
          condition: WhereCondition.or,
        ),
      ];
    }
    return [
      Where(
        KanjiColumn.kanji,
        WhereOperator.like,
        searchText,
        condition: isSecondWhere ? WhereCondition.and : null,
      ),
      Where(
        KanjiColumn.readings,
        WhereOperator.like,
        searchText,
        condition: WhereCondition.or,
      ),
    ];
  }
}
