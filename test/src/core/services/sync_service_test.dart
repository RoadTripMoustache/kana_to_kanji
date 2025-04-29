import "dart:convert";

import "package:flutter_test/flutter_test.dart";
import "package:http/http.dart" as http;
import "package:kana_to_kanji/src/core/models/sync.dart";
import "package:kana_to_kanji/src/core/services/api_service.dart";
import "package:kana_to_kanji/src/core/services/cleanup_service.dart";
import "package:kana_to_kanji/src/core/services/group_service.dart";
import "package:kana_to_kanji/src/core/services/kana_service.dart";
import "package:kana_to_kanji/src/core/services/kanji_service.dart";
import "package:kana_to_kanji/src/core/services/resource_data_service.dart";
import "package:kana_to_kanji/src/core/services/sync_service.dart";
import "package:kana_to_kanji/src/core/services/vocabulary_service.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:logger/logger.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

@GenerateNiceMocks([
  MockSpec<ApiService>(),
  MockSpec<ResourceDataService>(),
  MockSpec<GroupService>(),
  MockSpec<KanaService>(),
  MockSpec<KanjiService>(),
  MockSpec<VocabularyService>(),
  MockSpec<CleanUpService>(),
  MockSpec<Logger>(),
])
import "./sync_service_test.mocks.dart";

