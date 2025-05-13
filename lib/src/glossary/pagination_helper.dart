import "dart:async";

import "package:infinite_scroll_pagination/infinite_scroll_pagination.dart";
import "package:kana_to_kanji/src/core/constants/jlpt_levels.dart";
import "package:kana_to_kanji/src/core/constants/sort_order.dart";
import "package:kana_to_kanji/src/core/models/paginated_data.dart";
import "package:kana_to_kanji/src/core/models/resources/resource.dart";
import "package:kana_to_kanji/src/core/repositories/resource_repository.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:stacked/stacked.dart";

class PaginationHelper<
  T extends Resource,
  R extends ResourceRepository<T, void>
>
    with ListenableServiceMixin {
  final R repository = locator<R>();

  PagingState<int, T> _pagingState = PagingState();
  PagingState<int, T> get pagingState => _pagingState;

  PaginatedData<T>? _nextPage;

  bool get hasData => _nextPage?.data.isNotEmpty ?? false;

  // Search and filters
  String _search = "";
  final List<JLPTLevel> _jlptFilter = [];
  SortOrder _sortOrder;

  PaginationHelper({
    String search = "",
    SortOrder? sortOrder = SortOrder.alphabetical,
    List<JLPTLevel> jlptFilter = const [],
  }) : _search = search,
       _sortOrder = sortOrder ?? SortOrder.alphabetical {
    _jlptFilter.addAll(jlptFilter);
  }

  void update(String search, List<JLPTLevel> jlptFilter, SortOrder sortOrder) {
    _search = search;
    _sortOrder = sortOrder;
    _jlptFilter
      ..clear()
      ..addAll(jlptFilter);
    _pagingState = _pagingState.reset();
    _nextPage = null;
    unawaited(fetchNextPage());
    notifyListeners();
  }

  Future<void> fetchNextPage() async {
    _pagingState = _pagingState.copyWith(isLoading: true);
    notifyListeners();

    _nextPage =
        await (_nextPage?.next!() ??
            repository.getMultiple(
              where: {JLPTLevel: _jlptFilter, String: _search},
              orderBy: _sortOrder,
            ));

    _pagingState = _pagingState.copyWith(
      pages: [...?pagingState.pages, _nextPage!.data],
      keys: [...?pagingState.keys, (pagingState.keys?.length ?? 0) + 1],
      hasNextPage: _nextPage!.hasMore,
      isLoading: false,
    );
    notifyListeners();
  }
}
