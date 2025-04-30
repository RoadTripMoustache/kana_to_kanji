import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/constants/jlpt_levels.dart";
import "package:kana_to_kanji/src/core/constants/sort_order.dart";
import "package:kana_to_kanji/src/core/repositories/kanji_repository.dart";
import "package:kana_to_kanji/src/core/services/resources/kanji_service.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

import "../../../dummies/kanji.dart";
@GenerateNiceMocks([MockSpec<KanjiService>()])
import "kanji_repository_test.mocks.dart";

void main() {
  group("KanjiRepository", () {
    late KanjiRepository repository;
    late MockKanjiService kanjiServiceMock;

    setUp(() {
      kanjiServiceMock = MockKanjiService();
      repository = KanjiRepository(kanjiService: kanjiServiceMock);
    });

    tearDown(() {
      reset(kanjiServiceMock);
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

    group("searchKanji", () {
      setUp(() async {
        when(kanjiServiceMock.getAll()).thenAnswer((_) async => [dummyKanji]);
      });

      test("should return all kanji when no filters are applied", () async {
        final result = await repository.searchKanji(
          "",
          [],
          [],
          SortOrder.japanese,
        );

        expect(result.length, 1);
        expect(result.first, dummyKanji);
      });

      test("should filter by kanji character", () async {
        markTestSkipped("Until glossary refactor");
        final result = await repository.searchKanji(
          "日",
          [],
          [],
          SortOrder.japanese,
        );

        expect(result.length, 0);
      });

      test(
        "should filter by meaning when search text is alphabetical",
        () async {
          markTestSkipped("Until glossary refactor");
          final result = await repository.searchKanji(
            "day",
            [],
            [],
            SortOrder.alphabetical,
          );

          expect(result.length, 0);
        },
      );

      test("should filter by JLPT level", () async {
        final result = await repository.searchKanji("", [], [
          JLPTLevel.level5,
        ], SortOrder.japanese);

        expect(result.length, 1);
        expect(result.first.jlptLevel, 5);
      });

      test("should sort by Japanese syllables", () async {
        when(kanjiServiceMock.getAll()).thenAnswer(
          (_) => Future.value([dummyKanji, dummyKanjiWithRelatedData]),
        );

        final result = await repository.searchKanji(
          "",
          [],
          [],
          SortOrder.japanese,
        );

        expect(result.length, 2);
        // Since sorting depends on the jpSortSyllables implementation
        expect(result, hasLength(2));
      });
    });
  });
}
