import "package:flutter/foundation.dart";
import "package:kana_to_kanji/src/core/models/resource.dart";
import "package:kana_to_kanji/src/core/services/resource_data_service.dart";
import "package:stacked/stacked.dart";

abstract class ResourceRepository<
  T extends Resource,
  S extends ResourceDataService<T>
>
    with ListenableServiceMixin {
  @protected
  final S service;

  @protected
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
