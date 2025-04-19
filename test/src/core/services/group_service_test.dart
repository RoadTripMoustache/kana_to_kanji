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
  late GroupService groupService;

  setUpAll(() async {
    databaseService = await setupDatabaseService();
  });

  setUp(() async {
    // Create the service to test
    groupService = GroupService();
    await databaseService.transaction((txn) async {
      final batch =
          txn.batch()
            ..insert(groupService.tableName, dummyKatakanaGroup.toJson())
            ..insert(groupService.tableName, dummyHiraganaGroup.toJson())
            ..insert(groupService.tableName, dummyKanjiGroup.toJson());

      await batch.commit(noResult: true);
    });
  });

  tearDown(() async {
    await databaseService.rawQuery("DELETE FROM ${groupService.tableName};");
  });

  group("GroupService", () {
    group("getAll", () {
      test("should return all groups", () async {
        final groups = await groupService.getAll();

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
        final groups = await groupService.getGroups(Alphabets.hiragana);

        // Assert
        expect(groups, isNotEmpty);
        expect(groups.length, 1);
        expect(groups[0], dummyHiraganaGroup);
      });

      test("should return only katakana groups", () async {
        // Act
        final groups = await groupService.getGroups(Alphabets.katakana);

        // Assert
        expect(groups, isNotEmpty);
        expect(groups.length, 1);
        expect(groups[0], dummyKatakanaGroup);
      });

      test("should return only kanji groups", () async {
        // Act
        final groups = await groupService.getGroups(Alphabets.kanji);

        // Assert
        expect(groups, isNotEmpty);
        expect(groups.length, 1);
        expect(groups[0], dummyKanjiGroup);
      });
    });

    group("get", () {
      test("should return a specific group by uid", () async {
        final group = await groupService.get(dummyHiraganaGroup.uid);

        expect(group, isNotNull);
        expect(group, dummyHiraganaGroup);
      });

      test("should throw an error if not found", () async {
        expect(
          () async =>
              await groupService.get(ResourceUid.fromJson("group-notFound")),
          throwsException,
        );
      });
    });

    group("upsert", () {
      test("should insert a new group", () async {
        // Arrange
        final uid = dummyKatakanaGroup.uid.copyWith(uid: "group-new");
        final newGroup = dummyKatakanaGroup.copyWith(uid: uid);

        // Act
        await groupService.upsert(newGroup);
        final retrievedGroup = await groupService.get(newGroup.uid);

        // Assert
        expect(retrievedGroup, isNotNull);
        expect(retrievedGroup.uid.uid, equals(newGroup.uid.uid));
        expect(retrievedGroup.name, equals(newGroup.name));
      });

      test("should update an existing group", () async {
        final updatedGroup = dummyHiraganaGroup.copyWith(
          name: "Updated Group Name",
          localizedName: "Updated Localized Name",
        );

        await groupService.upsert(updatedGroup);
        final retrievedGroup = await groupService.get(dummyHiraganaGroup.uid);

        expect(retrievedGroup, isNotNull);
        expect(retrievedGroup.name, equals(updatedGroup.name));
        expect(
          retrievedGroup.localizedName,
          equals(updatedGroup.localizedName),
        );
      });
    });

    group("delete", () {
      test("should remove a group", () async {
        await groupService.delete(dummyKatakanaGroup.uid);

        expect(
          () async => await groupService.get(dummyKatakanaGroup.uid),
          throwsException,
          reason: "should throw an exception when trying to get deleted group",
        );

        // Verify other groups still exist
        final remainingGroups = await groupService.getAll();
        expect(remainingGroups.length, 2); // One less than seed data (3)
        expect(
          remainingGroups.where((g) => g.uid == dummyKatakanaGroup.uid).isEmpty,
          isTrue,
        );
      });
    });
  });
}
