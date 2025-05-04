import "dart:convert";
import "dart:io";

import "package:flutter_test/flutter_test.dart";
import "package:http/http.dart" as http;
import "package:kana_to_kanji/src/core/dataloaders/vocabulary_dataloader.dart";
import "package:kana_to_kanji/src/core/services/api_service.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:logger/logger.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

import "../../../dummies/vocabulary.dart";
import "../../../helpers.dart";
@GenerateNiceMocks([MockSpec<ApiService>(), MockSpec<Logger>()])
import "vocabulary_dataloader_test.mocks.dart";

void main() {
  group("VocabularyDataLoader", () {
    late VocabularyDataLoader dataLoader;
    late MockApiService apiService;
    late MockLogger mockLogger;
    late http.Response mockResponse;
    late http.Response mockNextPageResponse;

    final List<Map<String, dynamic>> testVocabularyData =
        dummiesVocabulary
            .map((v) => v.toJson()..remove("kana_syllables"))
            .toList();

    // Create paginated response structure
    final Map<String, dynamic> firstPageResponse = {
      "links": {
        "first": "/v1/vocabulary?page=1",
        "previous": "/v1/vocabulary?page=1",
        "next": "/v1/vocabulary?page=2",
        "self": "/v1/vocabulary?page=1",
        "prev": "/v1/vocabulary?page=1",
        "last": "/v1/vocabulary?page=2",
        "has_more": true,
      },
      "data": testVocabularyData.sublist(0, 2),
    };

    // Create second page response with no more pages
    final Map<String, dynamic> lastPageResponse = {
      "links": {
        "first": "/v1/vocabulary?page=1",
        "previous": "/v1/vocabulary?page=1",
        "next": "/v1/vocabulary?page=2",
        "self": "/v1/vocabulary?page=2",
        "prev": "/v1/vocabulary?page=1",
        "last": "/v1/vocabulary?page=2",
        "has_more": false,
      },
      "data": testVocabularyData.sublist(2),
    };

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
      // Initialize the dataLoader
      dataLoader = VocabularyDataLoader();

      // Set up default mock responses
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

      // Set up the API service responses
      when(
        apiService.get(argThat(startsWith("/v1/vocabulary"))),
      ).thenAnswer((_) async => Future.value(mockResponse));

      // Setup response for the next page
      when(
        apiService.get("/v1/vocabulary?page=2"),
      ).thenAnswer((_) async => Future.value(mockNextPageResponse));
    });

    tearDown(() {
      reset(apiService);
    });

    group("fetchAll", () {
      test("should fetch vocabulary without version parameter", () async {
        final result = await dataLoader.fetchAll();

        verify(apiService.get("/v1/vocabulary?page[size]=1000")).called(1);

        expect(result.data.length, 2);
        expect(result.hasMore, isTrue);

        // Fetch next page
        final nextPage = await result.next!();
        expect(nextPage.data.length, 1);
        expect(nextPage.hasMore, isFalse);

        verify(apiService.get("/v1/vocabulary?page=2")).called(1);

        // Check all resources were collected
        final allResources = [...result.data, ...nextPage.data];
        expect(allResources.length, 3);
      });

      test("should fetch vocabulary with version parameter", () async {
        final result = await dataLoader.fetchAll(latestVersion: "2025_01_01");

        verify(
          apiService.get(
            "/v1/vocabulary?page[size]=1000&version[current]=2025_01_01",
          ),
        ).called(1);

        expect(result.data.length, 2);
        expect(result.hasMore, isTrue);
      });
    });

    test("fetch method should throw UnimplementedError", () {
      expect(
        () async => await dataLoader.fetch(dummiesVocabulary.first.uid),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });
}
