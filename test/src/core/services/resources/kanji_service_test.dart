import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/dataloaders/kanji_dataloader.dart";
import "package:kana_to_kanji/src/core/models/paginated_data.dart";
import "package:kana_to_kanji/src/core/models/resources/kanji.dart";
import "package:kana_to_kanji/src/core/models/resources/resource_uid.dart";
import "package:kana_to_kanji/src/core/services/database_service.dart";
import "package:kana_to_kanji/src/core/services/resources/group_service.dart"
    as groups;
import "package:kana_to_kanji/src/core/services/resources/kanji_service.dart";
import "package:kana_to_kanji/src/core/services/resources/vocabulary_service.dart"
    as vocab;
import "package:kana_to_kanji/src/locator.dart";
import "package:logger/logger.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";
import "package:sqflite/sqflite.dart";
import "package:sqflite/utils/utils.dart";

import "../../../../dummies/dummies.dart";
import "../../../../helpers.dart";
@GenerateNiceMocks([MockSpec<KanjiDataLoader>(), MockSpec<Logger>()])
import "kanji_service_test.mocks.dart";

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late final DatabaseService databaseService;
  late KanjiService service;
  late KanjiDataLoader mockDataLoader;
  late MockLogger mockLogger;

  group("KanjiService", () {
    setUpAll(() async {
      databaseService = await setupDatabaseService();
      mockLogger = MockLogger();

      locator.registerSingleton<Logger>(mockLogger);
    });

    setUp(() async {
      // Create mock data loader
      mockDataLoader = MockKanjiDataLoader();

      // Create the service to test with mock data loader
      service = KanjiService(dataLoader: mockDataLoader);

      await databaseService.transaction((txn) async {
        final Batch batch = txn.batch();

        sqlInsertDummiesKanji.split(";").forEach((sql) {
          batch.execute(sql.trim());
        });

        await batch.commit(noResult: true);
      });
    });

    tearDown(() async {
      await databaseService.transaction((txn) async {
        final Batch batch =
            txn.batch()
              ..delete(service.tableName)
              ..delete(groups.sqlGroupsTable)
              ..delete(vocab.sqlVocabularyTable)
              ..delete(sqlKanjiGroupsTable)
              ..delete(sqlRelatedVocabularyTable);

        await batch.commit(noResult: true);
      });
      reset(mockDataLoader);
    });

    tearDownAll(() async {
      await unregister<DatabaseService>();
      await unregister<Logger>();
    });

    group("getAll", () {
      test("should return all kanji", () async {
        final kanjis = await service.getAll();

        expect(kanjis, isNotEmpty);
        expect(kanjis.length, dummiesKanji.length);

        expect(kanjis, containsAll(dummiesKanji));
      });
    });

    group("get", () {
      test("should return a specific kanji by uid", () async {
        final kanji = await service.get(dummyKanji.uid);

        expect(kanji, isNotNull);
        expect(kanji, dummyKanji);
      });

      test("should throw an error if not found", () async {
        expect(
          () async => await service.get(ResourceUid.fromJson("kanji-notFound")),
          throwsException,
        );
      });
    });

    group("upsert", () {
      test("should insert a new kanji", () async {
        final uid = dummyKanji.uid.copyWith(uid: "kanji-new");
        final newKanji = dummyKanji.copyWith(uid: uid);

        await service.upsert(newKanji);

        // Get all kanji to check if the new one was added
        final kanjis = await service.getAll();

        expect(kanjis.length, dummiesKanji.length + 1);
        expect(kanjis, contains(newKanji));
      });

      test("should update an existing kanji", () async {
        final updatedKanji = dummyKanji.copyWith(
          mainMeaning: "updated-meaning",
        );

        await service.upsert(updatedKanji);

        // Get the updated kanji
        final kanji = await service.get(dummyKanji.uid);

        expect(kanji, updatedKanji);
      });

      test("should update related vocabulary and groups", () async {
        final kanjiWithRelations = dummyKanji.copyWith(
          relatedVocabulary: dummyKanjiWithRelatedData.relatedVocabulary,
          groups: dummyKanjiWithRelatedData.groups,
        );

        await service.upsert(kanjiWithRelations);

        // Get the updated kanji with relations
        final kanji = await service.get(dummyKanji.uid);

        expect(kanji, kanjiWithRelations);
      });
    });

    group("upsertAll", () {
      test("should insert multiple new kanji", () async {
        final uid1 = ResourceUid.fromJson("kanji-batch1");
        final uid2 = ResourceUid.fromJson("kanji-batch2");

        final newKanjis = [
          dummyKanji.copyWith(uid: uid1, kanji: "新"),
          dummyKanji.copyWith(uid: uid2, kanji: "語"),
        ];

        await service.upsertAll(newKanjis);

        // Get all kanji to check if the new ones were added
        final kanjis = await service.getAll();

        expect(kanjis.length, dummiesKanji.length + newKanjis.length);
        expect(kanjis, containsAll(newKanjis));
      });

      test("should update multiple existing kanji", () async {
        final updatedKanjis = [
          dummyKanji.copyWith(mainMeaning: "book-updated"),
          dummyKanjiWithRelatedData.copyWith(mainMeaning: "origin-updated"),
        ];

        await service.upsertAll(updatedKanjis);

        // Get updated kanji
        final kanji1 = await service.get(dummyKanji.uid);
        final kanji2 = await service.get(dummyKanjiWithRelatedData.uid);

        expect(kanji1, updatedKanjis[0]);
        expect(kanji2, updatedKanjis[1]);
      });

      test("should handle force reload parameter", () async {
        final uid1 = ResourceUid.fromJson("kanji-reload1");
        final uid2 = ResourceUid.fromJson("kanji-reload2");

        final newKanji = [
          dummyKanji.copyWith(uid: uid1, kanji: "天"),
          dummyKanji.copyWith(uid: uid2, kanji: "地"),
        ];

        await service.upsertAll(newKanji, forceReload: true);

        // Get all kanji to check if only new ones exist
        final kanji = await service.getAll();

        expect(kanji.length, 2);
        expect(kanji, containsAll(newKanji));
      });
    });

    group("delete", () {
      test("should remove a kanji", () async {
        await service.delete(dummyKanji.uid);

        // Get all kanji to verify deletion
        final kanjis = await service.getAll();

        expect(kanjis.length, dummiesKanji.length - 1);
        expect(kanjis, isNot(contains(dummyKanji)));
      });

      test("should remove related data when kanji is deleted", () async {
        await service.delete(dummyKanjiWithRelatedData.uid);

        // Check if related data is removed
        final relatedVocabularyCount = await databaseService.query(
          sqlRelatedVocabularyTable,
          columns: [sqlCountColumn],
          where: "$sqlKanjiUidColumn = ?",
          whereArgs: [dummyKanjiWithRelatedData.uid.uid],
        );

        final groupsCount = await databaseService.query(
          sqlKanjiGroupsTable,
          columns: [sqlCountColumn],
          where: "$sqlKanjiUidColumn = ?",
          whereArgs: [dummyKanjiWithRelatedData.uid.uid],
        );

        expect(relatedVocabularyCount.first[sqlCountColumn], 0);
        expect(groupsCount.first[sqlCountColumn], 0);
      });
    });

    group("deleteAll", () {
      test("should remove multiple kanji", () async {
        final kanjiToDelete = [dummyKanji.uid];

        await service.deleteAll(kanjiToDelete);

        // Get all kanji to verify deletion
        final kanjis = await service.getAll();
        expect(kanjis.length, dummiesKanji.length - kanjiToDelete.length);

        // Verify each kanji no longer exists
        for (final uid in kanjiToDelete) {
          expect(
            () async => await service.get(uid),
            throwsException,
            reason:
                "should throw an exception when trying to get deleted kanji",
          );
        }

        // Verify the remaining kanji is still there
        expect(kanjis, contains(dummyKanjiWithRelatedData));
      });

      test(
        "should remove related data when multiple kanji are deleted",
        () async {
          final kanjiToDelete = [dummyKanjiWithRelatedData.uid];

          await service.deleteAll(kanjiToDelete);

          // Check if related data is removed
          final relatedVocabularyCount = await databaseService.query(
            sqlRelatedVocabularyTable,
            columns: [sqlCountColumn],
            where: "$sqlKanjiUidColumn = ?",
            whereArgs: [dummyKanjiWithRelatedData.uid.uid],
          );

          final groupsCount = await databaseService.query(
            sqlKanjiGroupsTable,
            columns: [sqlCountColumn],
            where: "$sqlKanjiUidColumn = ?",
            whereArgs: [dummyKanjiWithRelatedData.uid.uid],
          );

          expect(relatedVocabularyCount.first[sqlCountColumn], 0);
          expect(groupsCount.first[sqlCountColumn], 0);
        },
      );

      test("should handle empty list", () async {
        await service.deleteAll([]);

        // Verify all kanji still exist
        final kanjis = await service.getAll();
        expect(kanjis.length, dummiesKanji.length); // All kanji should remain
      });
    });

    group("latestVersion", () {
      test("should return the latest version from the database", () async {
        // The test data already has kanji with versions
        final latestVersion = await service.latestVersion;

        // Verify that a version is returned
        expect(latestVersion, isNotNull);
        expect(latestVersion, isA<String>());
      });

      test("should return null when no kanji exist", () async {
        // Delete all kanji
        await databaseService.delete(service.tableName);

        // Check that latestVersion returns null
        final latestVersion = await service.latestVersion;
        expect(latestVersion, isNull);
      });
    });

    group("sync", () {
      final apiKanjis = [
        dummyKanji.copyWith(mainMeaning: "API Book"),
        dummyKanjiWithRelatedData.copyWith(mainMeaning: "API Fire"),
      ];

      PaginatedData<Kanji> pageResult = PaginatedData<Kanji>(data: apiKanjis);

      setUp(() async {
        pageResult = PaginatedData<Kanji>(data: apiKanjis);
        provideDummy<PaginatedData<Kanji>>(pageResult);
        when(
          mockDataLoader.fetchAll(latestVersion: anyNamed("latestVersion")),
        ).thenAnswer((_) async => pageResult);
      });

      test("should fetch and save kanji from API", () async {
        await service.sync();

        verify(mockDataLoader.fetchAll(latestVersion: null)).called(1);

        // Verify that all kanji were saved
        final savedKanji = await service.getAll();
        expect(savedKanji.length, apiKanjis.length);

        // Verify meanings were updated
        expect(savedKanji, containsAll(apiKanjis));
      });

      test(
        "should fetch with version parameter when doing forceReload",
        () async {
          pageResult = PaginatedData<Kanji>(data: []);
          // The version will be determined by what's in the database
          final version = await service.latestVersion;

          await service.sync(forceReload: true);

          verify(mockDataLoader.fetchAll(latestVersion: version)).called(1);

          // Verify that database was cleared
          final savedKanji = await service.getAll();
          expect(savedKanji.length, 0);
        },
      );

      test("should handle paginated responses", () async {
        final newKanjis = [
          dummyKanji.copyWith(
            uid: ResourceUid.fromJson("kanji-apiNew"),
            kanji: "年",
            mainMeaning: "Year",
          ),
        ];

        // Create second page object
        final secondPageResult = PaginatedData<Kanji>(data: newKanjis);

        // Create first page with next function that returns second page
        pageResult = PaginatedData<Kanji>(
          data: apiKanjis,
          next: () async => secondPageResult,
        );

        // Configure mock
        when(
          mockDataLoader.fetchAll(latestVersion: null),
        ).thenAnswer((_) async => pageResult);

        await service.sync();

        verify(mockDataLoader.fetchAll(latestVersion: null)).called(1);

        // Verify all kanji were saved (both pages)
        final savedKanji = await service.getAll();
        expect(savedKanji.length, apiKanjis.length + newKanjis.length);
        expect(savedKanji, containsAll(apiKanjis));
        expect(savedKanji, containsAll(newKanjis));
      });
    });
  });
}
