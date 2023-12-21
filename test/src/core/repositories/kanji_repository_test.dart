import 'package:flutter_test/flutter_test.dart';
import 'package:kana_to_kanji/src/core/models/kanji.dart';
import 'package:kana_to_kanji/src/core/repositories/kanji_repository.dart';
import 'package:kana_to_kanji/src/core/services/kanji_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<KanjiService>()])
import 'kanji_repository_test.mocks.dart';

void main() {
  group("KanjiRepository", () {
    const kanjiSample =
        Kanji(1, "本", 5, 1, 5, ["book"], [], ["ほん"], "2023-12-1", []);
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
        when(kanjiServiceMock.getAll()).thenReturn([kanjiSample]);

        expect(repository.getAll(), [kanjiSample]);
        verify(kanjiServiceMock.getAll());
        verifyNoMoreInteractions(kanjiServiceMock);
      });

      test("it should not call the service", () {
        repository.kanjis.add(kanjiSample);

        expect(repository.getAll(), [kanjiSample]);
        verifyZeroInteractions(kanjiServiceMock);
      });
    });
  });
}
