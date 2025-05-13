import "package:flutter/foundation.dart";
import "package:kana_to_kanji/src/core/models/paginated_data.dart";
import "package:kana_to_kanji/src/core/models/resources/resource.dart";
import "package:kana_to_kanji/src/core/models/resources/resource_uid.dart";
import "package:kana_to_kanji/src/core/services/resources/resource_data_service.dart";
import "package:kana_to_kanji/src/core/utils/sql/order_by.dart";
import "package:kana_to_kanji/src/core/utils/sql/where.dart";
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

  @protected
  void onServiceUpdate() {
    items.clear();
  }

  /// Retrieve single resource by using the given [uid].
  /// @throws [Exception] if the resource is not found.
  Future<T> get(ResourceUid uid) async {
    final item = items.where((item) => item.uid == uid).firstOrNull;

    if (item != null) {
      return item;
    }

    final result = await service.get(uid);

    items.add(result);

    return result;
  }

  /// Retrieve items from the database.
  /// - [where] is supposed to be a list of [Where] objects, but for overloading
  ///   reasons, it is typed as dynamic.
  /// - [orderBy] is supposed to be a list of [OrderBy] objects, but for
  ///   overloading reasons, it is typed as dynamic.
  Future<PaginatedData<T>> getMultiple({
    dynamic where = const [],
    dynamic orderBy,
  }) async {
    final paginatedData = await service.getPage(
      0,
      where: where as List<Where>,
      orderBy: orderBy as List<OrderBy>,
    );

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
