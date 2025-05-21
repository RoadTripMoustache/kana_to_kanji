import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/constants/jlpt_levels.dart";
import "package:kana_to_kanji/src/core/constants/sort_order.dart";
import "package:kana_to_kanji/src/core/models/paginated_data.dart";
import "package:kana_to_kanji/src/core/models/resources/resources.dart";
import "package:kana_to_kanji/src/core/repositories/kanji_repository.dart";
import "package:kana_to_kanji/src/glossary/pagination_helper.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

import "../../dummies/dummies.dart";

@GenerateNiceMocks([MockSpec<KanjiRepository>()])
import "pagination_helper_test.mocks.dart";

void main() {
  group("PaginationHelper", () {
    late PaginationHelper<Kanji, KanjiRepository> paginationHelper;
    final kanjiRepositoryMock = MockKanjiRepository();

    setUpAll(() {
      provideDummy<PaginatedData<Kanji>>(PaginatedData(data: dummiesKanji));
      locator.registerSingleton<KanjiRepository>(kanjiRepositoryMock);
    });

    setUp(() async {
      // Setup repository mock to return empty data
      when(
        kanjiRepositoryMock.getMultiple(
          where: anyNamed("where"),
          orderBy: anyNamed("orderBy"),
        ),
      ).thenAnswer((_) async => PaginatedData<Kanji>(data: []));

      paginationHelper = PaginationHelper<Kanji, KanjiRepository>();
    });

    tearDown(() {
      reset(kanjiRepositoryMock);
    });

    tearDownAll(() async {
      locator.unregister<KanjiRepository>(instance: kanjiRepositoryMock);
    });

    test("Should initialize with empty data", () {
      expect(paginationHelper.hasData, isFalse);
      expect(paginationHelper.pagingState.pages, isNull);
      expect(paginationHelper.pagingState.keys, isNull);
      expect(paginationHelper.pagingState.isLoading, isFalse);
    });

    test(
      "Should fetch data from repository when fetchNextPage is called",
      () async {
        // Setup repository to return data
        final kanjiList = [dummyKanji];

        when(
          kanjiRepositoryMock.getMultiple(
            where: anyNamed("where"),
            orderBy: anyNamed("orderBy"),
          ),
        ).thenAnswer((_) async => PaginatedData<Kanji>(data: kanjiList));

        await paginationHelper.fetchNextPage();

        expect(paginationHelper.hasData, isTrue);
        expect(paginationHelper.pagingState.pages, isNotNull);
        expect(paginationHelper.pagingState.pages!.length, 1);
        expect(paginationHelper.pagingState.pages!.first, kanjiList);
        expect(paginationHelper.pagingState.keys, isNotNull);
        expect(paginationHelper.pagingState.keys!.length, 1);
        expect(paginationHelper.pagingState.keys!.first, 1);
        expect(paginationHelper.pagingState.hasNextPage, isFalse);
        expect(paginationHelper.pagingState.isLoading, isFalse);

        verify(
          kanjiRepositoryMock.getMultiple(
            where: anyNamed("where"),
            orderBy: anyNamed("orderBy"),
          ),
        ).called(1);
      },
    );

    test(
      "Should update search parameters and reset data when update is called",
      () async {
        // Setup initial data
        final initialKanjiList = [dummyKanji];

        when(
          kanjiRepositoryMock.getMultiple(
            where: anyNamed("where"),
            orderBy: anyNamed("orderBy"),
          ),
        ).thenAnswer((_) async => PaginatedData<Kanji>(data: initialKanjiList));

        await paginationHelper.fetchNextPage();

        // Verify initial data
        expect(paginationHelper.hasData, isTrue);
        expect(paginationHelper.pagingState.pages!.length, 1);

        // Setup new data for update
        final updatedKanjiList = [dummyKanjiWithRelatedData];

        when(
          kanjiRepositoryMock.getMultiple(
            where: anyNamed("where"),
            orderBy: anyNamed("orderBy"),
          ),
        ).thenAnswer((_) async => PaginatedData<Kanji>(data: updatedKanjiList));

        // Update with new search parameters
        const searchTerm = "test";
        final jlptFilter = [JLPTLevel.n5];
        const sortOrder = SortOrder.alphabetical;

        paginationHelper.update(searchTerm, jlptFilter, sortOrder);

        await untilCalled(
          kanjiRepositoryMock.getMultiple(
            where: anyNamed("where"),
            orderBy: anyNamed("orderBy"),
          ),
        );

        // Verify data was reset and new data was fetched
        expect(paginationHelper.pagingState.pages!.length, 1);
        expect(paginationHelper.pagingState.pages!.first, updatedKanjiList);

        // Verify repository was called with new parameters
        verify(
          kanjiRepositoryMock.getMultiple(
            where: {JLPTLevel: jlptFilter, String: searchTerm},
            orderBy: sortOrder,
          ),
        ).called(1);
      },
    );

    test("Should fetch next page when available", () async {
      // Setup repository to return data with next page
      final firstPageKanjiList = [dummyKanji];
      final secondPageKanjiList = [dummyKanjiWithRelatedData];

      // Setup first page response
      when(
        kanjiRepositoryMock.getMultiple(
          where: anyNamed("where"),
          orderBy: anyNamed("orderBy"),
        ),
      ).thenAnswer(
        (_) async => PaginatedData<Kanji>(
          data: firstPageKanjiList,
          next: () async => PaginatedData<Kanji>(data: secondPageKanjiList),
        ),
      );

      // Fetch first page
      await paginationHelper.fetchNextPage();

      // Verify first page data
      expect(paginationHelper.hasData, isTrue);
      expect(paginationHelper.pagingState.pages!.length, 1);
      expect(paginationHelper.pagingState.pages!.first, firstPageKanjiList);
      expect(paginationHelper.pagingState.hasNextPage, isTrue);

      // Fetch second page
      await paginationHelper.fetchNextPage();

      // Verify second page data was added
      expect(paginationHelper.pagingState.pages!.length, 2);
      expect(paginationHelper.pagingState.pages!.last, secondPageKanjiList);
      expect(paginationHelper.pagingState.hasNextPage, isFalse);
    });
  });
}
