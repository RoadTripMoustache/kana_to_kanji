import "dart:convert";

import "package:flutter_test/flutter_test.dart";
import "package:http/http.dart" as http;
import "package:kana_to_kanji/src/core/dataloaders/kanji_dataloader.dart";
import "package:kana_to_kanji/src/core/dataloaders/resource_dataloader.dart";
import "package:kana_to_kanji/src/core/dataloaders/vocabulary_dataloader.dart";
import "package:kana_to_kanji/src/core/models/group.dart";
import "package:kana_to_kanji/src/core/models/kana.dart";
import "package:kana_to_kanji/src/core/models/sync.dart";
import "package:kana_to_kanji/src/core/services/api_service.dart";
import "package:kana_to_kanji/src/core/services/cleanup_service.dart";
import "package:kana_to_kanji/src/core/services/sync_service.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

@GenerateNiceMocks([
  MockSpec<ApiService>(),
  MockSpec<ResourceDataLoader>(),
  MockSpec<KanjiDataLoader>(),
  MockSpec<VocabularyDataLoader>(),
  MockSpec<CleanUpService>(),
])
import "./sync_service_test.mocks.dart";

void main() {
  group("SyncService", () {
    late SyncService service;
    final apiServiceMock = MockApiService();
    final cleanUpServiceMock = MockCleanUpService();
    final groupDataLoaderMock = MockResourceDataLoader<Group>();
    final kanaDataLoaderMock = MockResourceDataLoader<Kana>();
    final kanjiDataLoaderMock = MockKanjiDataLoader();
    final vocabularyDataLoaderMock = MockVocabularyDataLoader();

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
      locator.registerSingleton<ApiService>(apiServiceMock);
    });

    tearDownAll(() async {
      await locator.unregister<ApiService>();
    });

    setUp(() async {
      service = SyncService(
        cleanUpService: cleanUpServiceMock,
        groupDataLoader: groupDataLoaderMock,
        kanaDataLoader: kanaDataLoaderMock,
        kanjiDataLoader: kanjiDataLoaderMock,
        vocabularyDataLoader: vocabularyDataLoaderMock,
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

      for (final ResourceDataLoader loader in [
        groupDataLoaderMock,
        kanaDataLoaderMock,
        kanjiDataLoaderMock,
        vocabularyDataLoaderMock,
      ]) {
        when(
          loader.latestVersion,
        ).thenAnswer((_) async => Future.value("2025_01_01"));
      }
    });

    tearDown(() {
      reset(cleanUpServiceMock);
      reset(groupDataLoaderMock);
      reset(kanaDataLoaderMock);
      reset(kanjiDataLoaderMock);
      reset(vocabularyDataLoaderMock);
      reset(apiServiceMock);
    });

    group("sync", () {
      test("should call data loaders based on sync configuration", () async {
        await service.sync();

        verifyInOrder([
          groupDataLoaderMock.latestVersion,
          kanaDataLoaderMock.latestVersion,
          kanjiDataLoaderMock.latestVersion,
          vocabularyDataLoaderMock.latestVersion,
          apiServiceMock.get("/v1/sync?version[current]=2025_01_01"),
          groupDataLoaderMock.fetchAll(
            forceReload: true,
            latestVersion: "2025_01_01",
          ),
          kanaDataLoaderMock.fetchAll(
            forceReload: true,
            latestVersion: "2025_01_01",
          ),
          kanjiDataLoaderMock.fetchAll(
            forceReload: true,
            latestVersion: "2025_01_01",
          ),
          vocabularyDataLoaderMock.fetchAll(
            forceReload: true,
            latestVersion: "2025_01_01",
          ),
          cleanUpServiceMock.executeCleanUp(
            forceReload: true,
            version: "2025_01_01",
          ),
        ]);

        [
          apiServiceMock,
          groupDataLoaderMock,
          kanaDataLoaderMock,
          kanjiDataLoaderMock,
          vocabularyDataLoaderMock,
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
          groupDataLoaderMock.fetchAll(
            forceReload: anyNamed("forceReload"),
            latestVersion: anyNamed("latestVersion"),
          ),
        );
        verifyNever(
          kanaDataLoaderMock.fetchAll(
            forceReload: anyNamed("forceReload"),
            latestVersion: anyNamed("latestVersion"),
          ),
        );
        verifyNever(
          kanjiDataLoaderMock.fetchAll(
            forceReload: anyNamed("forceReload"),
            latestVersion: anyNamed("latestVersion"),
          ),
        );
        verifyNever(
          vocabularyDataLoaderMock.fetchAll(
            forceReload: anyNamed("forceReload"),
            latestVersion: anyNamed("latestVersion"),
          ),
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
        for (final ResourceDataLoader l in [
          groupDataLoaderMock,
          kanaDataLoaderMock,
          kanjiDataLoaderMock,
          vocabularyDataLoaderMock,
        ]) {
          when(l.latestVersion).thenAnswer((_) async => null);
        }

        await service.sync();

        // Verify we called the API with no version parameter
        verify(apiServiceMock.get("/v1/sync")).called(1);
        verify(
          groupDataLoaderMock.fetchAll(forceReload: anyNamed("forceReload")),
        );
        verify(
          kanaDataLoaderMock.fetchAll(forceReload: anyNamed("forceReload")),
        );
        verify(
          kanjiDataLoaderMock.fetchAll(forceReload: anyNamed("forceReload")),
        );
        verify(
          vocabularyDataLoaderMock.fetchAll(
            forceReload: anyNamed("forceReload"),
          ),
        );
      });

      group("should use highest version for query parameter", () {
        const version = "2025_01_30";

        test("group", () async {
          when(
            groupDataLoaderMock.latestVersion,
          ).thenAnswer((_) async => version);

          await service.sync();

          // Verify we called the API with the highest version parameter
          verify(
            apiServiceMock.get("/v1/sync?version[current]=$version"),
          ).called(1);
        });

        test("kana", () async {
          when(
            kanaDataLoaderMock.latestVersion,
          ).thenAnswer((_) async => version);

          await service.sync();

          // Verify we called the API with the highest version parameter
          verify(
            apiServiceMock.get("/v1/sync?version[current]=$version"),
          ).called(1);
        });

        test("kanji", () async {
          when(
            kanjiDataLoaderMock.latestVersion,
          ).thenAnswer((_) async => version);

          await service.sync();

          // Verify we called the API with the highest version parameter
          verify(
            apiServiceMock.get("/v1/sync?version[current]=$version"),
          ).called(1);
        });

        test("vocabulary", () async {
          when(
            vocabularyDataLoaderMock.latestVersion,
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
          groupDataLoaderMock.fetchAll(
            // ignore: avoid_redundant_argument_values
            forceReload: false,
            latestVersion: "2025_01_01",
          ),
        ).called(1);
        verify(
          kanjiDataLoaderMock.fetchAll(
            // ignore: avoid_redundant_argument_values
            forceReload: false,
            latestVersion: "2025_01_01",
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
        verifyNever(
          kanaDataLoaderMock.fetchAll(
            forceReload: anyNamed("forceReload"),
            latestVersion: anyNamed("latestVersion"),
          ),
        );
        verifyNever(
          vocabularyDataLoaderMock.fetchAll(
            forceReload: anyNamed("forceReload"),
            latestVersion: anyNamed("latestVersion"),
          ),
        );
      });

      test("should handle 404 response by setting all flags to true", () async {
        when(
          apiServiceMock.get(any),
        ).thenAnswer((_) => Future.value(http.Response("Not Found", 404)));

        await service.sync();

        // Verify all loaders were called with forceReload true
        verify(
          groupDataLoaderMock.fetchAll(
            forceReload: true,
            latestVersion: "2025_01_01",
          ),
        ).called(1);
        verify(
          kanaDataLoaderMock.fetchAll(
            forceReload: true,
            latestVersion: "2025_01_01",
          ),
        ).called(1);
        verify(
          kanjiDataLoaderMock.fetchAll(
            forceReload: true,
            latestVersion: "2025_01_01",
          ),
        ).called(1);
        verify(
          vocabularyDataLoaderMock.fetchAll(
            forceReload: true,
            latestVersion: "2025_01_01",
          ),
        ).called(1);
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
            groupDataLoaderMock.fetchAll(
              forceReload: anyNamed("forceReload"),
              latestVersion: anyNamed("latestVersion"),
            ),
          );
          verifyNever(
            kanaDataLoaderMock.fetchAll(
              forceReload: anyNamed("forceReload"),
              latestVersion: anyNamed("latestVersion"),
            ),
          );
          verifyNever(
            kanjiDataLoaderMock.fetchAll(
              forceReload: anyNamed("forceReload"),
              latestVersion: anyNamed("latestVersion"),
            ),
          );
          verifyNever(
            vocabularyDataLoaderMock.fetchAll(
              forceReload: anyNamed("forceReload"),
              latestVersion: anyNamed("latestVersion"),
            ),
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
