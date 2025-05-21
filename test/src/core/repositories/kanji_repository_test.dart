import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/constants/jlpt_levels.dart";
import "package:kana_to_kanji/src/core/constants/sort_order.dart";
import "package:kana_to_kanji/src/core/models/paginated_data.dart";
import "package:kana_to_kanji/src/core/models/resources/kanji.dart";
import "package:kana_to_kanji/src/core/repositories/kanji_repository.dart";
import "package:kana_to_kanji/src/core/services/resources/kanji_service.dart";
import "package:kana_to_kanji/src/core/utils/sql/order_by.dart";
import "package:kana_to_kanji/src/core/utils/sql/where.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:logger/logger.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

import "../../../dummies/kanji.dart";
import "../../../helpers.dart";
@GenerateNiceMocks([MockSpec<KanjiService>(), MockSpec<Logger>()])
import "kanji_repository_test.mocks.dart";

void main() {
  group("KanjiRepository", () {
    late KanjiRepository repository;
    final MockKanjiService kanjiServiceMock = MockKanjiService();

    setUpAll(() {
      locator
        ..registerSingleton<Logger>(MockLogger())
        ..registerSingleton<KanjiService>(kanjiServiceMock);
    });

    setUp(() {
      repository = KanjiRepository();
    });

    tearDown(() {
      reset(kanjiServiceMock);
    });

    tearDownAll(() async {
      await unregister<Logger>();
      await unregister<KanjiService>();
    });

    test("should properly handle service updates", () {
      // Verify initial setup with ListenableServiceMixin
      final void Function() captured =
          verify(kanjiServiceMock.addListener(captureAny)).captured.first;

      // Test notification propagation
      repository.items.add(dummyKanji);
      captured();
      expect(repository.items, isEmpty);
    });

    group("getAll", () {
      test("it should load all the kanji from the service", () async {
        when(kanjiServiceMock.getAll()).thenAnswer((_) async => dummiesKanji);
        expect(await repository.getAll(), dummiesKanji);

        verify(kanjiServiceMock.getAll()).called(1);
      });

      test(
        "it should not call the service if items are already loaded",
        () async {
          repository.items.add(dummyKanji);

          expect(await repository.getAll(), [dummyKanji]);

          verify(kanjiServiceMock.addListener(any)).called(1);
          verifyNoMoreInteractions(kanjiServiceMock);
        },
      );
    });

    group("get", () {
      PaginatedData<Kanji> paginatedData = PaginatedData(data: [dummyKanji]);

      setUp(() {
        paginatedData = PaginatedData(data: [dummyKanji]);
        provideDummy<PaginatedData<Kanji>>(paginatedData);
      });

      test(
        "should call service with correct parameters when no filters",
        () async {
          when(
            kanjiServiceMock.getPage(
              any,
              pageSize: anyNamed("pageSize"),
              where: anyNamed("where"),
              orderBy: anyNamed("orderBy"),
            ),
          ).thenAnswer((_) async => paginatedData);

          final result = await repository.getMultiple(
            orderBy: SortOrder.japanese,
          );

          final List<OrderBy> orderBys =
              verify(
                kanjiServiceMock.getPage(
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
              OrderBy(KanjiColumn.jlptLevel, direction: OrderByDirection.desc),
              OrderBy(KanjiColumn.mainReading),
            ]),
          );
          expect(result.data, [dummyKanji]);
          expect(result.hasMore, false);
        },
      );

      test("should apply JLPT filter correctly", () async {
        when(
          kanjiServiceMock.getPage(
            any,
            where: anyNamed("where"),
            orderBy: anyNamed("orderBy"),
          ),
        ).thenAnswer((_) async => paginatedData);

        final jlptFilter = [JLPTLevel.n5];

        await repository.getMultiple(
          where: {JLPTLevel: jlptFilter},
          orderBy: SortOrder.alphabetical,
        );

        final captured =
            verify(
              kanjiServiceMock.getPage(
                0,
                where: captureAnyNamed("where"),
                orderBy: captureAnyNamed("orderBy"),
              ),
            ).captured;

        final whereClause = captured.first as List<Where>;
        expect(
          whereClause,
          contains(
            Where(KanjiColumn.jlptLevel, WhereOperator.inList, jlptFilter),
          ),
        );

        final orderByClause = captured.last as List<OrderBy>;
        expect(orderByClause.length, 2);
        expect(
          orderByClause,
          containsAll([
            OrderBy(KanjiColumn.jlptLevel, direction: OrderByDirection.desc),
            OrderBy(KanjiColumn.mainMeaning),
          ]),
        );
      });

      test("should handle pagination correctly", () async {
        final nextPageData = [dummyKanjiWithRelatedData];
        paginatedData = paginatedData.copyWith(
          next: () async => PaginatedData<Kanji>(data: nextPageData),
        );

        when(
          kanjiServiceMock.getPage(
            any,
            where: anyNamed("where"),
            orderBy: anyNamed("orderBy"),
          ),
        ).thenAnswer((_) async => paginatedData);

        final result = await repository.getMultiple(
          orderBy: SortOrder.japanese,
        );
        expect(result.data, [dummyKanji]);
        expect(result.hasMore, true);

        // Request next page
        final secondPage = await result.next!();
        expect(secondPage.data, nextPageData);
        expect(secondPage.hasMore, false);
        expect(repository.items, [dummyKanji, dummyKanjiWithRelatedData]);
      });
    });
  });
}
