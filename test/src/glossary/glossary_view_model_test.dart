import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/src/core/constants/sort_order.dart";
import "package:kana_to_kanji/src/core/repositories/kana_repository.dart";
import "package:kana_to_kanji/src/core/repositories/kanji_repository.dart";
import "package:kana_to_kanji/src/core/repositories/vocabulary_repository.dart";
import "package:kana_to_kanji/src/core/services/dialog_service.dart";
import "package:kana_to_kanji/src/glossary/glossary_view_model.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

import "../../dummies/kana.dart";
import "../../dummies/kanji.dart";
import "../../dummies/vocabulary.dart";
@GenerateNiceMocks([
  MockSpec<GoRouter>(),
  MockSpec<TabController>(),
  MockSpec<DialogService>(),
  MockSpec<KanaRepository>(),
  MockSpec<KanjiRepository>(),
  MockSpec<VocabularyRepository>()
])
import "glossary_view_model_test.mocks.dart";

final TabController tabControllerMock = MockTabController();
final GoRouter goRouterMock = MockGoRouter();
final KanaRepository kanaRepositoryMock = MockKanaRepository();
final KanjiRepository kanjiRepositoryMock = MockKanjiRepository();
final VocabularyRepository vocabularyRepositoryMock =
    MockVocabularyRepository();
final DialogService dialogServiceMock = MockDialogService();

