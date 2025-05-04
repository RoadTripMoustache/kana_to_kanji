import "dart:convert";
import "dart:io";

import "package:flutter_test/flutter_test.dart";
import "package:http/http.dart" as http;
import "package:kana_to_kanji/src/core/models/cleanup.dart";
import "package:kana_to_kanji/src/core/models/resources/resource_uid.dart";
import "package:kana_to_kanji/src/core/services/api_service.dart";
import "package:kana_to_kanji/src/core/services/database_service.dart";
import "package:kana_to_kanji/src/core/services/preferences_service.dart";
import "package:kana_to_kanji/src/core/services/resources/cleanup_service.dart";
import "package:kana_to_kanji/src/core/services/resources/group_service.dart";
import "package:kana_to_kanji/src/core/services/resources/kana_service.dart";
import "package:kana_to_kanji/src/core/services/resources/kanji_service.dart";
import "package:kana_to_kanji/src/core/services/resources/vocabulary_service.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:logger/logger.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";
import "package:sqflite/sqflite.dart";

import "../../../../helpers.dart";
@GenerateNiceMocks([
  MockSpec<Logger>(),
  MockSpec<PreferencesService>(),
  MockSpec<ApiService>(),
  MockSpec<DatabaseService>(),
  MockSpec<GroupService>(),
  MockSpec<KanaService>(),
  MockSpec<KanjiService>(),
  MockSpec<VocabularyService>(),
  MockSpec<Transaction>(),
  MockSpec<Batch>(),
])
import "cleanup_service_test.mocks.dart";

