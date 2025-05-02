import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/repositories/vocabulary_repository.dart";
import "package:kana_to_kanji/src/core/services/resources/vocabulary_service.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:logger/logger.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

import "../../../dummies/vocabulary.dart";
import "../../../helpers.dart";

@GenerateNiceMocks([MockSpec<VocabularyService>(), MockSpec<Logger>()])
import "vocabulary_repository_test.mocks.dart";

void main() {
  group("VocabularyRepository", () {
    late VocabularyRepository repository;
    final MockVocabularyService vocabularyServiceMock = MockVocabularyService();

    setUpAll(() {
      locator
        ..registerSingleton<Logger>(MockLogger())
        ..registerSingleton<VocabularyService>(vocabularyServiceMock);
    });

    setUp(() {
      repository = VocabularyRepository();
    });

    tearDown(() {
      reset(vocabularyServiceMock);
    });

    tearDownAll(() async {
      await unregister<Logger>();
      await unregister<VocabularyService>();
    });

    test("should properly handle service updates", () {
      // Verify initial setup with ListenableServiceMixin
      final void Function() listener =
          verify(vocabularyServiceMock.addListener(captureAny)).captured.first;

      // Test notification propagation
      repository.items.add(dummyVocabulary);
      listener();
      expect(repository.items, isEmpty);
    });

    group("getAll", () {
      test("it should load all vocabulary from the service", () async {
        when(
          vocabularyServiceMock.getAll(),
        ).thenAnswer((_) => Future.value([dummyVocabulary]));

        expect(await repository.getAll(), [dummyVocabulary]);
        verify(vocabularyServiceMock.getAll());
      });

      test(
        "it should not call the service if items are already loaded",
        () async {
          repository.items.add(dummyVocabulary);

          expect(await repository.getAll(), [dummyVocabulary]);
          verify(vocabularyServiceMock.addListener(any)).called(1);
          verifyNoMoreInteractions(vocabularyServiceMock);
        },
      );
    });

    // Search tests are skipped as requested
  });
}
