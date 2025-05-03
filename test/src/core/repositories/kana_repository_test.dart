import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/models/resources/resource_uid.dart";
import "package:kana_to_kanji/src/core/repositories/kana_repository.dart";
import "package:kana_to_kanji/src/core/services/resources/kana_service.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:logger/logger.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

import "../../../dummies/kana.dart";

import "../../../helpers.dart";
@GenerateNiceMocks([MockSpec<KanaService>(), MockSpec<Logger>()])
import "kana_repository_test.mocks.dart";

void main() {
  group("KanaRepository", () {
    final MockKanaService kanaServiceMock = MockKanaService();
    late KanaRepository repository;

    setUpAll(() {
      locator
        ..registerSingleton<Logger>(MockLogger())
        ..registerSingleton<KanaService>(kanaServiceMock);
    });

    setUp(() {
      repository = KanaRepository();
    });

    tearDown(() {
      reset(kanaServiceMock);
    });

    tearDownAll(() async {
      await unregister<Logger>();
      await unregister<KanaService>();
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
          kanaServiceMock.getAll(),
        ).thenAnswer((_) => Future.value([dummyHiragana, dummyKatakana]));

        expect(
          repository.items.length,
          0,
          reason: "Should be empty before initialization",
        );

        await repository.initialize();

        verify(kanaServiceMock.getAll());
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

          await repository.initialize();

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
