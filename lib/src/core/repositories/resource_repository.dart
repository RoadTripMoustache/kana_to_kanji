import "package:flutter/foundation.dart";
import "package:kana_to_kanji/src/core/models/resources/resource.dart";
import "package:kana_to_kanji/src/core/services/resources/resource_data_service.dart";
import "package:stacked/stacked.dart";

abstract class ResourceRepository<
  T extends Resource,
  S extends ResourceDataService<T>
>
    with ListenableServiceMixin {
  @protected
  final S service;

  @protected
  @visibleForTesting
  final List<T> items = [];

  ResourceRepository({required this.service}) {
    service.addListener(_onServiceUpdate);
    listenToReactiveValues([items]);
  }

  void _onServiceUpdate() {
    items.clear();
    notifyListeners();
  }
}