void main() {
  group("GlossaryViewModel", () {
    when(kanaRepositoryMock.getHiragana())
        .thenAnswer((_) => [dummyHiragana, dummyHiragana]);
    when(kanaRepositoryMock.searchHiragana("", []))
        .thenAnswer((_) => [dummyHiragana, dummyHiragana]);
    when(kanaRepositoryMock.searchHiragana("toto", []))
        .thenAnswer((_) => [dummyHiragana, dummyHiragana]);

    when(kanaRepositoryMock.getKatakana())
        .thenAnswer((_) => [dummyKatakana, dummyKatakana, dummyKatakana]);
    when(kanaRepositoryMock.searchKatakana("", []))
        .thenAnswer((_) => [dummyKatakana, dummyKatakana, dummyKatakana]);
    when(kanaRepositoryMock.searchKatakana("toto", []))
        .thenAnswer((_) => [dummyKatakana, dummyKatakana, dummyKatakana]);

    when(vocabularyRepositoryMock.searchVocabulary(
            "", [], [], SortOrder.japanese))
        .thenAnswer((_) => [dummyVocabulary]);
    when(vocabularyRepositoryMock.searchVocabulary(
            "toto", [], [], SortOrder.japanese))
        .thenAnswer((_) => [dummyVocabulary, dummyVocabulary, dummyVocabulary]);

    when(kanjiRepositoryMock.searchKanji("", [], [], SortOrder.japanese))
        .thenAnswer((_) => [dummyKanji, dummyKanji, dummyKanji, dummyKanji]);
    when(kanjiRepositoryMock.searchKanji("toto", [], [], SortOrder.japanese))
        .thenAnswer((_) => [dummyKanji]);

    setUpAll(() async {
      locator
        ..registerSingleton<DialogService>(dialogServiceMock)
        ..registerSingleton<KanaRepository>(kanaRepositoryMock)
        ..registerSingleton<KanjiRepository>(kanjiRepositoryMock)
        ..registerSingleton<VocabularyRepository>(vocabularyRepositoryMock);
    });

    testWidgets("New GlossaryViewModel open nothing",
        (WidgetTester tester) async {
      when(tabControllerMock.index).thenAnswer((_) => 0);

      final GlossaryViewModel gvm =
          GlossaryViewModel(goRouterMock, tabControllerMock);

      checkLists(gvm, 0, 0, 0, 0);
      verifyNever(kanaRepositoryMock.getHiragana());
      verifyNever(kanaRepositoryMock.searchHiragana("", []));
      verifyNever(kanaRepositoryMock.searchHiragana("toto", []));
      verifyNever(kanaRepositoryMock.getKatakana());
      verifyNever(kanaRepositoryMock.searchKatakana("", []));
      verifyNever(kanaRepositoryMock.searchKatakana("toto", []));
      verifyNever(
          kanjiRepositoryMock.searchKanji("", [], [], SortOrder.japanese));
      verifyNever(
          kanjiRepositoryMock.searchKanji("toto", [], [], SortOrder.japanese));
      verifyNever(vocabularyRepositoryMock.searchVocabulary(
          "", [], [], SortOrder.japanese));
      verifyNever(vocabularyRepositoryMock.searchVocabulary(
          "toto", [], [], SortOrder.japanese));
    });

    testWidgets("New GlossaryViewModel open on the Hiragana tab",
        (WidgetTester tester) async {
      when(tabControllerMock.index).thenAnswer((_) => 0);

      final GlossaryViewModel gvm =
          GlossaryViewModel(goRouterMock, tabControllerMock);
      await gvm.futureToRun();

      checkLists(gvm, 2, 0, 0, 0);
      verify(kanaRepositoryMock.getHiragana()).called(1);
      verify(kanaRepositoryMock.searchHiragana("", [])).called(1);
      verifyNever(kanaRepositoryMock.searchHiragana("toto", []));
      verifyNever(kanaRepositoryMock.getKatakana());
      verifyNever(kanaRepositoryMock.searchKatakana("", []));
      verifyNever(kanaRepositoryMock.searchKatakana("toto", []));
      verifyNever(
          kanjiRepositoryMock.searchKanji("", [], [], SortOrder.japanese));
      verifyNever(
          kanjiRepositoryMock.searchKanji("toto", [], [], SortOrder.japanese));
      verifyNever(vocabularyRepositoryMock.searchVocabulary(
          "", [], [], SortOrder.japanese));
      verifyNever(vocabularyRepositoryMock.searchVocabulary(
          "toto", [], [], SortOrder.japanese));
    });

    testWidgets("New GlossaryViewModel open on the Katakana tab",
        (WidgetTester tester) async {
      when(tabControllerMock.index).thenAnswer((_) => 1);

      final GlossaryViewModel gvm =
          GlossaryViewModel(goRouterMock, tabControllerMock);
      await gvm.futureToRun();

      checkLists(gvm, 0, 3, 0, 0);
      verifyNever(kanaRepositoryMock.getHiragana());
      verifyNever(kanaRepositoryMock.searchHiragana("", []));
      verifyNever(kanaRepositoryMock.searchHiragana("toto", []));
      verify(kanaRepositoryMock.getKatakana()).called(1);
      verify(kanaRepositoryMock.searchKatakana("", [])).called(1);
      verifyNever(kanaRepositoryMock.searchKatakana("toto", []));
      verifyNever(
          kanjiRepositoryMock.searchKanji("", [], [], SortOrder.japanese));
      verifyNever(
          kanjiRepositoryMock.searchKanji("toto", [], [], SortOrder.japanese));
      verifyNever(vocabularyRepositoryMock.searchVocabulary(
          "", [], [], SortOrder.japanese));
      verifyNever(vocabularyRepositoryMock.searchVocabulary(
          "toto", [], [], SortOrder.japanese));
    });

    testWidgets("New GlossaryViewModel open on the Kanji tab",
        (WidgetTester tester) async {
      when(tabControllerMock.index).thenAnswer((_) => 2);

      final GlossaryViewModel gvm =
          GlossaryViewModel(goRouterMock, tabControllerMock);
      await gvm.futureToRun();

      checkLists(gvm, 0, 0, 4, 0);
      verifyNever(kanaRepositoryMock.getHiragana());
      verifyNever(kanaRepositoryMock.searchHiragana("", []));
      verifyNever(kanaRepositoryMock.searchHiragana("toto", []));
      verifyNever(kanaRepositoryMock.getKatakana());
      verifyNever(kanaRepositoryMock.searchKatakana("", []));
      verifyNever(kanaRepositoryMock.searchKatakana("toto", []));
      verify(kanjiRepositoryMock.searchKanji("", [], [], SortOrder.japanese))
          .called(1);
      verifyNever(
          kanjiRepositoryMock.searchKanji("toto", [], [], SortOrder.japanese));
      verifyNever(vocabularyRepositoryMock.searchVocabulary(
          "", [], [], SortOrder.japanese));
      verifyNever(vocabularyRepositoryMock.searchVocabulary(
          "toto", [], [], SortOrder.japanese));
    });

    testWidgets("New GlossaryViewModel open on the Vocabulary tab",
        (WidgetTester tester) async {
      when(tabControllerMock.index).thenAnswer((_) => 3);

      final GlossaryViewModel gvm =
          GlossaryViewModel(goRouterMock, tabControllerMock);
      await gvm.futureToRun();

      checkLists(gvm, 0, 0, 0, 1);
      verifyNever(kanaRepositoryMock.getHiragana());
      verifyNever(kanaRepositoryMock.searchHiragana("", []));
      verifyNever(kanaRepositoryMock.searchHiragana("toto", []));
      verifyNever(kanaRepositoryMock.getKatakana());
      verifyNever(kanaRepositoryMock.searchKatakana("", []));
      verifyNever(kanaRepositoryMock.searchKatakana("toto", []));
      verifyNever(
          kanjiRepositoryMock.searchKanji("", [], [], SortOrder.japanese));
      verifyNever(
          kanjiRepositoryMock.searchKanji("toto", [], [], SortOrder.japanese));
      verify(vocabularyRepositoryMock.searchVocabulary(
              "", [], [], SortOrder.japanese))
          .called(1);
      verifyNever(vocabularyRepositoryMock.searchVocabulary(
          "toto", [], [], SortOrder.japanese));
    });

    testWidgets("Search on the Hiragana tab", (WidgetTester tester) async {
      when(tabControllerMock.index).thenAnswer((_) => 0);

      final GlossaryViewModel gvm =
          GlossaryViewModel(goRouterMock, tabControllerMock)
            ..searchGlossary("toto");

      checkLists(gvm, 2, 0, 0, 0);
      verify(kanaRepositoryMock.getHiragana()).called(1);
      verifyNever(kanaRepositoryMock.searchHiragana("", []));
      verify(kanaRepositoryMock.searchHiragana("toto", [])).called(1);
      verifyNever(kanaRepositoryMock.getKatakana());
      verifyNever(kanaRepositoryMock.searchKatakana("", []));
      verifyNever(kanaRepositoryMock.searchKatakana("toto", []));
      verifyNever(
          kanjiRepositoryMock.searchKanji("", [], [], SortOrder.japanese));
      verifyNever(
          kanjiRepositoryMock.searchKanji("toto", [], [], SortOrder.japanese));
      verifyNever(vocabularyRepositoryMock.searchVocabulary(
          "", [], [], SortOrder.japanese));
      verifyNever(vocabularyRepositoryMock.searchVocabulary(
          "toto", [], [], SortOrder.japanese));
    });

    testWidgets("Search on the Katakana tab", (WidgetTester tester) async {
      when(tabControllerMock.index).thenAnswer((_) => 1);

      final GlossaryViewModel gvm =
          GlossaryViewModel(goRouterMock, tabControllerMock)
            ..searchGlossary("toto");

      checkLists(gvm, 0, 3, 0, 0);
      verifyNever(kanaRepositoryMock.getHiragana());
      verifyNever(kanaRepositoryMock.searchHiragana("", []));
      verifyNever(kanaRepositoryMock.searchHiragana("toto", []));
      verify(kanaRepositoryMock.getKatakana()).called(1);
      verifyNever(kanaRepositoryMock.searchKatakana("", []));
      verify(kanaRepositoryMock.searchKatakana("toto", [])).called(1);
      verifyNever(
          kanjiRepositoryMock.searchKanji("", [], [], SortOrder.japanese));
      verifyNever(
          kanjiRepositoryMock.searchKanji("toto", [], [], SortOrder.japanese));
      verifyNever(vocabularyRepositoryMock.searchVocabulary(
          "", [], [], SortOrder.japanese));
      verifyNever(vocabularyRepositoryMock.searchVocabulary(
          "toto", [], [], SortOrder.japanese));
    });

    testWidgets("Search on the Vocabulary tab", (WidgetTester tester) async {
      when(tabControllerMock.index).thenAnswer((_) => 3);

      final GlossaryViewModel gvm =
          GlossaryViewModel(goRouterMock, tabControllerMock)
            ..searchGlossary("toto");

      checkLists(gvm, 0, 0, 0, 3);
      verifyNever(kanaRepositoryMock.getHiragana());
      verifyNever(kanaRepositoryMock.searchHiragana("", []));
      verifyNever(kanaRepositoryMock.searchHiragana("toto", []));
      verifyNever(kanaRepositoryMock.getKatakana());
      verifyNever(kanaRepositoryMock.searchKatakana("", []));
      verifyNever(kanaRepositoryMock.searchKatakana("toto", []));
      verifyNever(
          kanjiRepositoryMock.searchKanji("", [], [], SortOrder.japanese));
      verifyNever(
          kanjiRepositoryMock.searchKanji("toto", [], [], SortOrder.japanese));
      verifyNever(vocabularyRepositoryMock.searchVocabulary(
          "", [], [], SortOrder.japanese));
      verify(vocabularyRepositoryMock.searchVocabulary(
              "toto", [], [], SortOrder.japanese))
          .called(1);
    });

    testWidgets("Search on the Kanji tab", (WidgetTester tester) async {
      when(tabControllerMock.index).thenAnswer((_) => 2);

      final GlossaryViewModel gvm =
          GlossaryViewModel(goRouterMock, tabControllerMock)
            ..searchGlossary("toto");

      checkLists(gvm, 0, 0, 1, 0);
      verifyNever(kanaRepositoryMock.getHiragana());
      verifyNever(kanaRepositoryMock.searchHiragana("", []));
      verifyNever(kanaRepositoryMock.searchHiragana("toto", []));
      verifyNever(kanaRepositoryMock.getKatakana());
      verifyNever(kanaRepositoryMock.searchKatakana("", []));
      verifyNever(kanaRepositoryMock.searchKatakana("toto", []));
      verifyNever(
          kanjiRepositoryMock.searchKanji("", [], [], SortOrder.japanese));
      verify(kanjiRepositoryMock.searchKanji(
              "toto", [], [], SortOrder.japanese))
          .called(1);
      verifyNever(vocabularyRepositoryMock.searchVocabulary(
          "", [], [], SortOrder.japanese));
      verifyNever(vocabularyRepositoryMock.searchVocabulary(
          "toto", [], [], SortOrder.japanese));
    });

    testWidgets("Switch between tabs", (WidgetTester tester) async {
      final indexes = [0, 3, 1, 2];
      when(tabControllerMock.index).thenAnswer((_) => indexes.removeAt(0));

      final GlossaryViewModel gvm =
          GlossaryViewModel(goRouterMock, tabControllerMock);

      checkLists(gvm, 0, 0, 0, 0);

      await gvm.futureToRun();

      checkLists(gvm, 2, 0, 0, 0);

      await gvm.futureToRun();

      checkLists(gvm, 2, 0, 0, 1);

      await gvm.futureToRun();

      checkLists(gvm, 2, 3, 0, 1);

      await gvm.futureToRun();

      checkLists(gvm, 2, 3, 4, 1);
    });
  });
}

void checkLists(GlossaryViewModel gvm, int hiraganaListLength,
    int katakanaListLength, int kanjiListLength, int vocabularyListLength) {
  expect(gvm.hiraganaList.length, hiraganaListLength);
  expect(gvm.katakanaList.length, katakanaListLength);
  expect(gvm.kanjiList.length, kanjiListLength);
  expect(gvm.vocabularyList.length, vocabularyListLength);
}
