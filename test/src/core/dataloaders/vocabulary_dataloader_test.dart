import "dart:convert";
import "dart:io";

import "package:flutter_test/flutter_test.dart";
import "package:http/http.dart" as http;
import "package:kana_to_kanji/src/core/dataloaders/vocabulary_dataloader.dart";
import "package:kana_to_kanji/src/core/models/vocabulary.dart";
import "package:kana_to_kanji/src/core/services/api_service.dart";
import "package:kana_to_kanji/src/core/services/vocabulary_service.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

import "../../../dummies/vocabulary.dart";
import "../../../helpers.dart";
@GenerateNiceMocks([MockSpec<ApiService>(), MockSpec<VocabularyService>()])
import "vocabulary_dataloader_test.mocks.dart";

void main() {
  group("VocabularyDataLoader", () {
    late VocabularyDataLoader dataLoader;
    late MockApiService apiService;
    late MockVocabularyService vocabularyService;
    late http.Response mockResponse;

    final List<Map<String, dynamic>> testVocabularyData =
        dummiesVocabulary
            .map((v) => v.toJson()..remove("kana_syllables"))
            .toList();

    setUpAll(() {
      apiService = MockApiService();
      vocabularyService = MockVocabularyService();

      locator.registerSingleton<ApiService>(apiService);
    });

    tearDownAll(() async {
      await unregister<ApiService>();
    });

    setUp(() async {
      dataLoader = VocabularyDataLoader(service: vocabularyService);

      mockResponse = http.Response(
        jsonEncode(testVocabularyData),
        HttpStatus.ok,
        headers: {"content-type": "application/json;charset=utf-8"},
      );

      // Set up the API service response for default vocabulary endpoint
      when(
        apiService.get("/v1/vocabulary"),
      ).thenAnswer((_) async => Future.value(mockResponse));

      // Set up response for version-specific endpoint
      when(
        apiService.get("/v1/vocabulary?version[current]=2025_01_01"),
      ).thenAnswer((_) async => Future.value(mockResponse));
    });

    tearDown(() {
      reset(apiService);
      reset(vocabularyService);
    });

    group("extractItems", () {
      test("should extract vocabulary items from successful response", () {
        final result = dataLoader.extractItems(mockResponse);

        expect(result.length, dummiesVocabulary.length);

        // Check that all expected vocabulary items are present
        for (final expected in dummiesVocabulary) {
          expect(
            result,
            containsOnce(expected),
            reason: "Should contain vocabulary with uid ${expected.uid.uid}",
          );
        }
      });

      test("should process and add kanaSyllables to vocabulary items", () {
        final result = dataLoader.extractItems(mockResponse);

        // The loader should add kanaSyllables from kana field
        for (final item in result) {
          final expectedSyllables =
              dummiesVocabulary
                  .firstWhere((v) => v.uid == item.uid)
                  .kanaSyllables;
          expect(item.kanaSyllables, expectedSyllables);
        }
      });

      test("should return empty list when response status is not 200", () {
        final errorResponse = http.Response("", HttpStatus.notFound);

        final result = dataLoader.extractItems(errorResponse);

        expect(result, isEmpty);
      });

      test("should handle empty response", () {
        final emptyResponse = http.Response("[]", HttpStatus.ok);

        final result = dataLoader.extractItems(emptyResponse);

        expect(result, isEmpty);
      });
    });

    group("loadCollection", () {
      test(
        "should fetch vocabulary with no version when forceReload is true",
        () async {
          when(
            vocabularyService.upsertAll(any, forceReload: true),
          ).thenAnswer((_) async => {});

          await dataLoader.loadCollection(
            latestVersion: "2025_01_01",
            forceReload: true,
          );

          verify(apiService.get("/v1/vocabulary")).called(1);
          verify(
            vocabularyService.upsertAll(dummiesVocabulary, forceReload: true),
          ).called(1);
        },
      );

      test(
        "should fetch vocabulary with version when forceReload is false",
        () async {
          when(
            // ignore: avoid_redundant_argument_values
            vocabularyService.upsertAll(any, forceReload: false),
          ).thenAnswer((_) async => {});

          await dataLoader.loadCollection(
            latestVersion: "2025_01_01",
            // ignore: avoid_redundant_argument_values
            forceReload: false,
          );

          verify(
            apiService.get("/v1/vocabulary?version[current]=2025_01_01"),
          ).called(1);
          verify(
            // ignore: avoid_redundant_argument_values
            vocabularyService.upsertAll(dummiesVocabulary, forceReload: false),
          ).called(1);
        },
      );

      test("should handle API error gracefully", () async {
        final errorResponse = http.Response("", HttpStatus.internalServerError);

        when(
          apiService.get("/v1/vocabulary?version[current]=2025_01_01"),
        ).thenAnswer((_) async => Future.value(errorResponse));

        when(
          // ignore: avoid_redundant_argument_values
          vocabularyService.upsertAll(any, forceReload: false),
        ).thenAnswer((_) async => {});

        await dataLoader.loadCollection(
          latestVersion: "2025_01_01",
          // ignore: avoid_redundant_argument_values
          forceReload: false,
        );

        verify(
          apiService.get("/v1/vocabulary?version[current]=2025_01_01"),
        ).called(1);
        // ignore: avoid_redundant_argument_values
        verify(vocabularyService.upsertAll([], forceReload: false)).called(1);
      });
    });

    test("end-to-end flow", () async {
      when(
        // ignore: avoid_redundant_argument_values
        vocabularyService.upsertAll(any, forceReload: false),
      ).thenAnswer((_) async => {});

      await dataLoader.loadCollection(latestVersion: "2025_01_01");

      verify(
        apiService.get("/v1/vocabulary?version[current]=2025_01_01"),
      ).called(1);

      // Capture the actual list passed to upsertAll
      final captured =
          verify(
                // ignore: avoid_redundant_argument_values
                vocabularyService.upsertAll(captureAny, forceReload: false),
              ).captured.first
              as List<Vocabulary>;

      expect(captured.length, 3);

      // Verify that specific vocabulary items were processed correctly
      for (final expected in dummiesVocabulary) {
        expect(captured.any((v) => v.uid.uid == expected.uid.uid), isTrue);
      }
    });
  });
}
