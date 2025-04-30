import "dart:convert";

import "package:http/http.dart" as http;
import "package:kana_to_kanji/src/core/models/paginated_response.dart";
import "package:kana_to_kanji/src/core/models/resources/resource.dart";
import "package:kana_to_kanji/src/core/models/resources/resource_uid.dart";
import "package:kana_to_kanji/src/core/services/api_service.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:logger/logger.dart";

const _kBatchSize = 1000;

class ResourceDataLoader<T extends Resource> {
  final Logger _logger = locator<Logger>();
  final ApiService _apiService = locator<ApiService>();
  final T Function(Map<String, dynamic>) fromJson;
  final String apiResourceType;

  ResourceDataLoader({required this.fromJson, required this.apiResourceType});

  /// Load all the resource from the API.
  /// Returns a [PaginatedList] with a cursor to the next page, each page
  /// contains a thousand (1000) items maximum
  Future<PaginatedList<T>> fetchAll({String? latestVersion}) async {
    var versionQueryParam = "?page[size]=$_kBatchSize";

    if (latestVersion != null) {
      versionQueryParam += "&version[current]=$latestVersion";
    }

    return _fetchPaginated("/v1/$apiResourceType$versionQueryParam");
  }

  Future<PaginatedList<T>> _fetchPaginated(String url) async {
    _logger.d("ResourceDataLoader<$T>: fetching: $url");
    final response = await _apiService.get(url).then(_extractPaginatedResponse);

    if (response != null) {
      return PaginatedList<T>(
        hasMore: response.hasMore,
        data: response.data,
        next: () => _fetchPaginated(response.links.next),
      );
    }

    return PaginatedList<T>(hasMore: false, data: []);
  }

  /// Fetch a specific kanji in full details
  Future<T> fetch(ResourceUid uid) async {
    throw UnimplementedError();
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
