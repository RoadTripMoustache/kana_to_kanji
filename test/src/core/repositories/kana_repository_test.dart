import "package:flutter_test/flutter_test.dart";
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

    final kanaServiceMock = MockKanaService();

    setUp(() {
      repository = KanaRepository(kanaService: kanaServiceMock);
    });

    tearDown(() {
      reset(kanaServiceMock);
    });

    group("loadKana", () {
      test("it should load the kana from the KanaService", () {
        when(kanaServiceMock.getHiragana()).thenReturn([dummyHiragana]);
        when(kanaServiceMock.getKatakana()).thenReturn([dummyKatakana]);

        expect(repository.kana.length, 0,
            reason: "Should be empty after initialization");

        repository.loadKana();

        verifyInOrder(
            [kanaServiceMock.getHiragana(), kanaServiceMock.getKatakana()]);
        expect(repository.kana, [dummyHiragana, dummyKatakana],
            reason:
                "Hiragana and katakana from the KanaService should be present");
      });

      test("it should not call the KanaService if kanas are already loaded",
          () {
        repository.kana.add(dummyHiragana);

        repository.loadKana();

        verifyZeroInteractions(kanaServiceMock);
        expect(repository.kana, [dummyHiragana]);
      });
    });

    group("getHiragana", () {
      test("it should return all the hiragana", () {
        repository.kana.addAll([dummyHiragana, dummyKatakana]);

        expect(repository.getHiragana(), [dummyHiragana],
            reason: "it should only return the hiragana");
      });
    });

    group("getKatakana", () {
      test("it should return all the katakana", () {
        repository.kana.addAll([dummyHiragana, dummyKatakana]);

        expect(repository.getKatakana(), [dummyKatakana],
            reason: "it should only return the katakana");
      });
    });

    group("getByGroupIds", () {
      test("it should return all the kana related to the group id passed", () {
        repository.kana.addAll([dummyHiragana, dummyKatakana]);

        expect(
            repository.getByGroupIds([dummyHiragana.groupUid]), [dummyHiragana],
            reason: "should contains the hiragana sample");
      });

      test("it should return all the kana related to all the group ids passed",
          () {
        repository.kana.addAll([dummyHiragana, dummyKatakana]);

        expect(
            repository.getByGroupIds(
                [dummyHiragana.groupUid, dummyKatakana.groupUid]),
            containsAll([dummyHiragana, dummyKatakana]),
            reason: "should contains both hiragana and katakana");
      });
    });

    group("getByGroupId", () {
      test("it should return all the kana related to the group id passed", () {
        repository.kana.addAll([dummyHiragana, dummyKatakana]);

        expect(repository.getByGroupId(dummyHiragana.groupUid), [dummyHiragana],
            reason: "should contains the hiragana sample");
      });
    });
  });
}
