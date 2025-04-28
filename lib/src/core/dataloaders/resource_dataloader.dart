import "dart:convert";

import "package:http/http.dart" as http;
import "package:kana_to_kanji/src/core/models/paginated_response.dart";
import "package:kana_to_kanji/src/core/models/resource.dart";
import "package:kana_to_kanji/src/core/services/api_service.dart";
import "package:kana_to_kanji/src/core/services/resource_data_service.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:logger/logger.dart";

const _kBatchSize = 1000;

class ResourceDataLoader<T extends Resource> {
  final Logger _logger = locator<Logger>();
  final ApiService _apiService = locator<ApiService>();
  final ResourceDataService<T> service;
  final T Function(Map<String, dynamic>) fromJson;
  final String apiResourceType;

  ResourceDataLoader({
    required this.service,
    required this.fromJson,
    required this.apiResourceType,
  });

  Future<String?> get latestVersion => service.latestVersion;

  /// Load all the resource from the API.
  /// If [forceReload] is true, the collection is cleared and populated again
  Future fetchAll({String? latestVersion, bool forceReload = false}) async {
    var versionQueryParam = "?page[size]=$_kBatchSize";

    if (!forceReload && latestVersion != null) {
      versionQueryParam += "&version[current]=$latestVersion";
    }

    String url = "/v1/$apiResourceType$versionQueryParam";
    final List<T> items = [];
    bool hasMore = true;

    while (hasMore) {
      _logger.d("ResourceDataLoader<$T>: fetchAll: $url");
      final response = await _apiService.get(url);
      final result = _extractPaginatedResponse(response);

      if (result != null) {
        items.addAll(result.data);
        hasMore = result.hasMore;

        // If there are more pages, update the URL to the next page
        if (hasMore) {
          url = result.links.next;
        }
      } else {
        hasMore = false;
      }
    }

    _logger.d(
      "ResourceDataLoader<$T>: fetchAll ended retrieved ${items.length} items.",
    );

    return service.upsertAll(items, forceReload: forceReload);
  }

  /// Extract the paginated response from the API Response.
  PaginatedResponse<T>? _extractPaginatedResponse(http.Response response) {
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return PaginatedResponse<T>.fromJson(
        jsonData,
        (json) => fromJson(json! as Map<String, dynamic>),
      );
    } else {
      // If the server did not return a 200 OK response,
      // then return null.
      return null;
    }
  }
}
