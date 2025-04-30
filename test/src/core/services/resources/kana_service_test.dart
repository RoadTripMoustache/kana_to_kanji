import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/constants/alphabets.dart";
import "package:kana_to_kanji/src/core/dataloaders/resource_dataloader.dart";
import "package:kana_to_kanji/src/core/models/paginated_data.dart";
import "package:kana_to_kanji/src/core/models/resources/resources.dart";
import "package:kana_to_kanji/src/core/services/database_service.dart";
import "package:kana_to_kanji/src/core/services/resources/group_service.dart";
import "package:kana_to_kanji/src/core/services/resources/kana_service.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:logger/logger.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";
import "package:sqflite/sqflite.dart";

import "../../../../dummies/dummies.dart";
import "../../../../helpers.dart";

@GenerateNiceMocks([MockSpec<ResourceDataLoader>(), MockSpec<Logger>()])
import "kana_service_test.mocks.dart";

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late final DatabaseService databaseService;
  late KanaService service;
  late MockResourceDataLoader<Kana> mockDataLoader;
  late MockLogger mockLogger;

  group("KanaService", () {
    setUpAll(() async {
      databaseService = await setupDatabaseService();
      mockLogger = MockLogger();

      locator.registerSingleton<Logger>(mockLogger);
    });

    setUp(() async {
      // Create mock data loader
      mockDataLoader = MockResourceDataLoader<Kana>();

      // Create the service to test with mock data loader
      service = KanaService(dataLoader: mockDataLoader);

      await databaseService.transaction((txn) async {
        final Batch batch = txn.batch();

        sqlInsertDummiesKana.split(";").forEach((sql) {
          batch.execute(sql.trim());
        });

        await batch.commit(noResult: true);
      });
    });

    tearDown(() async {
      await databaseService.transaction((txn) async {
        await txn.delete(service.tableName);
        await txn.delete(sqlGroupsTable);
      });
      reset(mockDataLoader);
    });

    tearDownAll(() async {
      await unregister<DatabaseService>();
      await unregister<Logger>();
    });

    group("getByGroupIds", () {
      test("should return all kanas when given empty list", () async {
        final kanas = await service.getByGroupIds([]);

        expect(kanas, isNotEmpty);
        expect(kanas.length, 2);
      });

      test("should return kanas for specified group IDs", () async {
        final kanas = await service.getByGroupIds([dummyHiragana.groupUid]);

        expect(kanas, isNotEmpty);
        expect(kanas.length, 1);
        expect(kanas[0], dummyHiragana);
      });

      test("should return empty list for non-existent group IDs", () async {
        final kanas = await service.getByGroupIds([
          ResourceUid.fromJson("group-nonexisting"),
        ]);

        expect(kanas, isEmpty);
      });
    });

    group("getByGroupId", () {
      test("should return kanas for a single group ID", () async {
        final kanas = await service.getByGroupId(dummyHiragana.groupUid);

        expect(kanas, isNotEmpty);
        expect(kanas.length, 1);
        expect(kanas[0], dummyHiragana);
      });
    });

    group("get", () {
      test("should return a specific kana by uid", () async {
        final kana = await service.get(dummyHiragana.uid);

        expect(kana, isNotNull);
        expect(kana, dummyHiragana);
      });

      test("should throw an error if not found", () async {
        expect(
          () async => await service.get(ResourceUid.fromJson("kana-notFound")),
          throwsException,
        );
      });
    });

    group("getKana", () {
      test("should return only hiragana kanas", () async {
        final kanas = await service.getKana(Alphabets.hiragana);

        expect(kanas, isNotEmpty);
        expect(kanas.length, 1);
        expect(kanas[0], dummyHiragana);
      });

      test("should return only katakana kanas", () async {
        final kanas = await service.getKana(Alphabets.katakana);

        expect(kanas, isNotEmpty);
        expect(kanas.length, 1);
        expect(kanas[0], dummyKatakana);
      });
    });

    group("getHiragana", () {
      test("should return all hiragana kanas", () async {
        final kanas = await service.getHiragana();

        expect(kanas, isNotEmpty);
        expect(kanas.length, 1);
        expect(kanas[0], dummyHiragana);
      });
    });

    group("getKatakana", () {
      test("should return all katakana kanas", () async {
        final kanas = await service.getKatakana();

        expect(kanas, isNotEmpty);
        expect(kanas.length, 1);
        expect(kanas[0], dummyKatakana);
      });
    });

    group("upsert", () {
      test("should insert a new kana", () async {
        final uid = dummyKatakana.uid.copyWith(uid: "kana-new");
        final newKana = dummyKatakana.copyWith(uid: uid);

        await service.upsert(newKana);
        final retrievedKana = await service.get(newKana.uid);

        expect(retrievedKana, isNotNull);
        expect(retrievedKana.uid.uid, equals(newKana.uid.uid));
        expect(retrievedKana.kana, equals(newKana.kana));
      });

      test("should update an existing kana", () async {
        final updatedKana = dummyHiragana.copyWith(kana: "や", romaji: "ya");

        await service.upsert(updatedKana);
        final retrievedKana = await service.get(dummyHiragana.uid);

        expect(retrievedKana, isNotNull);
        expect(retrievedKana.kana, equals(updatedKana.kana));
        expect(retrievedKana.romaji, equals(updatedKana.romaji));
      });
    });

    group("upsertAll", () {
      test("should insert multiple new kanas", () async {
        final newKanas = [
          dummyHiragana.copyWith(uid: ResourceUid.fromJson("kana-new1")),
          dummyKatakana.copyWith(uid: ResourceUid.fromJson("kana-new2")),
        ];

        await service.upsertAll(newKanas);
        final retrievedKanas = await service.getAll();

        expect(retrievedKanas.length, 4); // 2 initial + 2 new
        expect(retrievedKanas.any((k) => k.uid.uid == "kana-new1"), isTrue);
        expect(retrievedKanas.any((k) => k.uid.uid == "kana-new2"), isTrue);
      });

      test("should update existing kanas", () async {
        final updatedKanas = [
          dummyHiragana.copyWith(kana: "は", romaji: "ha"),
          dummyKatakana.copyWith(kana: "ハ", romaji: "ha"),
        ];

        await service.upsertAll(updatedKanas);
        final retrievedKanas = await service.getAll();

        expect(retrievedKanas.length, 2); // No new kanas added
        expect(
          retrievedKanas.any((k) => k.kana == "は" && k.romaji == "ha"),
          isTrue,
        );
        expect(
          retrievedKanas.any((k) => k.kana == "ハ" && k.romaji == "ha"),
          isTrue,
        );
      });

      test("should handle force reload parameter", () async {
        final uid1 = ResourceUid.fromJson("kana-reload1");
        final uid2 = ResourceUid.fromJson("kana-reload2");

        final newKanas = [
          dummyHiragana.copyWith(uid: uid1, kana: "き", romaji: "ki"),
          dummyHiragana.copyWith(uid: uid2, kana: "く", romaji: "ku"),
        ];

        await service.upsertAll(newKanas, forceReload: true);

        // Get all kanas to check if only new ones exist
        final kanas = await service.getAll();

        expect(kanas.length, 2);
        expect(kanas, containsAll(newKanas));
      });
    });

    group("delete", () {
      test("should remove a kana", () async {
        await service.delete(dummyKatakana.uid);

        expect(
          () async => await service.get(dummyKatakana.uid),
          throwsException,
          reason: "should throw an exception when trying to get deleted kana",
        );

        // Verify other kanas still exist
        final remainingKanas = await service.getAll();
        expect(remainingKanas.length, 1); // One less than seed data (2)
        expect(
          remainingKanas.where((k) => k.uid == dummyKatakana.uid).isEmpty,
          isTrue,
        );
      });
    });

    group("deleteAll", () {
      test("should remove multiple kanas", () async {
        final kanasToDelete = [dummyHiragana.uid, dummyKatakana.uid];

        await service.deleteAll(kanasToDelete);

        // Verify the deleted kanas no longer exist
        for (final uid in kanasToDelete) {
          expect(
            () async => await service.get(uid),
            throwsException,
            reason: "should throw an exception when trying to get deleted kana",
          );
        }

        // Verify no kanas remain
        final remainingKanas = await service.getAll();
        expect(remainingKanas.length, 0);
      });

      test("should handle empty list", () async {
        await service.deleteAll([]);

        // Verify all kanas still exist
        final remainingKanas = await service.getAll();
        expect(remainingKanas.length, 2);
      });
    });

    group("latestVersion", () {
      test("should return the latest version from the database", () async {
        // The test data already has kanas with versions
        final latestVersion = await service.latestVersion;

        expect(latestVersion, isNotNull);
        expect(latestVersion, isA<String>());
      });

      test("should return null when no kanas exist", () async {
        await databaseService.delete(service.tableName);

        final latestVersion = await service.latestVersion;
        expect(latestVersion, isNull);
      });
    });

    group("sync", () {
      final apiKanas = [
        dummyHiragana.copyWith(kana: "わ", romaji: "wa"),
        dummyKatakana.copyWith(kana: "ワ", romaji: "wa"),
        Kana(
          uid: ResourceUid.fromJson("kana-new"),
          kana: "ん",
          romaji: "n",
          position: 2,
          groupUid: dummyHiragana.groupUid,
          alphabet: Alphabets.hiragana,
          version: "2023_01_01",
        ),
      ];

      PaginatedData<Kana> pageResult = PaginatedData<Kana>(data: apiKanas);

      setUp(() async {
        pageResult = PaginatedData<Kana>(data: apiKanas);
        provideDummy<PaginatedData<Kana>>(pageResult);
        when(
          mockDataLoader.fetchAll(latestVersion: anyNamed("latestVersion")),
        ).thenAnswer((_) async => pageResult);
      });

      test("should fetch and save kanas from API", () async {
        await service.sync();

        verify(mockDataLoader.fetchAll(latestVersion: null)).called(1);

        // Verify that all kanas were saved
        final savedKanas = await service.getAll();
        expect(savedKanas.length, apiKanas.length);

        // Verify data was updated
        expect(savedKanas, containsAll(apiKanas));
      });

      test(
        "should fetch with version parameter when doing forceReload",
        () async {
          pageResult = PaginatedData<Kana>(data: []);
          // The version will be determined by what's in the database
          final version = await service.latestVersion;

          await service.sync(forceReload: true);

          verify(mockDataLoader.fetchAll(latestVersion: version)).called(1);

          // Verify that database was cleared
          final savedKanas = await service.getAll();
          expect(savedKanas.length, 0);
        },
      );

      test("should handle paginated responses", () async {
        final newKanas = [
          Kana(
            uid: ResourceUid.fromJson("kana-apiNew"),
            kana: "を",
            romaji: "wo",
            position: 3,
            groupUid: dummyHiragana.groupUid,
            alphabet: Alphabets.hiragana,
            version: "2023_01_01",
          ),
        ];

        // Create second page object
        final secondPageResult = PaginatedData<Kana>(data: newKanas);

        // Create first page with next function that returns second page
        pageResult = PaginatedData<Kana>(
          data: apiKanas,
          next: () async => secondPageResult,
        );

        // Configure mock
        when(
          mockDataLoader.fetchAll(latestVersion: null),
        ).thenAnswer((_) async => pageResult);

        await service.sync();

        verify(mockDataLoader.fetchAll(latestVersion: null)).called(1);

        // Verify all kanas were saved (both pages)
        final savedKanas = await service.getAll();
        expect(savedKanas.length, apiKanas.length + newKanas.length);
        expect(savedKanas, containsAll(apiKanas));
        expect(savedKanas, containsAll(newKanas));
      });
    });
  });
}
