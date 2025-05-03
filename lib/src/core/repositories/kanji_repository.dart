import "package:kana_to_kanji/src/core/constants/jlpt_levels.dart";
import "package:kana_to_kanji/src/core/constants/knowledge_level.dart";
import "package:kana_to_kanji/src/core/constants/sort_order.dart";
import "package:kana_to_kanji/src/core/models/paginated_data.dart";
import "package:kana_to_kanji/src/core/models/resources/kanji.dart";
import "package:kana_to_kanji/src/core/models/resources/pronunciation.dart";
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
  /// [where] is a Map{Type, List}
  /// [orderBy] is a [SortOrder]
  @override
  Future<PaginatedData<Kanji>> get({
    dynamic where = const <Type, List<dynamic>>{},
    dynamic orderBy,
  }) async {
    assert(
      where is Map<Type, List<dynamic>>,
      "Where should be a Map<Type, List<dynamic>>",
    );
    assert(orderBy is SortOrder, "OrderBy should be a SortOrder");
    final KanjiColumn by =
        orderBy == SortOrder.japanese
            ? KanjiColumn.mainReading
            : KanjiColumn.mainMeaning;
    // ignore: avoid_dynamic_calls Ignore here as assert is present.
    final List<JLPTLevel> jlptFilter = where[JLPTLevel] ?? [];

    final List<Where> wheres = [
      if (jlptFilter.isNotEmpty)
        Where<KanjiColumn, List<JLPTLevel>>(
          KanjiColumn.jlptLevel,
          WhereOperator.inList,
          jlptFilter,
        ),
    ];

    final List<OrderBy> orderBys = [
      OrderBy<KanjiColumn>(
        KanjiColumn.jlptLevel,
        direction: OrderByDirection.desc,
      ),
      OrderBy<KanjiColumn>(by),
    ];

    return super.get(where: wheres, orderBy: orderBys);
  }

  Future<List<Kanji>> searchKanji(
    String searchTxt,
    List<KnowledgeLevel> selectedKnowledgeLevel,
    List<JLPTLevel> selectedJLPTLevel,
    SortOrder selectedOrder,
  ) async {
    await getAll();

    var txtFilter = (Kanji element) => true;
    if (searchTxt != "" && alphabeticalRegex.hasMatch(searchTxt)) {
      txtFilter =
          (kanji) =>
              kanji.meanings
                  .where((meaning) => meaning.contains(searchTxt))
                  .toList()
                  .isNotEmpty;
    } else if (searchTxt != "") {
      txtFilter =
          (kanji) =>
              kanji.kanji == searchTxt ||
              kanji.pronunciations
                  .where((Pronunciation p) => p.readings.contains(searchTxt))
                  .toList()
                  .isNotEmpty;
    }

    var knowledgeLevelFilter = (Kanji element) => true;
    if (selectedKnowledgeLevel.isNotEmpty) {
      // TODO : To implement once level is added
      knowledgeLevelFilter = (Kanji element) => false;
    }

    var jlptLevelFilter = (Kanji element) => true;
    if (selectedJLPTLevel.isNotEmpty) {
      jlptLevelFilter =
          (Kanji kanji) =>
              selectedJLPTLevel.contains(JLPTLevel.getValue(kanji.jlptLevel));
    }
    final kanjiList =
        items
            .where(txtFilter)
            .where(knowledgeLevelFilter)
            .where(jlptLevelFilter)
            .toList();

    // if (selectedOrder == SortOrder.japanese) {
    //   kanjiList.sort(
    //     (Kanji a, Kanji b) =>
    //         sortBySyllables(a.jpSortSyllables, b.jpSortSyllables),
    //   );
    // } else {
    //   kanjiList.sort(
    //     (Kanji a, Kanji b) => a.meanings[0].compareTo(b.meanings[0]),
    //   );
    // }

    return kanjiList;
  }
}
