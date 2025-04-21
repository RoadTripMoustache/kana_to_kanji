import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/constants/alphabets.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";
import "package:kana_to_kanji/src/core/services/database_service.dart";
import "package:kana_to_kanji/src/core/services/group_service.dart";

import "../../../dummies/group.dart";
import "../../../helpers.dart";

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late final DatabaseService databaseService;
  late GroupService service;

  group("GroupService", () {
    setUpAll(() async {
      databaseService = await setupDatabaseService();
    });

    setUp(() async {
      // Create the service to test
      service = GroupService();

      await databaseService.rawQuery(sqlInsertDummiesGroups);
    });

    tearDown(() async {
      await databaseService.rawQuery("DELETE FROM ${service.tableName};");
    });

    tearDownAll(() async {
      await unregister<DatabaseService>();
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
        // Act
        final groups = await service.getGroups(Alphabets.hiragana);

        // Assert
        expect(groups, isNotEmpty);
        expect(groups.length, 1);
        expect(groups[0], dummyHiraganaGroup);
      });

      test("should return only katakana groups", () async {
        // Act
        final groups = await service.getGroups(Alphabets.katakana);

        // Assert
        expect(groups, isNotEmpty);
        expect(groups.length, 1);
        expect(groups[0], dummyKatakanaGroup);
      });

      test("should return only kanji groups", () async {
        // Act
        final groups = await service.getGroups(Alphabets.kanji);

        // Assert
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
        // Arrange
        final newGroups = [
          dummyHiraganaGroup.copyWith(uid: ResourceUid.fromJson("group-new1")),
          dummyKatakanaGroup.copyWith(uid: ResourceUid.fromJson("group-new2")),
        ];

        // Act
        await service.upsertAll(newGroups);
        final retrievedGroups = await service.getAll();

        // Assert
        expect(retrievedGroups.length, 5); // 3 initial + 2 new
        expect(retrievedGroups.any((g) => g.uid.uid == "group-new1"), isTrue);
        expect(retrievedGroups.any((g) => g.uid.uid == "group-new2"), isTrue);
      });

      test("should update existing groups", () async {
        // Arrange
        final updatedGroups = [
          dummyHiraganaGroup.copyWith(name: "Updated Hiragana Group"),
          dummyKatakanaGroup.copyWith(name: "Updated Katakana Group"),
        ];

        // Act
        await service.upsertAll(updatedGroups);
        final retrievedGroups = await service.getAll();

        // Assert
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
  });
}
