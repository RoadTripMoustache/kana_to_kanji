import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/constants/alphabets.dart";
import "package:kana_to_kanji/src/core/dataloaders/resource_dataloader.dart";
import "package:kana_to_kanji/src/core/models/group.dart";
import "package:kana_to_kanji/src/core/models/paginated_response.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";
import "package:kana_to_kanji/src/core/services/database_service.dart";
import "package:kana_to_kanji/src/core/services/group_service.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:logger/logger.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

import "../../../dummies/group.dart";
import "../../../helpers.dart";

@GenerateNiceMocks([MockSpec<ResourceDataLoader>(), MockSpec<Logger>()])
import "group_service_test.mocks.dart";

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late final DatabaseService databaseService;
  late GroupService service;
  late MockResourceDataLoader<Group> mockDataLoader;
  late MockLogger mockLogger;

  group("GroupService", () {
    setUpAll(() async {
      databaseService = await setupDatabaseService();
      mockLogger = MockLogger();

      locator.registerSingleton<Logger>(mockLogger);
    });

    setUp(() async {
      // Create mock data loader
      mockDataLoader = MockResourceDataLoader<Group>();

      // Create the service to test with mock data loader
      service = GroupService(dataLoader: mockDataLoader);

      await databaseService.rawQuery(sqlInsertDummiesGroups);
    });

    tearDown(() async {
      await databaseService.rawQuery("DELETE FROM ${service.tableName};");
      reset(mockDataLoader);
    });

    tearDownAll(() async {
      await unregister<DatabaseService>();
      await unregister<Logger>();
    });

    group("getAll", () {
      test("should return all groups", () async {
        final groups = await service.getAll();

        expect(groups, isNotEmpty);
        expect(groups.length, 3);

        // Verify we have the expected group types
        final hiraganaGroups =
            groups.where((g) => g.alphabet == Alphabets.hiragana).toList();
        final katakanaGroups =
            groups.where((g) => g.alphabet == Alphabets.katakana).toList();
        final kanjiGroups =
            groups.where((g) => g.alphabet == Alphabets.kanji).toList();

        expect(hiraganaGroups.length, 1);
        expect(katakanaGroups.length, 1);
        expect(kanjiGroups.length, 1);
      });
    });

    group("getGroups", () {
      test("should return only hiragana groups", () async {
        final groups = await service.getGroups(Alphabets.hiragana);

        expect(groups, isNotEmpty);
        expect(groups.length, 1);
        expect(groups[0], dummyHiraganaGroup);
      });

      test("should return only katakana groups", () async {
        final groups = await service.getGroups(Alphabets.katakana);

        expect(groups, isNotEmpty);
        expect(groups.length, 1);
        expect(groups[0], dummyKatakanaGroup);
      });

      test("should return only kanji groups", () async {
        final groups = await service.getGroups(Alphabets.kanji);

        expect(groups, isNotEmpty);
        expect(groups.length, 1);
        expect(groups[0], dummyKanjiGroup);
      });
    });

    group("get", () {
      test("should return a specific group by uid", () async {
        final group = await service.get(dummyHiraganaGroup.uid);

        expect(group, isNotNull);
        expect(group, dummyHiraganaGroup);
      });

      test("should throw an error if not found", () async {
        expect(
          () async => await service.get(ResourceUid.fromJson("group-notFound")),
          throwsException,
        );
      });
    });

    group("upsert", () {
      test("should insert a new group", () async {
        final uid = dummyKatakanaGroup.uid.copyWith(uid: "group-new");
        final newGroup = dummyKatakanaGroup.copyWith(uid: uid);

        await service.upsert(newGroup);
        final retrievedGroup = await service.get(newGroup.uid);

        expect(retrievedGroup, isNotNull);
        expect(retrievedGroup.uid.uid, equals(newGroup.uid.uid));
        expect(retrievedGroup.name, equals(newGroup.name));
      });

      test("should update an existing group", () async {
        final updatedGroup = dummyHiraganaGroup.copyWith(
          name: "Updated Group Name",
          localizedName: "Updated Localized Name",
        );

        await service.upsert(updatedGroup);
        final retrievedGroup = await service.get(dummyHiraganaGroup.uid);

        expect(retrievedGroup, isNotNull);
        expect(retrievedGroup.name, equals(updatedGroup.name));
        expect(
          retrievedGroup.localizedName,
          equals(updatedGroup.localizedName),
        );
      });
    });

    group("upsertAll", () {
      test("should insert multiple new groups", () async {
        final newGroups = [
          dummyHiraganaGroup.copyWith(uid: ResourceUid.fromJson("group-new1")),
          dummyKatakanaGroup.copyWith(uid: ResourceUid.fromJson("group-new2")),
        ];

        await service.upsertAll(newGroups);
        final retrievedGroups = await service.getAll();

        expect(retrievedGroups.length, 5); // 3 initial + 2 new
        expect(retrievedGroups.any((g) => g.uid.uid == "group-new1"), isTrue);
        expect(retrievedGroups.any((g) => g.uid.uid == "group-new2"), isTrue);
      });

      test("should update existing groups", () async {
        final updatedGroups = [
          dummyHiraganaGroup.copyWith(name: "Updated Hiragana Group"),
          dummyKatakanaGroup.copyWith(name: "Updated Katakana Group"),
        ];

        await service.upsertAll(updatedGroups);
        final retrievedGroups = await service.getAll();

        expect(retrievedGroups.length, 3); // No new groups added
        expect(
          retrievedGroups.any((g) => g.name == "Updated Hiragana Group"),
          isTrue,
        );
        expect(
          retrievedGroups.any((g) => g.name == "Updated Katakana Group"),
          isTrue,
        );
      });

      test("should handle force reload parameter", () async {
        final uid1 = ResourceUid.fromJson("group-reload1");
        final uid2 = ResourceUid.fromJson("group-reload2");

        final newGroups = [
          dummyHiraganaGroup.copyWith(uid: uid1, name: "Reload 1"),
          dummyHiraganaGroup.copyWith(uid: uid2, name: "Reload 2"),
        ];

        await service.upsertAll(newGroups, forceReload: true);

        // Get all groups to check if only new ones exist
        final groups = await service.getAll();

        expect(groups.length, 2);
        expect(groups, containsAll(newGroups));
      });
    });

    group("delete", () {
      test("should remove a group", () async {
        await service.delete(dummyKatakanaGroup.uid);

        expect(
          () async => await service.get(dummyKatakanaGroup.uid),
          throwsException,
          reason: "should throw an exception when trying to get deleted group",
        );

        // Verify other groups still exist
        final remainingGroups = await service.getAll();
        expect(remainingGroups.length, 2); // One less than seed data (3)
        expect(
          remainingGroups.where((g) => g.uid == dummyKatakanaGroup.uid).isEmpty,
          isTrue,
        );
      });
    });

    group("deleteAll", () {
      test("should remove multiple groups", () async {
        final groupsToDelete = [dummyHiraganaGroup.uid, dummyKatakanaGroup.uid];

        await service.deleteAll(groupsToDelete);

        // Verify the deleted groups no longer exist
        for (final uid in groupsToDelete) {
          expect(
            () async => await service.get(uid),
            throwsException,
            reason:
                "should throw an exception when trying to get deleted group",
          );
        }

        // Verify only the non-deleted group still exists
        final remainingGroups = await service.getAll();
        expect(remainingGroups.length, 1); // Only kanji group should remain
        expect(remainingGroups[0], dummyKanjiGroup);
      });

      test("should handle empty list", () async {
        await service.deleteAll([]);

        // Verify all groups still exist
        final remainingGroups = await service.getAll();
        expect(remainingGroups.length, 3);
      });
    });

    group("latestVersion", () {
      test("should return the latest version from the database", () async {
        // The test data already has groups with versions
        final latestVersion = await service.latestVersion;

        // Verify that a version is returned
        expect(latestVersion, isNotNull);
        expect(latestVersion, isA<String>());
      });

      test("should return null when no groups exist", () async {
        // Delete all groups
        await databaseService.rawQuery("DELETE FROM ${service.tableName};");

        // Check that latestVersion returns null
        final latestVersion = await service.latestVersion;
        expect(latestVersion, isNull);
      });
    });

    group("sync", () {
      final apiGroups = [
        dummyHiraganaGroup.copyWith(name: "API Hiragana Group"),
        dummyKatakanaGroup.copyWith(name: "API Katakana Group"),
        dummyKanjiGroup.copyWith(name: "API Kanji Group"),
      ];

      PaginatedList<Group> pageResult = PaginatedList<Group>(
        hasMore: false,
        data: apiGroups,
      );

      setUp(() async {
        pageResult = PaginatedList<Group>(hasMore: false, data: apiGroups);
        when(
          mockDataLoader.fetchAll(latestVersion: anyNamed("latestVersion")),
        ).thenAnswer((_) async => pageResult);
      });

      test("should fetch and save groups from API", () async {
        await service.sync();

        verify(mockDataLoader.fetchAll(latestVersion: null)).called(1);

        // Verify that all groups were saved
        final savedGroups = await service.getAll();
        expect(savedGroups.length, apiGroups.length);

        // Verify names were updated
        expect(savedGroups, containsAll(apiGroups));
      });

      test(
        "should fetch with version parameter when doing forceReload",
        () async {
          pageResult = PaginatedList<Group>(hasMore: false, data: []);
          // The version will be determined by what's in the database
          final version = await service.latestVersion;

          await service.sync(forceReload: true);

          verify(mockDataLoader.fetchAll(latestVersion: version)).called(1);

          // Verify that database was cleared
          final savedGroups = await service.getAll();
          expect(savedGroups.length, 0);
        },
      );

      test("should handle paginated responses", () async {
        final newGroups = [
          dummyKanjiGroup.copyWith(
            uid: ResourceUid.fromJson("group-apiNew"),
            name: "API Kanji Group",
          ),
        ];

        // Create second page object
        final secondPageResult = PaginatedList<Group>(
          hasMore: false,
          data: newGroups,
        );

        // Create first page with next function that returns second page
        pageResult = PaginatedList<Group>(
          hasMore: true,
          data: apiGroups,
          next: () async => secondPageResult,
        );

        // Configure mock
        when(
          mockDataLoader.fetchAll(latestVersion: null),
        ).thenAnswer((_) async => pageResult);

        await service.sync();

        verify(mockDataLoader.fetchAll(latestVersion: null)).called(1);

        // Verify all groups were saved (both pages)
        final savedGroups = await service.getAll();
        expect(savedGroups.length, apiGroups.length + newGroups.length);
        expect(savedGroups, containsAll(apiGroups));
        expect(savedGroups, containsAll(newGroups));
      });
    });
  });
}
