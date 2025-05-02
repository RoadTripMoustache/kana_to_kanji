import "package:flutter/foundation.dart";
import "package:kana_to_kanji/src/core/models/paginated_data.dart";
import "package:kana_to_kanji/src/core/models/resources/resource.dart";
import "package:kana_to_kanji/src/core/services/resources/resource_data_service.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:logger/logger.dart";
import "package:stacked/stacked.dart";

abstract class ResourceRepository<
  T extends Resource,
  S extends ResourceDataService<T>
>
    with ListenableServiceMixin {
  @protected
  final Logger logger = locator<Logger>();

  @protected
  final S service = locator<S>();

  @protected
  @visibleForTesting
  final ReactiveList<T> items = ReactiveList<T>();

  ResourceRepository() {
    service.addListener(onServiceUpdate);
    listenToReactiveValues([items]);
  }

  @visibleForOverriding
  void onServiceUpdate() {
    items.clear();
  }

  Future<PaginatedData<T>> get({
    Map<String, dynamic> filterBy = const {},
  }) async {
    final paginatedData = await service.getPage(0);

    items.addAll(paginatedData.data);

    return paginatedData.copyWith(
      next: paginatedData.hasMore ? () => nextPage(paginatedData.next!) : null,
    );
  }

  @protected
  Future<PaginatedData<T>> nextPage(
    Future<PaginatedData<T>> Function() next,
  ) async {
    final paginatedData = await next();

    for (final item in paginatedData.data) {
      if (!items.contains(item)) {
        items.add(item);
      }
    }

    return paginatedData.copyWith(
      next: paginatedData.hasMore ? () => nextPage(paginatedData.next!) : null,
    );
  }
}