void main() {
  group("CleanUpService", () {
    final MockApiService apiServiceMock = MockApiService();
    final MockDatabaseService databaseServiceMock = MockDatabaseService();
    final MockGroupService groupServiceMock = MockGroupService();
    final MockKanaService kanaServiceMock = MockKanaService();
    final MockKanjiService kanjiServiceMock = MockKanjiService();
    final MockVocabularyService vocabularyServiceMock = MockVocabularyService();
    final MockPreferencesService preferencesServiceMock =
        MockPreferencesService();

    late CleanUpService service;
    late MockTransaction transactionMock;
    late MockBatch batchMock;

    late http.Response responseMock;

    // Sample resources for testing
    final sampleResources = [
      ResourceUid.fromJson("group-1"),
      ResourceUid.fromJson("kana-1"),
      ResourceUid.fromJson("kanji-1"),
      ResourceUid.fromJson("vocabulary-1"),
    ];

    setUpAll(() {
      locator
        ..registerSingleton<Logger>(MockLogger())
        ..registerSingleton<PreferencesService>(preferencesServiceMock)
        ..registerSingleton<ApiService>(apiServiceMock)
        ..registerSingleton<DatabaseService>(databaseServiceMock)
        ..registerSingleton<GroupService>(groupServiceMock)
        ..registerSingleton<KanaService>(kanaServiceMock)
        ..registerSingleton<KanjiService>(kanjiServiceMock)
        ..registerSingleton<VocabularyService>(vocabularyServiceMock);
    });

    tearDownAll(() async {
      await Future.wait([
        unregister<Logger>(),
        unregister<PreferencesService>(),
        unregister<ApiService>(),
        unregister<DatabaseService>(),
        unregister<GroupService>(),
        unregister<KanaService>(),
        unregister<KanjiService>(),
        unregister<VocabularyService>(),
      ]);
    });

    setUp(() async {
      transactionMock = MockTransaction();
      batchMock = MockBatch();

      service = CleanUpService();

      responseMock = http.Response("{\"deletedResources\": []}", HttpStatus.ok);

      // Mock API response
      when(
        apiServiceMock.get(argThat(startsWith("/v1/cleanup"))),
      ).thenAnswer((_) => Future.value(responseMock));

      // Default mock for database transaction
      when(databaseServiceMock.transaction(any)).thenAnswer((invocation) {
        final callback =
            invocation.positionalArguments[0]
                as Future<dynamic> Function(Transaction);
        return callback(transactionMock);
      });

      when(transactionMock.batch()).thenReturn(batchMock);
      // when(
      //   batchMock.commit(noResult: anyNamed('noResult')),
      // ).thenAnswer((_) async => []);
    });

    tearDown(() {
      reset(preferencesServiceMock);
      reset(apiServiceMock);
      reset(databaseServiceMock);
      reset(groupServiceMock);
      reset(kanaServiceMock);
      reset(kanjiServiceMock);
      reset(vocabularyServiceMock);
      reset(transactionMock);
      reset(batchMock);
    });

    group("_extractData", () {
      test("should correctly parse response with status 200", () async {
        // Create sample cleanup data
        final cleanupData = CleanUpData(deletedResources: sampleResources);
        responseMock = http.Response(jsonEncode(cleanupData), HttpStatus.ok);

        // Execute the cleanup
        await service.executeCleanUp(version: "2025_01_01");

        // Verify the deletion methods were called with correct resources
        verify(
          groupServiceMock.deleteAll([sampleResources[0]], batch: batchMock),
        ).called(1);

        verify(
          kanaServiceMock.deleteAll([sampleResources[1]], batch: batchMock),
        ).called(1);

        verify(
          kanjiServiceMock.deleteAll([sampleResources[2]], batch: batchMock),
        ).called(1);

        verify(
          vocabularyServiceMock.deleteAll([
            sampleResources[3],
          ], batch: batchMock),
        ).called(1);
      });

      test("should handle non-200 response by returning empty list", () async {
        // Mock API error response
        responseMock = http.Response("", HttpStatus.notFound);

        // Execute the cleanup
        await service.executeCleanUp(version: "2025_01_01");

        // Verify no deletion methods were called
        verifyNever(groupServiceMock.deleteAll(any, batch: anyNamed("batch")));
        verifyNever(kanaServiceMock.deleteAll(any, batch: anyNamed("batch")));
        verifyNever(kanjiServiceMock.deleteAll(any, batch: anyNamed("batch")));
        verifyNever(
          vocabularyServiceMock.deleteAll(any, batch: anyNamed("batch")),
        );
      });
    });

    group("_getResourceToCleanUp", () {
      test(
        "should build correct query parameter for non-forced with version",
        () async {
          final version = "2025_01_01";

          // Execute with version parameter
          await service.executeCleanUp(version: version);

          // Verify API was called with correct version parameter
          verify(
            apiServiceMock.get("/v1/cleanup?version[current]=$version"),
          ).called(1);
        },
      );
    });

    group("executeCleanUp", () {
      test("should correctly categorize resources by type", () async {
        // Create resources of different types
        final mixedResources = [
          ResourceUid.fromJson("group-1"),
          ResourceUid.fromJson("group-2"),
          ResourceUid.fromJson("kana-1"),
          ResourceUid.fromJson("kanji-1"),
          ResourceUid.fromJson("kanji-2"),
          ResourceUid.fromJson("vocabulary-1"),
        ];

        final cleanupData = CleanUpData(deletedResources: mixedResources);
        responseMock = http.Response(jsonEncode(cleanupData), HttpStatus.ok);

        // Execute the cleanup
        await service.executeCleanUp(version: "2025_01_01");

        // Verify the deletion methods were called with correctly categorized
        // resources
        verify(
          groupServiceMock.deleteAll([
            mixedResources[0],
            mixedResources[1],
          ], batch: batchMock),
        ).called(1);

        verify(
          kanaServiceMock.deleteAll([mixedResources[2]], batch: batchMock),
        ).called(1);

        verify(
          kanjiServiceMock.deleteAll([
            mixedResources[3],
            mixedResources[4],
          ], batch: batchMock),
        ).called(1);

        verify(
          vocabularyServiceMock.deleteAll([
            mixedResources[5],
          ], batch: batchMock),
        ).called(1);
      });

      test("should use database transaction for batch operations", () async {
        final cleanupData = CleanUpData(deletedResources: sampleResources);
        responseMock = http.Response(jsonEncode(cleanupData), HttpStatus.ok);

        // Execute the cleanup
        await service.executeCleanUp(version: "2025_01_01");

        // Verify transaction handling
        verify(databaseServiceMock.transaction(any)).called(1);
        verify(transactionMock.batch()).called(1);
        verify(batchMock.commit()).called(1);
      });

      test("should handle empty resource list", () async {
        final cleanupData = CleanUpData(deletedResources: []);
        responseMock = http.Response(jsonEncode(cleanupData), HttpStatus.ok);

        // Execute the cleanup
        await service.executeCleanUp(version: "2025_01_01");

        // Verify no deletion methods were called with any resources
        verifyZeroInteractions(groupServiceMock);
        verifyZeroInteractions(kanaServiceMock);
        verifyZeroInteractions(kanjiServiceMock);
        verifyZeroInteractions(vocabularyServiceMock);
      });
    });
  });
}
