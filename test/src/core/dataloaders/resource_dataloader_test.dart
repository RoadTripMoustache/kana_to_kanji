import "dart:convert";
import "dart:io";

import "package:flutter/foundation.dart";
import "package:flutter_test/flutter_test.dart";
import "package:http/http.dart" as http;
import "package:kana_to_kanji/src/core/dataloaders/resource_dataloader.dart";
import "package:kana_to_kanji/src/core/models/resource.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";
import "package:kana_to_kanji/src/core/services/api_service.dart";
import "package:kana_to_kanji/src/core/services/resource_data_service.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:logger/logger.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

import "../../../helpers.dart";
@GenerateNiceMocks([
  MockSpec<ApiService>(),
  MockSpec<ResourceDataService>(),
  MockSpec<Logger>(),
])
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
    late MockResourceDataService<TestResource> service;
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
      service = MockResourceDataService<TestResource>();
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
        service: service,
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
      reset(service);
    });

    group("fetchAll", () {
      test(
        "should fetch resources with no version when forceReload is true",
        () async {
          await dataLoader.fetchAll(
            latestVersion: "2025_01_01",
            forceReload: true,
          );

          verifyInOrder([
            apiService.get("/v1/test-resources"),
            apiService.get("/v1/test-resources?page=2"),
            service.upsertAll(resources, forceReload: true),
          ]);
        },
      );

      test(
        "should fetch resources with version when forceReload is false",
        () async {
          await dataLoader.fetchAll(
            latestVersion: "2025_01_01",
            // ignore: avoid_redundant_argument_values
            forceReload: false,
          );

          verifyInOrder([
            apiService.get("/v1/test-resources?version[current]=2025_01_01"),
            apiService.get("/v1/test-resources?page=2"),
            service.upsertAll(resources, forceReload: false),
          ]);
        },
      );

      test(
        "should fetch resources with no version parameter when latestVersion "
        "is null",
        () async {
          await dataLoader.fetchAll(
            // ignore: avoid_redundant_argument_values
            latestVersion: null,
            // ignore: avoid_redundant_argument_values
            forceReload: false,
          );

          verifyInOrder([
            apiService.get("/v1/test-resources"),
            apiService.get("/v1/test-resources?page=2"),
            service.upsertAll(resources, forceReload: false),
          ]);
        },
      );
    });

    test("end-to-end flow with successful API call", () async {
      when(
        service.upsertAll(any, forceReload: false),
      ).thenAnswer((_) async => {});

      await dataLoader.fetchAll(latestVersion: "2025_01_01");

      verifyInOrder([
        apiService.get("/v1/test-resources?version[current]=2025_01_01"),
        apiService.get("/v1/test-resources?page=2"),
      ]);
      // Capture the actual list passed to upsertAll
      final captured =
          verify(
                service.upsertAll(captureAny, forceReload: false),
              ).captured.first
              as List<TestResource>;

      // Should contain items from both pages (4 total)
      expect(captured.length, 4);
      expect(captured, resources, reason: "should contain both pages data");
    });

    test("should handle API error gracefully", () async {
      // Set up error response
      final errorResponse = http.Response("", HttpStatus.internalServerError);

      when(
        apiService.get("/v1/test-resources?version[current]=2025_01_01"),
      ).thenAnswer((_) async => Future.value(errorResponse));

      await dataLoader.fetchAll(latestVersion: "2025_01_01");

      verify(
        apiService.get("/v1/test-resources?version[current]=2025_01_01"),
      ).called(1);
      verifyNoMoreInteractions(apiService);

      // Should call upsertAll with empty list when API returns error
      verify(service.upsertAll([], forceReload: false)).called(1);
    });
  });
}
