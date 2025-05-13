import "package:kana_to_kanji/src/core/constants/resource_type.dart";
import "package:kana_to_kanji/src/core/models/paginated_data.dart";
import "package:kana_to_kanji/src/core/models/resources/example.dart";
import "package:kana_to_kanji/src/core/models/resources/resource_uid.dart";
import "package:kana_to_kanji/src/core/repositories/resource_repository.dart";
import "package:kana_to_kanji/src/core/services/resources/example_service.dart";
import "package:kana_to_kanji/src/core/utils/sql/where.dart";

class ExampleRepository extends ResourceRepository<Example, ExampleService> {
  Future<PaginatedData<Example>> getResourceExamples(
    ResourceUid uid, {
    int limit = 1,
  }) async {
    assert(limit > 0 && limit <= 100, "limit must be between 1 and 100");
    assert(
      [ResourceType.kanji, ResourceType.vocabulary].contains(uid.resourceType),
      "examples are only available for kanji and vocabulary",
    );

    switch (uid.resourceType) {
      case ResourceType.kanji:
        return _getKanjiExamples(uid, limit: limit);
      case ResourceType.vocabulary:
        return _getVocabularyExamples(uid, limit: limit);
      // ignore: no_default_cases ignoring because of the assert above
      default:
        throw UnimplementedError(
          "Examples for ${uid.resourceType} are not available yet.",
        );
    }
  }

  /// Retrieve [limit] examples for the given kanji [uid].
  ///
  /// Note that [limit] must be a positive integer between 1 and 100.
  Future<PaginatedData<Example>> _getKanjiExamples(
    ResourceUid uid, {
    int limit = 100,
  }) async {
    final page = await service.getPage(
      0,
      where: [Where(KanjiExampleColumn.kanjiUid, WhereOperator.equal, uid)],
      pageSize: limit,
    );

    return page.copyWith(
      next: page.hasMore ? () => nextPage(page.next!) : null,
    );
  }

  /// Retrieve [limit] examples for the given vocabulary [uid].
  ///
  /// Note that [limit] must be a positive integer between 1 and 100.
  Future<PaginatedData<Example>> _getVocabularyExamples(
    ResourceUid uid, {
    int limit = 1,
  }) async {
    final page = await service.getPage(
      0,
      where: [
        Where(VocabularyExampleColumn.vocabularyUid, WhereOperator.equal, uid),
      ],
      pageSize: limit,
    );

    return page.copyWith(
      next: page.hasMore ? () => nextPage(page.next!) : null,
    );
  }
}
