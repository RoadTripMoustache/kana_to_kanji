import "dart:convert";

import "package:http/http.dart" as http;
import "package:kana_to_kanji/src/core/models/resource.dart";
import "package:kana_to_kanji/src/core/services/api_service.dart";
import "package:kana_to_kanji/src/core/services/resource_data_service.dart";
import "package:kana_to_kanji/src/locator.dart";

class ResourceDataLoader<T extends Resource> {
  final ApiService _apiService = locator<ApiService>();
  final ResourceDataService<T> service;
  final T Function(Map<String, dynamic>) fromJson;
  final String apiResourceType;

  ResourceDataLoader({
    required this.service,
    required this.fromJson,
    required this.apiResourceType,
  });

  /// Load all the resource from the API.
  /// If [forceReload] is true, the collection is cleared and populated again
  Future loadCollection({
    String? latestVersion,
    bool forceReload = false,
  }) async {
    var versionQueryParam = "";

    if (!forceReload && latestVersion != null) {
      versionQueryParam = "?version[current]=$latestVersion";
    }

    return _apiService
        .get("/v1/$apiResourceType$versionQueryParam")
        .then(extractItems)
        .then((items) => service.upsertAll(items, forceReload: forceReload));
  }

  /// Extract all the item from the API Response.
  List<T> extractItems(http.Response response) {
    if (response.statusCode == 200) {
      final List<T> items = [];
      final rawItems = jsonDecode(response.body);
      for (final g in rawItems) {
        items.add(fromJson(g));
      }
      return items;
    } else {
      // If the server did not return a 200 OK response,
      // then return an empty list.
      return List.empty();
    }
  }
}
