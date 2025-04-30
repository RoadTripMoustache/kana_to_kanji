import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/models/resources/resource_uid.dart";
import "package:kana_to_kanji/src/core/repositories/kana_repository.dart";
import "package:kana_to_kanji/src/core/services/kana_service.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

import "../../../dummies/kana.dart";

@GenerateNiceMocks([MockSpec<KanaService>()])
import "kana_repository_test.mocks.dart";

void main() {
  group("KanaRepository", () {
    late KanaRepository repository;
    late MockKanaService kanaServiceMock;

    setUp(() {
      kanaServiceMock = MockKanaService();
      repository = KanaRepository(kanaService: kanaServiceMock);
    });

    tearDown(() {
      reset(kanaServiceMock);
    });

    test("should properly handle service updates", () {
      // Verify initial setup with ListenableServiceMixin
      final void Function() onUpdate =
          verify(kanaServiceMock.addListener(captureAny)).captured.first;

      // Test notification propagation
      repository.items.add(dummyHiragana);
      onUpdate();
      expect(repository.items, isEmpty);
    });

    group("loadKana", () {
      test("it should load the kana from the KanaService", () async {
        when(
          kanaServiceMock.getHiragana(),
        ).thenAnswer((_) => Future.value([dummyHiragana]));
        when(
          kanaServiceMock.getKatakana(),
        ).thenAnswer((_) => Future.value([dummyKatakana]));

        expect(
          repository.items.length,
          0,
          reason: "Should be empty after initialization",
        );

        await repository.loadKana();

        verifyInOrder([
          kanaServiceMock.getHiragana(),
          kanaServiceMock.getKatakana(),
        ]);
        expect(
          repository.items,
          [dummyHiragana, dummyKatakana],
          reason:
              "Hiragana and katakana from the KanaService should be present",
        );
      });

      test(
        "it should not call the KanaService if kanas are already loaded",
        () async {
          repository.items.add(dummyHiragana);

          await repository.loadKana();

          verify(kanaServiceMock.addListener(captureAny)).called(1);
          verifyNoMoreInteractions(kanaServiceMock);
          expect(repository.items, [dummyHiragana]);
        },
      );
    });

    group("getHiragana", () {
      test("it should return all the hiragana", () async {
        repository.items.addAll([dummyHiragana, dummyKatakana]);

        expect(
          await repository.getHiragana(),
          [dummyHiragana],
          reason: "it should only return the hiragana",
        );
      });
    });

    group("getKatakana", () {
      test("it should return all the katakana", () async {
        repository.items.addAll([dummyHiragana, dummyKatakana]);

        expect(
          await repository.getKatakana(),
          [dummyKatakana],
          reason: "it should only return the katakana",
        );
      });
    });

    group("searchHiragana", () {
      test("should return empty list when search text is too long", () async {
        repository.items.addAll([dummyHiragana, dummyKatakana]);

        final result = await repository.searchHiragana("abcd", []);

        expect(result, isEmpty);
        verify(kanaServiceMock.addListener(captureAny)).called(1);
        verifyNoMoreInteractions(kanaServiceMock);
      });

      test(
        "should filter by romaji when search text is alphabetical",
        () async {
          when(
            kanaServiceMock.getHiragana(),
          ).thenAnswer((_) => Future.value([dummyHiragana]));
          when(
            kanaServiceMock.getKatakana(),
          ).thenAnswer((_) => Future.value([dummyKatakana]));

          final result = await repository.searchHiragana("a", []);

          expect(result.length, 1);
          expect(result.first.romaji, contains("a"));
        },
      );

      test(
        "should filter by kana when search text is not alphabetical",
        () async {
          when(
            kanaServiceMock.getHiragana(),
          ).thenAnswer((_) => Future.value([dummyHiragana]));
          when(
            kanaServiceMock.getKatakana(),
          ).thenAnswer((_) => Future.value([dummyKatakana]));

          final result = await repository.searchHiragana("あ", []);

          expect(result.length, 1);
          expect(result.first.kana, contains("あ"));
        },
      );
    });

    group("searchKatakana", () {
      test("should return empty list when search text is too long", () async {
        repository.items.addAll([dummyHiragana, dummyKatakana]);
        final result = await repository.searchKatakana("abcd", []);

        expect(result, isEmpty);

        verify(kanaServiceMock.addListener(captureAny)).called(1);
        verifyNoMoreInteractions(kanaServiceMock);
      });

      test(
        "should filter by romaji when search text is alphabetical",
        () async {
          when(
            kanaServiceMock.getHiragana(),
          ).thenAnswer((_) => Future.value([dummyHiragana]));
          when(
            kanaServiceMock.getKatakana(),
          ).thenAnswer((_) => Future.value([dummyKatakana]));

          final result = await repository.searchKatakana("a", []);

          expect(result.length, 1);
          expect(result.first.romaji, contains("a"));
        },
      );
    });

    group("getByGroupIds", () {
      test(
        "it should return all the kana related to the group id passed",
        () async {
          repository.items.addAll([dummyHiragana, dummyKatakana]);

          expect(
            await repository.getByGroupIds([dummyHiragana.groupUid]),
            [dummyHiragana],
            reason: "should contains the hiragana sample",
          );
        },
      );

      test(
        "it should return all the kana related to all the group ids passed",
        () async {
          repository.items.addAll([dummyHiragana, dummyKatakana]);

          expect(
            await repository.getByGroupIds([
              dummyHiragana.groupUid,
              dummyKatakana.groupUid,
            ]),
            containsAll([dummyHiragana, dummyKatakana]),
            reason: "should contains both hiragana and katakana",
          );
        },
      );
    });

    group("getByGroupId", () {
      test(
        "it should return all the kana related to the group id passed",
        () async {
          repository.items.addAll([dummyHiragana, dummyKatakana]);

          final ResourceUid groupId = dummyHiragana.groupUid;
          expect(
            await repository.getByGroupId(groupId),
            [dummyHiragana],
            reason: "should contains the hiragana sample",
          );
        },
      );
    });
  });
}
