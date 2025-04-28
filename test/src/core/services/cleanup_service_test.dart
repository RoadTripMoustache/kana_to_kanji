import "dart:convert";
import "dart:io";

import "package:flutter_test/flutter_test.dart";
import "package:http/http.dart" as http;
import "package:kana_to_kanji/src/core/models/cleanup.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";
import "package:kana_to_kanji/src/core/services/api_service.dart";
import "package:kana_to_kanji/src/core/services/cleanup_service.dart";
import "package:kana_to_kanji/src/core/services/database_service.dart";
import "package:kana_to_kanji/src/core/services/group_service.dart";
import "package:kana_to_kanji/src/core/services/kana_service.dart";
import "package:kana_to_kanji/src/core/services/kanji_service.dart";
import "package:kana_to_kanji/src/core/services/vocabulary_service.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";
import "package:sqflite/sqflite.dart";

@GenerateNiceMocks([
  MockSpec<ApiService>(),
  MockSpec<DatabaseService>(),
  MockSpec<GroupService>(),
  MockSpec<KanaService>(),
  MockSpec<KanjiService>(),
  MockSpec<VocabularyService>(),
  MockSpec<Transaction>(),
  MockSpec<Batch>(),
])
import "./cleanup_service_test.mocks.dart";

void main() {
  group("CleanUpService", () {
    late CleanUpService service;
    late MockApiService apiServiceMock;
    late MockDatabaseService databaseServiceMock;
    late MockGroupService groupServiceMock;
    late MockKanaService kanaServiceMock;
    late MockKanjiService kanjiServiceMock;
    late MockVocabularyService vocabularyServiceMock;
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
        ..registerSingleton<ApiService>(apiServiceMock = MockApiService())
        ..registerSingleton<DatabaseService>(
          databaseServiceMock = MockDatabaseService(),
        );
    });

    tearDownAll(() async {
      await locator.unregister<ApiService>();
      await locator.unregister<DatabaseService>();
    });

    setUp(() async {
      groupServiceMock = MockGroupService();
      kanaServiceMock = MockKanaService();
      kanjiServiceMock = MockKanjiService();
      vocabularyServiceMock = MockVocabularyService();
      transactionMock = MockTransaction();
      batchMock = MockBatch();

      service = CleanUpService(
        groupService: groupServiceMock,
        kanaService: kanaServiceMock,
        kanjiService: kanjiServiceMock,
        vocabularyService: vocabularyServiceMock,
      );

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
        await service.executeCleanUp();

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
        await service.executeCleanUp();

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
          // ignore: avoid_redundant_argument_values
          await service.executeCleanUp(forceReload: false, version: version);

          // Verify API was called with correct version parameter
          verify(
            apiServiceMock.get("/v1/cleanup?version[current]=$version"),
          ).called(1);
        },
      );

      test(
        "should not include version query when forceReload is true",
        () async {
          final version = "2025_01_01";

          // Execute with forceReload = true
          await service.executeCleanUp(forceReload: true, version: version);

          // Verify API was called without version parameter
          verify(apiServiceMock.get("/v1/cleanup")).called(1);
        },
      );

      test("should not include version query when version is null", () async {
        // Execute without version
        // ignore: avoid_redundant_argument_values
        await service.executeCleanUp(forceReload: false, version: null);

        // Verify API was called without version parameter
        verify(apiServiceMock.get("/v1/cleanup")).called(1);
      });
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
        await service.executeCleanUp();

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
        await service.executeCleanUp();

        // Verify transaction handling
        verify(databaseServiceMock.transaction(any)).called(1);
        verify(transactionMock.batch()).called(1);
        verify(batchMock.commit()).called(1);
      });

      test("should handle empty resource list", () async {
        final cleanupData = CleanUpData(deletedResources: []);
        responseMock = http.Response(jsonEncode(cleanupData), HttpStatus.ok);

        // Execute the cleanup
        await service.executeCleanUp();

        // Verify no deletion methods were called with any resources
        verifyZeroInteractions(groupServiceMock);
        verifyZeroInteractions(kanaServiceMock);
        verifyZeroInteractions(kanjiServiceMock);
        verifyZeroInteractions(vocabularyServiceMock);
      });
    });
  });
}
