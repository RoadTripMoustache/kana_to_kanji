import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/repositories/vocabulary_repository.dart";
import "package:kana_to_kanji/src/core/services/vocabulary_service.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

import "../../../dummies/vocabulary.dart";
@GenerateNiceMocks([MockSpec<VocabularyService>()])
import "vocabulary_repository_test.mocks.dart";

void main() {
  group("VocabularyRepository", () {
    late VocabularyRepository repository;

    final vocabularyServiceMock = MockVocabularyService();

    setUp(() {
      repository = VocabularyRepository(
        vocabularyService: vocabularyServiceMock,
      );
    });

    tearDown(() {
      reset(vocabularyServiceMock);
    });

    group("getAll", () {
      test("it should load all the kanji from the service", () {
        when(vocabularyServiceMock.getAll()).thenReturn([dummyVocabulary]);

        expect(repository.getAll(), [dummyVocabulary]);
        verify(vocabularyServiceMock.getAll());
        verifyNoMoreInteractions(vocabularyServiceMock);
      });

      test("it should not call the service", () {
        repository.vocabularies.add(dummyVocabulary);

        expect(repository.getAll(), [dummyVocabulary]);
        verifyZeroInteractions(vocabularyServiceMock);
      });
    });
  });
}
