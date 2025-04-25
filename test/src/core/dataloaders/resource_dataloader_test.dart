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
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

import "../../../helpers.dart";
@GenerateNiceMocks([MockSpec<ApiService>(), MockSpec<ResourceDataService>()])
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
    late http.Response mockResponse;

    final List<Map<String, dynamic>> testResources = [
      {"uid": "group-1", "version": "2025_01_01"},
      {"uid": "group-2", "version": "2025_01_01"},
    ];

    final List<TestResource> resources =
        testResources.map(TestResource.fromJson).toList();

    setUpAll(() {
      apiService = MockApiService();
      service = MockResourceDataService<TestResource>();

      locator.registerSingleton<ApiService>(apiService);
    });

    tearDownAll(() async {
      await unregister<ApiService>();
    });

    setUp(() async {
      // Setup the dataLoader with test dependencies
      dataLoader = ResourceDataLoader<TestResource>(
        service: service,
        fromJson: TestResource.fromJson,
        apiResourceType: "test-resources",
      );
      mockResponse = http.Response(jsonEncode(resources), HttpStatus.ok);

      when(
        apiService.get("/v1/test-resources"),
      ).thenAnswer((_) async => Future.value(mockResponse));
      when(
        apiService.get("/v1/test-resources?version[current]=2025_01_01"),
      ).thenAnswer((_) async => Future.value(mockResponse));
    });

    tearDown(() {
      reset(apiService);
      reset(service);
    });

    group("loadCollection", () {
      test(
        "should fetch resources with no version when forceReload is true",
        () async {
          await dataLoader.loadCollection(
            latestVersion: "2025_01_01",
            forceReload: true,
          );

          verify(apiService.get("/v1/test-resources")).called(1);
          verify(service.upsertAll(any, forceReload: true)).called(1);
        },
      );

      test(
        "should fetch resources with version when forceReload is false",
        () async {
          await dataLoader.loadCollection(
            latestVersion: "2025_01_01",
            // ignore: avoid_redundant_argument_values
            forceReload: false,
          );

          verify(
            apiService.get("/v1/test-resources?version[current]=2025_01_01"),
          ).called(1);
          verify(service.upsertAll(any, forceReload: false)).called(1);
        },
      );

      test(
        "should fetch resources with no version parameter when latestVersion "
        "is null",
        () async {
          await dataLoader.loadCollection(
            // ignore: avoid_redundant_argument_values
            latestVersion: null,
            // ignore: avoid_redundant_argument_values
            forceReload: false,
          );

          verify(apiService.get("/v1/test-resources")).called(1);
          verify(service.upsertAll(any, forceReload: false)).called(1);
        },
      );
    });

    group("extractItems", () {
      test("should extract items from successful response", () {
        final result = dataLoader.extractItems(mockResponse);

        expect(result.length, 2);
        expect(result, containsAll(resources));
      });

      test("should return empty list when response status is not 200", () {
        mockResponse = http.Response("", HttpStatus.notFound);

        final result = dataLoader.extractItems(mockResponse);

        expect(result, isEmpty);
      });

      test("should handle empty response", () {
        mockResponse = http.Response("[]", HttpStatus.notFound);

        final result = dataLoader.extractItems(mockResponse);

        expect(result, isEmpty);
      });
    });

    test("end-to-end flow with successful API call", () async {
      when(
        service.upsertAll(any, forceReload: false),
      ).thenAnswer((_) async => {});

      await dataLoader.loadCollection(latestVersion: "2025_01_01");

      verify(
        apiService.get("/v1/test-resources?version[current]=2025_01_01"),
      ).called(1);

      // Capture the actual list passed to upsertAll
      final captured =
          verify(
                service.upsertAll(captureAny, forceReload: false),
              ).captured.first
              as List<TestResource>;

      expect(captured.length, 2);
      expect(captured, containsAll(resources));
    });

    test("should handle API error gracefully", () async {
      mockResponse = http.Response("", HttpStatus.internalServerError);

      await dataLoader.loadCollection(latestVersion: "2025_01_01");

      verify(
        apiService.get("/v1/test-resources?version[current]=2025_01_01"),
      ).called(1);
      verify(service.upsertAll([], forceReload: false)).called(1);
    });
  });
}
