import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/repositories/kanji_repository.dart";
import "package:kana_to_kanji/src/core/services/kanji_service.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

import "../../../dummies/kanji.dart";
@GenerateNiceMocks([MockSpec<KanjiService>()])
import "kanji_repository_test.mocks.dart";

void main() {
  group("KanjiRepository", () {
    late KanjiRepository repository;

    final kanjiServiceMock = MockKanjiService();

    setUp(() {
      repository = KanjiRepository(kanjiService: kanjiServiceMock);
    });

    tearDown(() {
      reset(kanjiServiceMock);
    });

    group("getAll", () {
      test("it should load all the kanji from the service", () {
        when(kanjiServiceMock.getAll()).thenReturn([dummyKanji]);

        expect(repository.getAll(), [dummyKanji]);
        verify(kanjiServiceMock.getAll());
        verifyNoMoreInteractions(kanjiServiceMock);
      });

      test("it should not call the service", () {
        repository.kanjis.add(dummyKanji);

        expect(repository.getAll(), [dummyKanji]);
        verifyZeroInteractions(kanjiServiceMock);
      });
    });
  });
}
