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
  MockSpec<VocabularyRepository>(),
])
import "glossary_view_model_test.mocks.dart";

void main() {
  final dummiesKatakana = [dummyKatakana, dummyKatakana, dummyKatakana];
  final dummiesHiragana = [dummyHiragana, dummyHiragana];

  final TabController tabControllerMock = MockTabController();
  final GoRouter goRouterMock = MockGoRouter();
  final MockKanaRepository kanaRepositoryMock = MockKanaRepository();
  final MockKanjiRepository kanjiRepositoryMock = MockKanjiRepository();
  final MockVocabularyRepository vocabularyRepositoryMock =
      MockVocabularyRepository();
  final DialogService dialogServiceMock = MockDialogService();

  late GlossaryViewModel viewModel;

  group("GlossaryViewModel", () {
    setUpAll(() async {
      locator
        ..registerSingleton<DialogService>(dialogServiceMock)
        ..registerSingleton<KanaRepository>(kanaRepositoryMock)
        ..registerSingleton<KanjiRepository>(kanjiRepositoryMock)
        ..registerSingleton<VocabularyRepository>(vocabularyRepositoryMock);
    });

    setUp(() async {
      viewModel = GlossaryViewModel(goRouterMock, tabControllerMock);
    });

    tearDown(() {
      reset(dialogServiceMock);
      reset(kanaRepositoryMock);
      reset(kanjiRepositoryMock);
      reset(vocabularyRepositoryMock);
    });

    group("Hiragana", () {
      setUp(() async {
        when(tabControllerMock.index).thenAnswer((_) => 0);
        when(
          kanaRepositoryMock.getHiragana(),
        ).thenAnswer((_) => Future.value(dummiesHiragana));
        when(
          kanaRepositoryMock.searchHiragana(any, []),
        ).thenAnswer((_) => Future.value(dummiesHiragana));
      });

      testWidgets("open on the tab", (WidgetTester tester) async {
        await viewModel.futureToRun();

        checkLists(viewModel, dummiesHiragana.length, 0, 0, 0);
        verifyInOrder([
          kanaRepositoryMock.getHiragana(),
          kanaRepositoryMock.searchHiragana("", []),
        ]);
        verifyZeroInteractions(kanjiRepositoryMock);
        verifyZeroInteractions(vocabularyRepositoryMock);
      });

      testWidgets("search", (WidgetTester tester) async {
        viewModel.searchGlossary("toto");

        await untilCalled(kanaRepositoryMock.searchHiragana("toto", []));

        checkLists(viewModel, dummiesHiragana.length, 0, 0, 0);
        verifyInOrder([
          kanaRepositoryMock.getHiragana(),
          kanaRepositoryMock.searchHiragana("toto", []),
        ]);
        verifyNoMoreInteractions(kanaRepositoryMock);
        verifyZeroInteractions(kanjiRepositoryMock);
        verifyZeroInteractions(vocabularyRepositoryMock);
      });
    });

    group("Katakana", () {
      setUp(() async {
        when(tabControllerMock.index).thenAnswer((_) => 1);
        when(
          kanaRepositoryMock.getKatakana(),
        ).thenAnswer((_) => Future.value(dummiesKatakana));
        when(
          kanaRepositoryMock.searchKatakana(any, []),
        ).thenAnswer((_) => Future.value(dummiesKatakana));
      });

      testWidgets("open on the tab", (WidgetTester tester) async {
        await viewModel.futureToRun();

        checkLists(viewModel, 0, dummiesKatakana.length, 0, 0);
        verifyInOrder([
          kanaRepositoryMock.getKatakana(),
          kanaRepositoryMock.searchKatakana("", []),
        ]);
        verifyNoMoreInteractions(kanaRepositoryMock);
        verifyZeroInteractions(kanjiRepositoryMock);
        verifyZeroInteractions(vocabularyRepositoryMock);
      });

      testWidgets("search", (WidgetTester tester) async {
        viewModel.searchGlossary("toto");

        await untilCalled(kanaRepositoryMock.searchKatakana("toto", []));

        checkLists(viewModel, 0, dummiesKatakana.length, 0, 0);
        verifyInOrder([
          kanaRepositoryMock.getKatakana(),
          kanaRepositoryMock.searchKatakana("toto", []),
        ]);
        verifyNoMoreInteractions(kanaRepositoryMock);
        verifyZeroInteractions(kanjiRepositoryMock);
        verifyZeroInteractions(vocabularyRepositoryMock);
      });
    });

    group("Kanji", () {
      setUp(() async {
        when(tabControllerMock.index).thenAnswer((_) => 2);
        when(
          kanjiRepositoryMock.searchKanji(any, [], [], SortOrder.japanese),
        ).thenAnswer((_) => Future.value(dummiesKanji));
      });

      testWidgets("open on the tab", (WidgetTester tester) async {
        await viewModel.futureToRun();

        checkLists(viewModel, 0, 0, dummiesKanji.length, 0);
        verify(
          kanjiRepositoryMock.searchKanji("", [], [], SortOrder.japanese),
        ).called(1);
        verifyZeroInteractions(kanaRepositoryMock);
        verifyNoMoreInteractions(kanjiRepositoryMock);
        verifyZeroInteractions(vocabularyRepositoryMock);
      });

      testWidgets("search", (WidgetTester tester) async {
        viewModel.searchGlossary("toto");

        await untilCalled(
          kanjiRepositoryMock.searchKanji("toto", [], [], SortOrder.japanese),
        );

        checkLists(viewModel, 0, 0, dummiesKanji.length, 0);
        verify(
          kanjiRepositoryMock.searchKanji("toto", [], [], SortOrder.japanese),
        ).called(1);
        verifyZeroInteractions(kanaRepositoryMock);
        verifyNoMoreInteractions(kanjiRepositoryMock);
        verifyZeroInteractions(vocabularyRepositoryMock);
      });
    });

    group("Vocabulary", () {
      setUp(() async {
        when(tabControllerMock.index).thenAnswer((_) => 3);
        when(
          vocabularyRepositoryMock.searchVocabulary(
            any,
            [],
            [],
            SortOrder.japanese,
          ),
        ).thenAnswer((_) => Future.value(dummiesVocabulary));
      });

      testWidgets("open the tab", (WidgetTester tester) async {
        await viewModel.futureToRun();

        checkLists(viewModel, 0, 0, 0, dummiesVocabulary.length);
        verify(
          vocabularyRepositoryMock.searchVocabulary(
            "",
            [],
            [],
            SortOrder.japanese,
          ),
        ).called(1);
        verifyZeroInteractions(kanaRepositoryMock);
        verifyZeroInteractions(kanjiRepositoryMock);
        verifyNoMoreInteractions(vocabularyRepositoryMock);
      });

      testWidgets("search", (WidgetTester tester) async {
        viewModel.searchGlossary("toto");

        await untilCalled(
          vocabularyRepositoryMock.searchVocabulary(
            "toto",
            [],
            [],
            SortOrder.japanese,
          ),
        );

        checkLists(viewModel, 0, 0, 0, dummiesVocabulary.length);
        verify(
          vocabularyRepositoryMock.searchVocabulary(
            "toto",
            [],
            [],
            SortOrder.japanese,
          ),
        ).called(1);
        verifyZeroInteractions(kanaRepositoryMock);
        verifyZeroInteractions(kanjiRepositoryMock);
        verifyNoMoreInteractions(vocabularyRepositoryMock);
      });
    });

    testWidgets("New GlossaryViewModel open nothing", (
      WidgetTester tester,
    ) async {
      when(tabControllerMock.index).thenAnswer((_) => 0);

      checkLists(viewModel, 0, 0, 0, 0);
      verifyZeroInteractions(kanaRepositoryMock);
      verifyZeroInteractions(kanjiRepositoryMock);
      verifyZeroInteractions(vocabularyRepositoryMock);
    });

    testWidgets("Switch between tabs", (WidgetTester tester) async {
      final indexes = [0, 3, 1, 2];
      when(tabControllerMock.index).thenAnswer((_) => indexes.removeAt(0));

      when(
        kanaRepositoryMock.getHiragana(),
      ).thenAnswer((_) => Future.value(dummiesHiragana));
      when(
        kanaRepositoryMock.getKatakana(),
      ).thenAnswer((_) => Future.value(dummiesKatakana));
      when(
        kanjiRepositoryMock.searchKanji(any, [], [], SortOrder.japanese),
      ).thenAnswer((_) => Future.value(dummiesKanji));
      when(
        vocabularyRepositoryMock.searchVocabulary(
          any,
          [],
          [],
          SortOrder.japanese,
        ),
      ).thenAnswer((_) => Future.value(dummiesVocabulary));

      final GlossaryViewModel viewModel = GlossaryViewModel(
        goRouterMock,
        tabControllerMock,
      );

      checkLists(viewModel, 0, 0, 0, 0);

      await viewModel.futureToRun();

      checkLists(viewModel, dummiesHiragana.length, 0, 0, 0);

      await viewModel.futureToRun();

      checkLists(
        viewModel,
        dummiesHiragana.length,
        0,
        0,
        dummiesVocabulary.length,
      );

      await viewModel.futureToRun();

      checkLists(
        viewModel,
        dummiesHiragana.length,
        dummiesKatakana.length,
        0,
        dummiesVocabulary.length,
      );

      await viewModel.futureToRun();

      checkLists(
        viewModel,
        2,
        3,
        dummiesKanji.length,
        dummiesVocabulary.length,
      );
    });
  });
}

void checkLists(
  GlossaryViewModel viewModel,
  int hiraganaListLength,
  int katakanaListLength,
  int kanjiListLength,
  int vocabularyListLength,
) {
  expect(viewModel.hiraganaList.length, hiraganaListLength);
  expect(viewModel.katakanaList.length, katakanaListLength);
  expect(viewModel.kanjiList.length, kanjiListLength);
  expect(viewModel.vocabularyList.length, vocabularyListLength);
}
