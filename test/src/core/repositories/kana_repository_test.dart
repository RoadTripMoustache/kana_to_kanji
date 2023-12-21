import 'package:flutter_test/flutter_test.dart';
import 'package:kana_to_kanji/src/core/constants/alphabets.dart';
import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/core/repositories/kana_repository.dart';
import 'package:kana_to_kanji/src/core/services/kana_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<KanaService>()])
import 'kana_repository_test.mocks.dart';

void main() {
  group("KanaRepository", () {
    final hiraganaSample =
        Kana(0, Alphabets.hiragana, 0, "あ", "a", "2023-12-01");
    final katakanaSample =
        Kana(1, Alphabets.katakana, 1, "ア", "a", "2023-12-01");
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
        when(kanaServiceMock.getHiragana()).thenReturn([hiraganaSample]);
        when(kanaServiceMock.getKatakana()).thenReturn([katakanaSample]);

        expect(repository.kana.length, 0,
            reason: "Should be empty after initialization");

        repository.loadKana();

        verifyInOrder(
            [kanaServiceMock.getHiragana(), kanaServiceMock.getKatakana()]);
        expect(repository.kana, [hiraganaSample, katakanaSample],
            reason:
                "Hiragana and katakana from the KanaService should be present");
      });

      test("it should not call the KanaService if kanas are already loaded",
          () {
        repository.kana.add(hiraganaSample);

        repository.loadKana();

        verifyZeroInteractions(kanaServiceMock);
        expect(repository.kana, [hiraganaSample]);
      });
    });

    group("getHiragana", () {
      test("it should return all the hiragana", () {
        repository.kana.addAll([hiraganaSample, katakanaSample]);

        expect(repository.getHiragana(), [hiraganaSample],
            reason: "it should only return the hiragana");
      });
    });

    group("getKatakana", () {
      test("it should return all the katakana", () {
        repository.kana.addAll([hiraganaSample, katakanaSample]);

        expect(repository.getKatakana(), [katakanaSample],
            reason: "it should only return the katakana");
      });
    });

    group("getByGroupIds", () {
      test("it should return all the kana related to the group id passed", () {
        repository.kana.addAll([hiraganaSample, katakanaSample]);

        expect(repository.getByGroupIds([hiraganaSample.groupId]),
            [hiraganaSample],
            reason: "should contains the hiragana sample");
      });

      test("it should return all the kana related to all the group ids passed",
          () {
        repository.kana.addAll([hiraganaSample, katakanaSample]);

        expect(
            repository.getByGroupIds(
                [hiraganaSample.groupId, katakanaSample.groupId]),
            containsAll([hiraganaSample, katakanaSample]),
            reason: "should contains both hiragana and katakana");
      });
    });

    group("getByGroupId", () {
      test("it should return all the kana related to the group id passed", () {
        repository.kana.addAll([hiraganaSample, katakanaSample]);

        expect(
            repository.getByGroupId(hiraganaSample.groupId), [hiraganaSample],
            reason: "should contains the hiragana sample");
      });
    });
  });
}
