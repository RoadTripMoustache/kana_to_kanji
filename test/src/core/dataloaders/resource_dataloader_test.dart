import "dart:convert";
import "dart:io";

import "package:flutter/foundation.dart";
import "package:flutter_test/flutter_test.dart";
import "package:http/http.dart" as http;
import "package:kana_to_kanji/src/core/dataloaders/resource_dataloader.dart";
import "package:kana_to_kanji/src/core/models/resource.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";
import "package:kana_to_kanji/src/core/services/api_service.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:logger/logger.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

import "../../../helpers.dart";
@GenerateNiceMocks([MockSpec<ApiService>(), MockSpec<Logger>()])
import "../dataloaders/resource_dataloader_test.mocks.dart";

// Create a test resource implementation
@immutable
class TestResource implements Resource {
  @override
  final String version;

  @override
  final ResourceUid uid;

  const TestResource({required this.uid, required this.version});

  factory TestResource.fromJson(Map<String, dynamic> json) => TestResource(
    uid: ResourceUid.fromJson(json["uid"]),
    version: json["version"],
  );

  @override
  Map<String, Object?> toJson() => {"uid": uid.uid, "version": version};

  @override
  bool operator ==(Object other) =>
      other is TestResource && other.uid == uid && other.version == version;

  @override
  int get hashCode => uid.hashCode ^ version.hashCode;
}

void main() {
  group("ResourceDataLoader", () {
    late ResourceDataLoader<TestResource> dataLoader;
    late MockApiService apiService;
    late MockLogger mockLogger;
    late http.Response mockResponse;
    late http.Response mockNextPageResponse;

    // Create paginated response structure
    final Map<String, dynamic> firstPageResponse = {
      "links": {
        "first": "/v1/test-resources?page=1",
        "previous": "/v1/test-resources?page=1",
        "next": "/v1/test-resources?page=2",
        "self": "/v1/test-resources?page=1",
        "prev": "/v1/test-resources?page=1",
        "last": "/v1/test-resources?page=2",
        "has_more": true,
      },
      "data": [
        {"uid": "group-1", "version": "2025_01_01"},
        {"uid": "group-2", "version": "2025_01_01"},
      ],
    };

    // Create second page response with no more pages
    final Map<String, dynamic> lastPageResponse = {
      "links": {
        "first": "/v1/test-resources?page=1",
        "previous": "/v1/test-resources?page=1",
        "next": "/v1/test-resources?page=2",
        "self": "/v1/test-resources?page=2",
        "prev": "/v1/test-resources?page=1",
        "last": "/v1/test-resources?page=2",
        "has_more": false,
      },
      "data": [
        {"uid": "group-3", "version": "2025_01_01"},
        {"uid": "group-4", "version": "2025_01_01"},
      ],
    };

    final List<Map<String, dynamic>> testResources = [
      ...firstPageResponse["data"],
      ...lastPageResponse["data"],
    ];

    final List<TestResource> resources =
        testResources.map(TestResource.fromJson).toList();

    setUpAll(() {
      apiService = MockApiService();
      mockLogger = MockLogger();

      locator
        ..registerSingleton<ApiService>(apiService)
        ..registerSingleton<Logger>(mockLogger);
    });

    tearDownAll(() async {
      await unregister<ApiService>();
      await unregister<Logger>();
    });

    setUp(() async {
      // Setup the dataLoader with test dependencies
      dataLoader = ResourceDataLoader<TestResource>(
        fromJson: TestResource.fromJson,
        apiResourceType: "test-resources",
      );

      // Setup mock responses with paginated structure
      mockResponse = http.Response(
        jsonEncode(firstPageResponse),
        HttpStatus.ok,
        headers: {"content-type": "application/json;charset=utf-8"},
      );

      mockNextPageResponse = http.Response(
        jsonEncode(lastPageResponse),
        HttpStatus.ok,
        headers: {"content-type": "application/json;charset=utf-8"},
      );

      // Setup API responses for different endpoints
      when(
        apiService.get(argThat(startsWith("/v1/test-resources"))),
      ).thenAnswer((_) async => Future.value(mockResponse));

      // Setup response for the next page
      when(
        apiService.get("/v1/test-resources?page=2"),
      ).thenAnswer((_) async => Future.value(mockNextPageResponse));
    });

    tearDown(() {
      reset(apiService);
    });

    group("fetchAll", () {
      test(
        "should fetch resources without version parameter by default",
        () async {
          final result = await dataLoader.fetchAll();

          verify(
            apiService.get("/v1/test-resources?page[size]=1000"),
          ).called(1);

          expect(result.data.length, 2);
          expect(result.hasMore, isTrue);

          // Fetch next page
          final nextPage = await result.next!();
          expect(nextPage.data.length, 2);
          expect(nextPage.hasMore, isFalse);

          verify(apiService.get("/v1/test-resources?page=2")).called(1);

          // Check all 4 resources were collected
          final allResources = [...result.data, ...nextPage.data];
          expect(allResources.length, resources.length);
          expect(allResources, resources);

          verifyNoMoreInteractions(apiService);
        },
      );

      test(
        "should fetch resources with version parameter when specified",
        () async {
          final result = await dataLoader.fetchAll(latestVersion: "2025_01_01");

          verify(
            apiService.get(
              "/v1/test-resources?page[size]=1000&version[current]=2025_01_01",
            ),
          ).called(1);

          expect(result.data.length, 2);
          expect(result.hasMore, isTrue);

          // Fetch next page
          final nextPage = await result.next!();
          expect(nextPage.data.length, 2);
          expect(nextPage.hasMore, isFalse);

          verify(apiService.get("/v1/test-resources?page=2")).called(1);

          verifyNoMoreInteractions(apiService);
        },
      );
    });

    test("should handle API error gracefully", () async {
      // Set up error response
      final errorResponse = http.Response("", HttpStatus.internalServerError);

      when(
        apiService.get(
          "/v1/test-resources?page[size]=1000&version[current]=2025_01_01",
        ),
      ).thenAnswer((_) async => Future.value(errorResponse));

      final result = await dataLoader.fetchAll(latestVersion: "2025_01_01");

      verify(
        apiService.get(
          "/v1/test-resources?page[size]=1000&version[current]=2025_01_01",
        ),
      ).called(1);

      // Should return empty list when API returns error
      expect(result.data, isEmpty);
      expect(result.hasMore, isFalse);
    });

    test("should extract paginated response correctly", () async {
      // Testing the private method via its public usage
      final result = await dataLoader.fetchAll();

      // First page should be properly parsed
      expect(result.data.length, 2);
      expect(result.data[0].uid.uid, "group-1");
      expect(result.data[0].version, "2025_01_01");
      expect(result.data[1].uid.uid, "group-2");
      expect(result.hasMore, isTrue);

      // Second page should be properly parsed when accessed
      final nextPage = await result.next!();
      expect(nextPage.data.length, 2);
      expect(nextPage.data[0].uid.uid, "group-3");
      expect(nextPage.data[1].uid.uid, "group-4");
      expect(nextPage.hasMore, isFalse);
    });

    test("fetch method should throw UnimplementedError", () {
      expect(
        () async =>
            await dataLoader.fetch(ResourceUid.fromJson("group-resource")),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });
}
