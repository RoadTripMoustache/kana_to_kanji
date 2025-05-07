import "dart:convert";
import "dart:io";
import "dart:math";

import "package:flutter_test/flutter_test.dart";
import "package:http/http.dart" as http;
import "package:kana_to_kanji/src/core/constants/resource_type.dart";
import "package:kana_to_kanji/src/core/dataloaders/example_dataloader.dart";
import "package:kana_to_kanji/src/core/models/resources/example.dart";
import "package:kana_to_kanji/src/core/models/resources/resource_uid.dart";
import "package:kana_to_kanji/src/core/services/api_service.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:logger/logger.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

import "../../../helpers.dart";
@GenerateNiceMocks([MockSpec<ApiService>(), MockSpec<Logger>()])
import "example_dataloader_test.mocks.dart";

void main() {
  group("ExampleDataLoader", () {
    late ExampleDataLoader dataLoader;
    late MockApiService apiService;
    late MockLogger mockLogger;

    final kanjiUid = ResourceUid.fromJson("kanji-1");
    final vocabularyUid = ResourceUid.fromJson("vocabulary-1");
    http.Response buildMockResponse({
      ResourceUid? uid,
      bool hasMore = false,
      int pageNumber = 1,
      int uidStart = 1,
    }) {
      String resourceUrl = "";

      if (uid != null) {
        resourceUrl =
            "/${uid.resourceType == ResourceType.vocabulary ? uid.resourceType.name : "${uid.resourceType.name}s"}/${uid.uid}";
      }

      final data = {
        "links": {
          "first": "/v1$resourceUrl/examples?page=1",
          "previous": "/v1$resourceUrl/examples?page=${max(pageNumber - 1, 0)}",
          "next": "/v1$resourceUrl/examples?page=${pageNumber + 1}",
          "self": "/v1$resourceUrl/examples?page=$pageNumber",
          "prev": "/v1$resourceUrl/examples?page=${max(pageNumber - 1, 0)}",
          "last":
              "/v1$resourceUrl/examples?page=${hasMore ? pageNumber + 1 : pageNumber}",
          "has_more": hasMore,
        },
        "data": [
          {
            "uid": "example-$uidStart",
            "sentence": "こんにちは世界",
            "translation": "Hello world",
            "kanji": ["こんにちは", "世界"],
            "reading": ["konnichiwa", "sekai"],
            "version": "2025_01_01",
          },
          {
            "uid": "example-${uidStart + 1}",
            "sentence": "私は日本語を勉強します",
            "translation": "I study Japanese",
            "kanji": ["私", "日本語", "勉強"],
            "reading": ["watashi", "nihongo", "benkyou"],
            "version": "2025_01_01",
          },
        ],
      };

      return http.Response(
        jsonEncode(data),
        HttpStatus.ok,
        headers: {"content-type": "application/json;charset=utf-8"},
      );
    }

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
      dataLoader = ExampleDataLoader();
    });

    tearDown(() {
      reset(apiService);
    });

    group("fetchResourceExamples", () {
      setUp(() async {
        // Setup API responses for kanji examples endpoint
        when(
          apiService.get(
            argThat(startsWith("/v1/kanjis/${kanjiUid.uid}/examples")),
          ),
        ).thenAnswer(
          (_) async => buildMockResponse(uid: kanjiUid, hasMore: true),
        );
        // Setup response for the next page
        when(
          apiService.get("/v1/kanjis/${kanjiUid.uid}/examples?page=2"),
        ).thenAnswer(
          (_) async =>
              buildMockResponse(uid: kanjiUid, pageNumber: 2, uidStart: 3),
        );

        // Setup API responses for vocabulary examples endpoint
        when(
          apiService.get(
            argThat(startsWith("/v1/vocabulary/${vocabularyUid.uid}/examples")),
          ),
        ).thenAnswer((_) async => buildMockResponse(uid: vocabularyUid));
      });

      test("should fetch examples for kanji resources", () async {
        final result = await dataLoader.fetchResourceExamples(kanjiUid);

        verify(apiService.get("/v1/kanjis/kanji-1/examples")).called(1);

        expect(result.data.length, 2);
        expect(result.data[0].uid.uid, "example-1");
        expect(result.data[1].uid.uid, "example-2");
        expect(result.hasMore, isTrue);

        // Fetch next page
        final nextPage = await result.next!();
        expect(nextPage.data.length, 2);
        expect(nextPage.data[0].uid.uid, "example-3");
        expect(nextPage.data[1].uid.uid, "example-4");
        expect(nextPage.hasMore, isFalse);

        verify(apiService.get("/v1/kanjis/kanji-1/examples?page=2")).called(1);
      });

      test("should fetch examples for vocabulary resources", () async {
        final result = await dataLoader.fetchResourceExamples(vocabularyUid);

        verify(
          apiService.get("/v1/vocabulary/vocabulary-1/examples"),
        ).called(1);

        expect(result.data.length, 2);
        expect(result.data[0].uid.uid, "example-1");
        expect(result.data[1].uid.uid, "example-2");
        expect(result.hasMore, isFalse);
      });

      test("should throw assertion error for unsupported resource types", () {
        final groupUid = ResourceUid.fromJson("group-1");

        expect(
          () async => dataLoader.fetchResourceExamples(groupUid),
          throwsA(isA<AssertionError>()),
        );
      });

      test("should handle API error gracefully", () async {
        // Set up error response
        final errorResponse = http.Response("", HttpStatus.internalServerError);
        final kanjiUid = ResourceUid.fromJson("kanji-error");

        when(
          apiService.get("/v1/kanjis/kanji-error/examples"),
        ).thenAnswer((_) async => Future.value(errorResponse));

        final result = await dataLoader.fetchResourceExamples(kanjiUid);

        verify(apiService.get("/v1/kanjis/kanji-error/examples")).called(1);

        // Should return empty list when API returns error
        expect(result.data, isEmpty);
        expect(result.hasMore, isFalse);
      });

      test("should parse example objects correctly", () async {
        final kanjiUid = ResourceUid.fromJson("kanji-1");
        final result = await dataLoader.fetchResourceExamples(kanjiUid);

        // Check that the Example objects are properly constructed
        final example = result.data[0];
        expect(example, isA<Example>());
        expect(example.uid.uid, "example-1");
        expect(example.sentence, "こんにちは世界");
        expect(example.translation, "Hello world");
        expect(example.kanji, ["こんにちは", "世界"]);
        expect(example.reading, ["konnichiwa", "sekai"]);
        expect(example.version, "2025_01_01");
      });
    });

    group("fetchAll", () {
      setUp(() async {
        // Setup API responses for kanji examples endpoint
        when(
          apiService.get(argThat(startsWith("/v1/examples"))),
        ).thenAnswer((_) async => buildMockResponse());
      });

      test("inherits fetchAll method from ResourceDataLoader", () async {
        final result = await dataLoader.fetchAll();

        verify(apiService.get("/v1/examples?page[size]=1000")).called(1);

        expect(result.data.length, 2);
        expect(result.data[0].uid.uid, "example-1");
        expect(result.data[1].uid.uid, "example-2");
        expect(result.hasMore, isFalse);
      });

      test(
        "inherits fetchAll with version parameter from ResourceDataLoader",
        () async {
          final result = await dataLoader.fetchAll(latestVersion: "2025_01_01");

          verify(
            apiService.get(
              "/v1/examples?page[size]=1000&version[current]=2025_01_01",
            ),
          ).called(1);

          expect(result.data.length, 2);
          expect(result.data[0].uid.uid, "example-1");
          expect(result.data[1].uid.uid, "example-2");
        },
      );
    });
  });
}
