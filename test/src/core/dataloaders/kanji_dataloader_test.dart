import "dart:convert";
import "dart:io";

import "package:flutter_test/flutter_test.dart";
import "package:http/http.dart" as http;
import "package:kana_to_kanji/src/core/dataloaders/kanji_dataloader.dart";
import "package:kana_to_kanji/src/core/models/kanji.dart";
import "package:kana_to_kanji/src/core/services/api_service.dart";
import "package:kana_to_kanji/src/core/services/kanji_service.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

import "../../../dummies/dummies.dart";
import "../../../helpers.dart";
@GenerateNiceMocks([MockSpec<ApiService>(), MockSpec<KanjiService>()])
import "kanji_dataloader_test.mocks.dart";

void main() {
  group("KanjiDataLoader", () {
    late KanjiDataLoader dataLoader;
    late MockApiService apiService;
    late MockKanjiService kanjiService;
    late http.Response mockResponse;

    final List<Map<String, dynamic>> testKanjiData =
        dummiesKanji
            .map((k) => k.toJson()..remove(sqlJpSortSyllablesColumn))
            .toList();

    setUpAll(() {
      apiService = MockApiService();
      kanjiService = MockKanjiService();

      locator.registerSingleton<ApiService>(apiService);
    });

    tearDownAll(() async {
      await unregister<ApiService>();
    });

    setUp(() async {
      // Initialize the dataLoader with mocked services
      dataLoader = KanjiDataLoader(service: kanjiService);

      // Set up default mock response
      mockResponse = http.Response(
        jsonEncode(testKanjiData),
        HttpStatus.ok,
        headers: {
          // TODO Necessary until http 1.4.0
          "content-type": "application/json;charset=utf-8",
        },
      );

      // Set up the API service response for default kanji endpoint
      when(
        apiService.get("/v1/kanji"),
      ).thenAnswer((_) async => Future.value(mockResponse));

      // Set up response for version-specific endpoint
      when(
        apiService.get("/v1/kanji?version[current]=2025_01_01"),
      ).thenAnswer((_) async => Future.value(mockResponse));
    });

    tearDown(() {
      reset(apiService);
      reset(kanjiService);
    });

    group("extractItems", () {
      test("should extract kanji items from successful response", () {
        final result = dataLoader.extractItems(mockResponse);

        // Assert
        expect(result.length, dummiesKanji.length);
        expect(result, containsAll(dummiesKanji));
      });

      test(
        "should prioritize kun readings for sort syllables when available",
        () {
          final result = dataLoader.extractItems(mockResponse);

          expect(result[0].jpSortSyllables, dummiesKanji[0].jpSortSyllables);
        },
      );

      test(
        "should fall back to on readings when kun readings are not available",
        () {
          final kanjiWithoutKun = [
            {
              "uid": "kanji-4",
              "jlpt_level": 5,
              "kanji": "火",
              "version": "2025_01_01",
              "kun_readings": [], // empty kun readings
              "on_readings": ["カ"], // only on reading available
              "meanings": ["fire"],
              "main_meaning": "fire",
            },
          ];

          final response = http.Response(
            jsonEncode(kanjiWithoutKun),
            HttpStatus.ok,
            headers: {
              // TODO Necessary until http 1.4.0
              "content-type": "application/json;charset=utf-8",
            },
          );

          final result = dataLoader.extractItems(response);

          expect(result.length, 1);
          expect(result[0].uid.uid, "kanji-4");
          expect(result[0].jpSortSyllables.isNotEmpty, true);
        },
      );

      test("should use pronunciations when available", () {
        final kanji = [
          {
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
                "readings": ["カ"], // sort syllables index 12
              },
            ],
          },
        ];

        final result = dataLoader.extractItems(
          http.Response(
            jsonEncode(kanji),
            HttpStatus.ok,
            headers: {
              // TODO Necessary until http 1.4.0
              "content-type": "application/json;charset=utf-8",
            },
          ),
        );

        // Assert
        expect(result.first.uid.uid, "kanji-4");
        expect(result.first.jpSortSyllables, equals([12]));
      });

      test("should return empty list when response status is not 200", () {
        // Arrange
        final errorResponse = http.Response("", HttpStatus.notFound);

        // Act
        final result = dataLoader.extractItems(errorResponse);

        // Assert
        expect(result, isEmpty);
      });

      test("should handle empty response", () {
        // Arrange
        final emptyResponse = http.Response("[]", HttpStatus.ok);

        // Act
        final result = dataLoader.extractItems(emptyResponse);

        // Assert
        expect(result, isEmpty);
      });
    });

    group("loadCollection", () {
      test(
        "should fetch kanji with no version when forceReload is true",
        () async {
          when(
            kanjiService.upsertAll(any, forceReload: true),
          ).thenAnswer((_) async => {});

          await dataLoader.loadCollection(
            latestVersion: "2025_01_01",
            forceReload: true,
          );

          verify(apiService.get("/v1/kanji")).called(1);
          verify(kanjiService.upsertAll(any, forceReload: true)).called(1);
        },
      );

      test(
        "should fetch kanji with version when forceReload is false",
        () async {
          when(
            // ignore: avoid_redundant_argument_values
            kanjiService.upsertAll(any, forceReload: false),
          ).thenAnswer((_) async => {});

          await dataLoader.loadCollection(
            latestVersion: "2025_01_01",
            // ignore: avoid_redundant_argument_values
            forceReload: false,
          );

          verify(
            apiService.get("/v1/kanji?version[current]=2025_01_01"),
          ).called(1);
          // ignore: avoid_redundant_argument_values
          verify(kanjiService.upsertAll(any, forceReload: false)).called(1);
        },
      );

      test("should handle API error gracefully", () async {
        final errorResponse = http.Response("", HttpStatus.internalServerError);

        when(
          apiService.get("/v1/kanji?version[current]=2025_01_01"),
        ).thenAnswer((_) async => Future.value(errorResponse));

        when(
          // ignore: avoid_redundant_argument_values
          kanjiService.upsertAll(any, forceReload: false),
        ).thenAnswer((_) async => {});

        await dataLoader.loadCollection(
          latestVersion: "2025_01_01",
          // ignore: avoid_redundant_argument_values
          forceReload: false,
        );

        verify(
          apiService.get("/v1/kanji?version[current]=2025_01_01"),
        ).called(1);
        // ignore: avoid_redundant_argument_values
        verify(kanjiService.upsertAll([], forceReload: false)).called(1);
      });
    });

    test("end-to-end flow", () async {
      when(
        // ignore: avoid_redundant_argument_values
        kanjiService.upsertAll(any, forceReload: false),
      ).thenAnswer((_) async => {});

      await dataLoader.loadCollection(latestVersion: "2025_01_01");

      verify(apiService.get("/v1/kanji?version[current]=2025_01_01")).called(1);

      // Capture the actual list passed to upsertAll
      final captured =
          verify(
                // ignore: avoid_redundant_argument_values
                kanjiService.upsertAll(captureAny, forceReload: false),
              ).captured.first
              as List<Kanji>;

      expect(captured.length, 3);
      expect(captured, containsAll(dummiesKanji));
    });
  });
}
