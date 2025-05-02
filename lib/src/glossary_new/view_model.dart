import "dart:async";

import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:infinite_scroll_pagination/infinite_scroll_pagination.dart";
import "package:kana_to_kanji/src/core/constants/alphabets.dart";
import "package:kana_to_kanji/src/core/constants/kana_type.dart";
import "package:kana_to_kanji/src/core/models/paginated_data.dart";
import "package:kana_to_kanji/src/core/models/resources/resources.dart";
import "package:kana_to_kanji/src/core/repositories/kana_repository.dart";
import "package:kana_to_kanji/src/core/repositories/kanji_repository.dart";
import "package:kana_to_kanji/src/core/repositories/vocabulary_repository.dart";
import "package:kana_to_kanji/src/core/services/dialog_service.dart";
import "package:kana_to_kanji/src/glossary/details/details_view.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:stacked/stacked.dart";

typedef KanaDisabled = ({Kana kana, bool disabled});
typedef KanaMap = Map<KanaTypes, List<KanaDisabled>>;

const String hiraganaStream = "hiragana";
const String katakanaStream = "katakana";

class GlossaryViewModel extends MultipleStreamViewModel {
  final GoRouter router;
  final TabController tabController;

  final Map<String, StreamController> _controllers = {
    hiraganaStream: StreamController<KanaMap>(),
    katakanaStream: StreamController<KanaMap>(),
  };

  final DialogService _dialogService = locator<DialogService>();
  final KanaRepository _kanaRepository = locator<KanaRepository>();
  final KanjiRepository _kanjiRepository = locator<KanjiRepository>();
  final VocabularyRepository _vocabularyRepository =
      locator<VocabularyRepository>();

  KanaMap get hiragana => dataMap?[hiraganaStream] ?? {};
  bool get isHiraganaReady => dataReady(hiraganaStream);

  KanaMap get katakana => dataMap?[katakanaStream] ?? {};
  bool get isKatakanaReady => dataReady(katakanaStream);

  PagingState<int, Kanji> _kanji = PagingState();
  PagingState<int, Kanji> get kanji => _kanji;
  FetchNextPageCallback<Kanji>? _nextKanjiPage;

  PagingState<int, Vocabulary> _vocabulary = PagingState();
  PagingState<int, Vocabulary> get vocabulary => _vocabulary;
  FetchNextPageCallback<Vocabulary>? _nextVocabularyPage;

  GlossaryViewModel(this.router, this.tabController) {
    _kanaRepository.addListener(_onKanaUpdate);
    unawaited(_onKanaUpdate());
  }

  @override
  Map<String, StreamData> get streamsMap => {
    hiraganaStream: StreamData<KanaMap>(
      _controllers[hiraganaStream]!.stream as Stream<KanaMap>,
    ),
    katakanaStream: StreamData<KanaMap>(
      _controllers[katakanaStream]!.stream as Stream<KanaMap>,
    ),
  };

  Future<void> _onKanaUpdate() async {
    _controllers[hiraganaStream]!.add(await _processKana(Alphabets.hiragana));
    _controllers[katakanaStream]!.add(await _processKana(Alphabets.katakana));
  }

  Future<KanaMap> _processKana(Alphabets alphabet) => _kanaRepository
      .getSorted(alphabet)
      .then(
        (result) => result.map(
          (key, value) => MapEntry(
            key,
            value.map((kana) => (kana: kana, disabled: false)).toList(),
          ),
        ),
      );

  Future<void> kanjiNextPage() => _fetchNextPage<Kanji>(
    _kanji,
    (state) {
      _kanji = state;
      setBusyForObject(_kanji, false);
    },
    _nextKanjiPage ?? _kanjiRepository.get,
    (page) => _nextKanjiPage = page.next,
  );

  Future<void> vocabularyNextPage() => _fetchNextPage<Vocabulary>(
    _vocabulary,
    (state) {
      _vocabulary = state;
      setBusyForObject(_vocabulary, false);
    },
    _nextVocabularyPage ?? _vocabularyRepository.get,
    (page) => _nextVocabularyPage = page.next,
  );

  Future<void> _fetchNextPage<T>(
    PagingState<int, T> state,
    Function(PagingState<int, T>) setState,
    FetchNextPageCallback<T> fetchNextPage,
    Function(PaginatedData<T>) setNextPage,
  ) async {
    PagingState<int, T> pagingState = state.copyWith(isLoading: true);
    setState(pagingState);

    final nextPage = await fetchNextPage();
    setNextPage(nextPage);
    pagingState = pagingState.copyWith(
      pages: [...?pagingState.pages, nextPage.data],
      keys: [...?pagingState.keys, (pagingState.keys?.length ?? 0) + 1],
      hasNextPage: nextPage.hasMore,
      isLoading: false,
    );
    setState(pagingState);
  }

  /// Displays a modal with the informations of the selected item.
  Future<void> onTilePressed(dynamic item) async {
    await _dialogService.showModalBottomSheet(
      useSafeArea: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => DetailsView(item: item),
    );
  }

  @override
  Future<void> dispose() async {
    await Future.wait(
      _controllers.values.map((controller) => controller.close()),
    );
    super.dispose();
  }
}
