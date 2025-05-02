import "package:infinite_scroll_pagination/infinite_scroll_pagination.dart";
import "package:kana_to_kanji/src/core/models/paginated_data.dart";
import "package:kana_to_kanji/src/core/models/resources/resource.dart";
import "package:kana_to_kanji/src/core/repositories/resource_repository.dart";
import "package:kana_to_kanji/src/core/services/resources/resource_data_service.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:stacked/stacked.dart";

class PaginationHelper<
  T extends Resource,
  R extends ResourceRepository<T, ResourceDataService<T>>
>
    with ListenableServiceMixin {
  final R repository = locator<R>();

  PagingState<int, T> _pagingState = PagingState();

  PagingState<int, T> get pagingState => _pagingState;
  PaginatedData<T>? _nextPage;

  PaginationHelper();

  Future<void> fetchNextPage() async {
    _pagingState = _pagingState.copyWith(isLoading: true);

    _nextPage = await (_nextPage?.next!() ?? repository.get());

    _pagingState = _pagingState.copyWith(
      pages: [...?pagingState.pages, _nextPage!.data],
      keys: [...?pagingState.keys, (pagingState.keys?.length ?? 0) + 1],
      hasNextPage: _nextPage!.hasMore,
      isLoading: false,
    );
    notifyListeners();
  }
}
