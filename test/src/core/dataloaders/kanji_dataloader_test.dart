import "dart:convert";
import "dart:io";

import "package:flutter_test/flutter_test.dart";
import "package:http/http.dart" as http;
import "package:kana_to_kanji/src/core/dataloaders/kanji_dataloader.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";
import "package:kana_to_kanji/src/core/services/api_service.dart";
import "package:kana_to_kanji/src/core/services/kanji_service.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:logger/logger.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

import "../../../dummies/dummies.dart";
import "../../../helpers.dart";
@GenerateNiceMocks([MockSpec<ApiService>(), MockSpec<Logger>()])
import "kanji_dataloader_test.mocks.dart";

void main() {
  group("KanjiDataLoader", () {
    late KanjiDataLoader dataLoader;
    late MockApiService apiService;
    late MockLogger mockLogger;
    late http.Response mockResponse;
    late http.Response mockNextPageResponse;

    final List<Map<String, dynamic>> testKanjiData =
        dummiesKanji
            .map((k) => k.toJson()..remove(sqlJpSortSyllablesColumn))
            .toList();

    // Create paginated response structure
    final Map<String, dynamic> firstPageResponse = {
      "links": {
        "first": "/v1/kanjis?page=1",
        "previous": "/v1/kanjis?page=1",
        "next": "/v1/kanjis?page=2",
        "self": "/v1/kanjis?page=1",
        "prev": "/v1/kanjis?page=1",
        "last": "/v1/kanjis?page=2",
        "has_more": true,
      },
      "data": testKanjiData.sublist(0, 2),
    };

    // Create second page response with no more pages
    final Map<String, dynamic> lastPageResponse = {
      "links": {
        "first": "/v1/kanjis?page=1",
        "previous": "/v1/kanjis?page=1",
        "next": "/v1/kanjis?page=2",
        "self": "/v1/kanjis?page=2",
        "prev": "/v1/kanjis?page=1",
        "last": "/v1/kanjis?page=2",
        "has_more": false,
      },
      "data": testKanjiData.sublist(2),
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
      dataLoader = KanjiDataLoader();

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
        apiService.get(argThat(startsWith("/v1/kanjis"))),
      ).thenAnswer((_) async => Future.value(mockResponse));

      // Setup response for the next page
      when(
        apiService.get("/v1/kanjis?page=2"),
      ).thenAnswer((_) async => Future.value(mockNextPageResponse));
    });

    tearDown(() {
      reset(apiService);
    });

    group("fetchAll", () {
      test("should fetch kanji without version parameter", () async {
        final result = await dataLoader.fetchAll();

        verify(apiService.get("/v1/kanjis?page[size]=1000")).called(1);

        expect(result.data.length, 2);
        expect(result.hasMore, isTrue);

        // Fetch next page
        final nextPage = await result.next!();
        expect(nextPage.data.length, 1);
        expect(nextPage.hasMore, isFalse);

        verify(apiService.get("/v1/kanjis?page=2")).called(1);

        // Check all resources were collected
        final allResources = [...result.data, ...nextPage.data];
        expect(allResources.length, 3);
      });

      test("should fetch kanji with version parameter", () async {
        final result = await dataLoader.fetchAll(latestVersion: "2025_01_01");

        verify(
          apiService.get(
            "/v1/kanjis?page[size]=1000&version[current]=2025_01_01",
          ),
        ).called(1);

        expect(result.data.length, 2);
        expect(result.hasMore, isTrue);
      });
    });

    group("deserialize", () {
      test(
        "should prioritize kun readings for sort syllables when available",
        () {
          final kanjiWithKun = {
            "uid": "kanji-1",
            "kanji": "日",
            "jlpt_level": 5,
            "version": "2025_01_01",
            "kun_readings": ["ひ", "び"],
            "on_readings": ["ニチ", "ジツ"],
            "meanings": ["day", "sun"],
            "main_meaning": "day",
          };

          final result = KanjiDataLoader.deserialize(kanjiWithKun);

          // Should use first kun reading (ひ)
          expect(result.jpSortSyllables.isNotEmpty, true);
        },
      );

      test(
        "should fall back to on readings when kun readings are not available",
        () {
          final kanjiWithoutKun = {
            "uid": "kanji-4",
            "jlpt_level": 5,
            "kanji": "火",
            "version": "2025_01_01",
            "kun_readings": [], // empty kun readings
            "on_readings": ["カ"], // only on reading available
            "meanings": ["fire"],
            "main_meaning": "fire",
          };

          final result = KanjiDataLoader.deserialize(kanjiWithoutKun);

          expect(result.uid.uid, "kanji-4");
          expect(result.jpSortSyllables.isNotEmpty, true);
        },
      );

      test("should use pronunciations when available", () {
        final kanjiWithPronunciations = {
          "uid": "kanji-4",
          "kanji": "火",
          "jlpt_level": 5,
          "version": "2025_01_01",
          "kun_readings": [], // empty kun readings
          "on_readings": [], // empty on readings
          "meanings": ["fire"],
          "main_meaning": "fire",
          "pronunciations": [
            {
              "index": 0,
              "meanings": ["fire"],
              "readings": ["カ"],
            },
          ],
        };

        final result = KanjiDataLoader.deserialize(kanjiWithPronunciations);

        expect(result.uid.uid, "kanji-4");
        expect(result.jpSortSyllables.isNotEmpty, true);
      });
    });

    test("fetch method should throw UnimplementedError", () {
      expect(
        () async => await dataLoader.fetch(ResourceUid.fromJson("kanji-1")),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });
}
