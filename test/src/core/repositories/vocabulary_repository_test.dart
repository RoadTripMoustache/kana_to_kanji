import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/constants/jlpt_levels.dart";
import "package:kana_to_kanji/src/core/constants/sort_order.dart";
import "package:kana_to_kanji/src/core/models/paginated_data.dart";
import "package:kana_to_kanji/src/core/models/resources/vocabulary.dart";
import "package:kana_to_kanji/src/core/repositories/vocabulary_repository.dart";
import "package:kana_to_kanji/src/core/services/resources/vocabulary_service.dart";
import "package:kana_to_kanji/src/core/utils/sql/order_by.dart";
import "package:kana_to_kanji/src/core/utils/sql/where.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:logger/logger.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

import "../../../dummies/vocabulary.dart";
import "../../../helpers.dart";

@GenerateNiceMocks([MockSpec<VocabularyService>(), MockSpec<Logger>()])
import "vocabulary_repository_test.mocks.dart";

void main() {
  group("VocabularyRepository", () {
    late VocabularyRepository repository;
    final MockVocabularyService vocabularyServiceMock = MockVocabularyService();

    setUpAll(() {
      locator
        ..registerSingleton<Logger>(MockLogger())
        ..registerSingleton<VocabularyService>(vocabularyServiceMock);
    });

    setUp(() {
      repository = VocabularyRepository();
    });

    tearDown(() {
      reset(vocabularyServiceMock);
    });

    tearDownAll(() async {
      await unregister<Logger>();
      await unregister<VocabularyService>();
    });

    test("should properly handle service updates", () {
      // Verify initial setup with ListenableServiceMixin
      final void Function() listener =
          verify(vocabularyServiceMock.addListener(captureAny)).captured.first;

      // Test notification propagation
      repository.items.add(dummyVocabulary);
      listener();
      expect(repository.items, isEmpty);
    });

    group("getAll", () {
      test("it should load all vocabulary from the service", () async {
        when(
          vocabularyServiceMock.getAll(),
        ).thenAnswer((_) => Future.value([dummyVocabulary]));

        expect(await repository.getAll(), [dummyVocabulary]);
        verify(vocabularyServiceMock.getAll());
      });

      test(
        "it should not call the service if items are already loaded",
        () async {
          repository.items.add(dummyVocabulary);

          expect(await repository.getAll(), [dummyVocabulary]);
          verify(vocabularyServiceMock.addListener(any)).called(1);
          verifyNoMoreInteractions(vocabularyServiceMock);
        },
      );
    });

    group("get", () {
      PaginatedData<Vocabulary> paginatedData = PaginatedData(
        data: [dummyVocabulary],
      );

      setUp(() {
        paginatedData = PaginatedData(data: [dummyVocabulary]);
        provideDummy<PaginatedData<Vocabulary>>(paginatedData);
      });

      test(
        "should call service with correct parameters when no filters",
        () async {
          when(
            vocabularyServiceMock.getPage(
              any,
              pageSize: anyNamed("pageSize"),
              where: anyNamed("where"),
              orderBy: anyNamed("orderBy"),
            ),
          ).thenAnswer((_) async => paginatedData);

          final result = await repository.get(orderBy: SortOrder.japanese);

          final List<OrderBy> orderBys =
              verify(
                vocabularyServiceMock.getPage(
                  0,
                  pageSize: anyNamed("pageSize"),
                  where: [],
                  orderBy: captureAnyNamed("orderBy"),
                ),
              ).captured.first;

          expect(orderBys.length, 2);
          expect(
            orderBys,
            containsAll([
              OrderBy(
                VocabularyColumn.jlptLevel,
                direction: OrderByDirection.desc,
              ),
              OrderBy(VocabularyColumn.kana),
            ]),
          );
          expect(result.data, [dummyVocabulary]);
          expect(result.hasMore, false);
        },
      );

      test("should apply alphabetical sort order correctly", () async {
        when(
          vocabularyServiceMock.getPage(
            any,
            where: anyNamed("where"),
            orderBy: anyNamed("orderBy"),
          ),
        ).thenAnswer((_) async => paginatedData);

        await repository.get(orderBy: SortOrder.alphabetical);

        final List<OrderBy> orderBys =
            verify(
              vocabularyServiceMock.getPage(
                0,
                where: anyNamed("where"),
                orderBy: captureAnyNamed("orderBy"),
              ),
            ).captured.first;

        expect(orderBys.length, 2);
        expect(
          orderBys,
          containsAll([
            OrderBy(
              VocabularyColumn.jlptLevel,
              direction: OrderByDirection.desc,
            ),
            OrderBy(VocabularyColumn.romaji),
          ]),
        );
      });

      test("should apply JLPT filter correctly", () async {
        when(
          vocabularyServiceMock.getPage(
            any,
            where: anyNamed("where"),
            orderBy: anyNamed("orderBy"),
          ),
        ).thenAnswer((_) async => paginatedData);
        final jlptFilter = [JLPTLevel.n5];

        await repository.get(
          where: {JLPTLevel: jlptFilter},
          orderBy: SortOrder.alphabetical,
        );

        final captured =
            verify(
              vocabularyServiceMock.getPage(
                0,
                where: captureAnyNamed("where"),
                orderBy: captureAnyNamed("orderBy"),
              ),
            ).captured;

        final whereClause = captured.first as List<Where>;
        expect(
          whereClause,
          contains(
            Where(VocabularyColumn.jlptLevel, WhereOperator.inList, jlptFilter),
          ),
        );
      });

      test("should handle pagination correctly", () async {
        paginatedData = paginatedData.copyWith(
          next:
              () async => PaginatedData<Vocabulary>(
                data: [dummyVocabularyWithRelatedData],
              ),
        );

        when(
          vocabularyServiceMock.getPage(
            any,
            where: anyNamed("where"),
            orderBy: anyNamed("orderBy"),
          ),
        ).thenAnswer((_) async => paginatedData);

        final result = await repository.get(orderBy: SortOrder.japanese);
        expect(result.data, [dummyVocabulary]);
        expect(result.hasMore, true);

        // Request next page
        final secondPage = await result.next!();
        expect(secondPage.data, [dummyVocabularyWithRelatedData]);
        expect(secondPage.hasMore, false);
        expect(repository.items, [
          dummyVocabulary,
          dummyVocabularyWithRelatedData,
        ]);
      });
    });
  });
}