void main() {
  group("SyncService", () {
    late SyncService service;
    final apiServiceMock = MockApiService();
    final cleanUpServiceMock = MockCleanUpService();
    final mockLogger = MockLogger();

    // Service instances with mocked data-services
    final MockGroupService groupServiceMock = MockGroupService();
    final MockKanaService kanaServiceMock = MockKanaService();
    final MockKanjiService kanjiServiceMock = MockKanjiService();
    final MockVocabularyService vocabularyServiceMock = MockVocabularyService();

    Sync syncMock = Sync(
      groups: true,
      kana: true,
      kanji: true,
      vocabulary: true,
      cleanup: true,
      // ignore: avoid_redundant_argument_values
      forceReload: false,
      achievements: true,
      learning: LearningSync(stages: true),
    );

    setUpAll(() {
      locator
        ..registerSingleton<ApiService>(apiServiceMock)
        ..registerSingleton<Logger>(mockLogger);
    });

    tearDownAll(() async {
      await locator.unregister<ApiService>();
      await locator.unregister<Logger>();
    });

    setUp(() async {
      // Create SyncService with mocked services
      service = SyncService(
        groupService: groupServiceMock,
        kanaService: kanaServiceMock,
        kanjiService: kanjiServiceMock,
        vocabularyService: vocabularyServiceMock,
        cleanUpService: cleanUpServiceMock,
      );

      syncMock = Sync(
        groups: true,
        kana: true,
        kanji: true,
        vocabulary: true,
        cleanup: true,
        // ignore: avoid_redundant_argument_values
        forceReload: true,
        achievements: true,
        learning: LearningSync(stages: true),
      );

      when(apiServiceMock.get(argThat(startsWith("/v1/sync")))).thenAnswer(
        (_) => Future.value(http.Response(jsonEncode(syncMock.toJson()), 200)),
      );

      for (final ResourceDataService service in [
        groupServiceMock,
        kanaServiceMock,
        kanjiServiceMock,
        vocabularyServiceMock,
      ]) {
        when(service.latestVersion).thenAnswer((_) async => "2025_01_01");
      }
    });

    tearDown(() {
      reset(cleanUpServiceMock);
      reset(groupServiceMock);
      reset(kanaServiceMock);
      reset(kanjiServiceMock);
      reset(vocabularyServiceMock);
      reset(apiServiceMock);
    });

    group("sync", () {
      test("should call data loaders based on sync configuration", () async {
        await service.sync();

        verifyInOrder([
          groupServiceMock.latestVersion,
          kanaServiceMock.latestVersion,
          kanjiServiceMock.latestVersion,
          vocabularyServiceMock.latestVersion,
          apiServiceMock.get("/v1/sync?version[current]=2025_01_01"),
          groupServiceMock.sync(forceReload: true),
          kanaServiceMock.sync(forceReload: true),
          kanjiServiceMock.sync(forceReload: true),
          vocabularyServiceMock.sync(forceReload: true),
          cleanUpServiceMock.executeCleanUp(
            forceReload: true,
            version: "2025_01_01",
          ),
        ]);

        [
          apiServiceMock,
          groupServiceMock,
          kanaServiceMock,
          kanjiServiceMock,
          vocabularyServiceMock,
          cleanUpServiceMock,
        ].forEach(verifyNoMoreInteractions);
      });

      test("should not call loaders for false sync flags", () async {
        syncMock = Sync(
          groups: false,
          kana: false,
          kanji: false,
          vocabulary: false,
          cleanup: false,
          // ignore: avoid_redundant_argument_values
          forceReload: false,
          achievements: false,
          learning: LearningSync(stages: false),
        );

        await service.sync();

        verifyNever(
          groupServiceMock.sync(forceReload: anyNamed("forceReload")),
        );
        verifyNever(kanaServiceMock.sync(forceReload: anyNamed("forceReload")));
        verifyNever(
          kanjiServiceMock.sync(forceReload: anyNamed("forceReload")),
        );
        verifyNever(
          vocabularyServiceMock.sync(forceReload: anyNamed("forceReload")),
        );
        verifyNever(
          cleanUpServiceMock.executeCleanUp(
            forceReload: anyNamed("forceReload"),
            version: anyNamed("version"),
          ),
        );
      });
    });

    group("_getSyncData", () {
      test(
        "should build correct query parameter from latest versions",
        () async {
          await service.sync();

          // Verify we called the API with the correct version parameter.
          // All data loaders should have `2025_01_01` as latestVersion.
          verify(
            apiServiceMock.get("/v1/sync?version[current]=2025_01_01"),
          ).called(1);
        },
      );

      test("should handle null versions", () async {
        for (final ResourceDataService service in [
          groupServiceMock,
          kanaServiceMock,
          kanjiServiceMock,
          vocabularyServiceMock,
        ]) {
          when(service.latestVersion).thenAnswer((_) async => null);
        }

        await service.sync();

        // Verify we called the API with no version parameter
        verify(apiServiceMock.get("/v1/sync")).called(1);
        verify(groupServiceMock.sync(forceReload: anyNamed("forceReload")));
        verify(kanaServiceMock.sync(forceReload: anyNamed("forceReload")));
        verify(kanjiServiceMock.sync(forceReload: anyNamed("forceReload")));
        verify(
          vocabularyServiceMock.sync(forceReload: anyNamed("forceReload")),
        );
      });

      group("should use highest version for query parameter", () {
        const version = "2025_01_30";

        test("group", () async {
          when(groupServiceMock.latestVersion).thenAnswer((_) async => version);

          await service.sync();

          // Verify we called the API with the highest version parameter
          verify(
            apiServiceMock.get("/v1/sync?version[current]=$version"),
          ).called(1);
        });

        test("kana", () async {
          when(kanaServiceMock.latestVersion).thenAnswer((_) async => version);

          await service.sync();

          // Verify we called the API with the highest version parameter
          verify(
            apiServiceMock.get("/v1/sync?version[current]=$version"),
          ).called(1);
        });

        test("kanji", () async {
          when(kanjiServiceMock.latestVersion).thenAnswer((_) async => version);

          await service.sync();

          // Verify we called the API with the highest version parameter
          verify(
            apiServiceMock.get("/v1/sync?version[current]=$version"),
          ).called(1);
        });

        test("vocabulary", () async {
          when(
            vocabularyServiceMock.latestVersion,
          ).thenAnswer((_) async => version);

          await service.sync();

          // Verify we called the API with the highest version parameter
          verify(
            apiServiceMock.get("/v1/sync?version[current]=$version"),
          ).called(1);
        });
      });
    });

    group("_extractData", () {
      test("should correctly parse response with status 200", () async {
        syncMock = Sync(
          groups: true,
          kana: false,
          kanji: true,
          vocabulary: false,
          cleanup: true,
          // ignore: avoid_redundant_argument_values
          forceReload: false,
          achievements: true,
          learning: LearningSync(stages: true),
        );

        when(apiServiceMock.get(any)).thenAnswer(
          (_) =>
              Future.value(http.Response(jsonEncode(syncMock.toJson()), 200)),
        );

        await service.sync();

        // Verify that only the services with true flags were called
        verify(
          groupServiceMock.sync(
            // ignore: avoid_redundant_argument_values
            forceReload: false,
          ),
        ).called(1);
        verify(
          kanjiServiceMock.sync(
            // ignore: avoid_redundant_argument_values
            forceReload: false,
          ),
        ).called(1);
        verify(
          cleanUpServiceMock.executeCleanUp(
            // ignore: avoid_redundant_argument_values
            forceReload: false,
            version: anyNamed("version"),
          ),
        ).called(1);

        // Verify that services with false flags were not called
        verifyNever(kanaServiceMock.sync(forceReload: anyNamed("forceReload")));
        verifyNever(
          vocabularyServiceMock.sync(forceReload: anyNamed("forceReload")),
        );
      });

      test("should handle 404 response by setting all flags to true", () async {
        when(
          apiServiceMock.get(any),
        ).thenAnswer((_) => Future.value(http.Response("Not Found", 404)));

        await service.sync();

        // Verify all loaders were called with forceReload true
        verify(groupServiceMock.sync(forceReload: true)).called(1);
        verify(kanaServiceMock.sync(forceReload: true)).called(1);
        verify(kanjiServiceMock.sync(forceReload: true)).called(1);
        verify(vocabularyServiceMock.sync(forceReload: true)).called(1);
        verify(
          cleanUpServiceMock.executeCleanUp(
            forceReload: true,
            version: anyNamed("version"),
          ),
        ).called(1);
      });

      test(
        "should handle other error responses by setting all flags to false",
        () async {
          when(
            apiServiceMock.get(any),
          ).thenAnswer((_) => Future.value(http.Response("Server Error", 500)));

          await service.sync();

          // Verify no loaders were called since all flags should be false
          verifyNever(
            groupServiceMock.sync(forceReload: anyNamed("forceReload")),
          );
          verifyNever(
            kanaServiceMock.sync(forceReload: anyNamed("forceReload")),
          );
          verifyNever(
            kanjiServiceMock.sync(forceReload: anyNamed("forceReload")),
          );
          verifyNever(
            vocabularyServiceMock.sync(forceReload: anyNamed("forceReload")),
          );
          verifyNever(
            cleanUpServiceMock.executeCleanUp(
              forceReload: anyNamed("forceReload"),
              version: anyNamed("version"),
            ),
          );
        },
      );
    });
  });
}
