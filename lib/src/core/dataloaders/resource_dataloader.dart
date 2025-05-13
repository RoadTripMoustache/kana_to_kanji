import "dart:convert";

import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:kana_to_kanji/src/core/models/paginated_api_response.dart";
import "package:kana_to_kanji/src/core/models/paginated_data.dart";
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
  /// Returns a [PaginatedData] with a cursor to the next page, each page
  /// contains a thousand (1000) items maximum
  Future<PaginatedData<T>> fetchAll({
    String? latestVersion,
    int page = 0,
    int pageSize = _kBatchSize,
  }) async {
    var versionQueryParam = "?page[size]=$pageSize&page[number]=$page";

    if (latestVersion != null) {
      versionQueryParam += "&version[current]=$latestVersion";
    }

    return fetchPaginated("/v1/$apiResourceType$versionQueryParam");
  }

  @protected
  Future<PaginatedData<T>> fetchPaginated(String url) async {
    _logger.d("ResourceDataLoader<$T>: fetching: $url");
    final response = await _apiService.get(url).then(_extractPaginatedResponse);

    if (response != null) {
      return PaginatedData<T>(
        data: response.data,
        next:
            response.hasMore ? () => fetchPaginated(response.links.next) : null,
      );
    }

    return PaginatedData<T>(data: []);
  }

  /// Fetch a specific kanji in full details
  Future<T> fetch(ResourceUid uid) async {
    throw UnimplementedError();
  }

  /// Extract the paginated response from the API Response.
  PaginatedApiResponse<T>? _extractPaginatedResponse(http.Response response) {
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return PaginatedApiResponse<T>.fromJson(
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
