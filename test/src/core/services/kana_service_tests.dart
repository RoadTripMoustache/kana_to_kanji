import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/constants/alphabets.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";
import "package:kana_to_kanji/src/core/services/database_service.dart";
import "package:kana_to_kanji/src/core/services/kana_service.dart";
import "package:sqflite/sqflite.dart";

import "../../../dummies/dummies.dart";
import "../../../helpers.dart";

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late final DatabaseService databaseService;
  late KanaService service;

  setUpAll(() async {
    databaseService = await setupDatabaseService();
  });

  setUp(() async {
    // Create the service to test
    service = KanaService();
    await databaseService.transaction((txn) async {
      final batch =
          txn.batch()
            ..insert(
              "groups",
              dummyHiraganaGroup.toJson(),
              conflictAlgorithm: ConflictAlgorithm.ignore,
            )
            ..insert(
              "groups",
              dummyKatakanaGroup.toJson(),
              conflictAlgorithm: ConflictAlgorithm.ignore,
            )
            ..insert(service.tableName, dummyHiragana.toJson())
            ..insert(service.tableName, dummyKatakana.toJson());

      await batch.commit(noResult: true);
    });
  });

  tearDown(() async {
    await databaseService.rawQuery("DELETE FROM ${service.tableName};");
  });

  group("KanaService", () {
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
          ResourceUid.fromJson("group-nonexistent"),
        ]);

        expect(kanas, isEmpty);
      });
    });

    group("getByGroupId", () {
      test("should return kanas for a specific group ID", () async {
        final kanas = await service.getByGroupId(dummyKatakana.groupUid);

        expect(kanas, isNotEmpty);
        expect(kanas.length, 1);
        expect(kanas[0], dummyKatakana);
      });

      test("should return empty list for non-existent group ID", () async {
        final kanas = await service.getByGroupId(
          ResourceUid.fromJson("group-nonexistent"),
        );

        expect(kanas, isEmpty);
      });
    });

    group("get", () {
      test("should return a specific kana by uid", () async {
        final kana = await service.get(dummyHiragana.uid);

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
      test("should return hiragana kanas when specified", () async {
        final kanas = await service.getKana(Alphabets.hiragana);

        expect(kanas, isNotEmpty);
        expect(kanas.length, 1);
        expect(kanas[0], dummyHiragana);
      });

      test("should return katakana kanas when specified", () async {
        final kanas = await service.getKana(Alphabets.katakana);

        expect(kanas, isNotEmpty);
        expect(kanas.length, 1);
        expect(kanas[0], dummyKatakana);
      });

      test("should return empty list for alphabet with no kanas", () async {
        final kanas = await service.getKana(Alphabets.kanji);

        expect(kanas, isEmpty);
      });
    });

    group("getHiragana", () {
      test("should return only hiragana kanas", () async {
        final kanas = await service.getHiragana();

        expect(kanas, isNotEmpty);
        expect(kanas.length, 1);
        expect(kanas[0], dummyHiragana);
      });
    });

    group("getKatakana", () {
      test("should return only katakana kanas", () async {
        final kanas = await service.getKatakana();

        expect(kanas, isNotEmpty);
        expect(kanas.length, 1);
        expect(kanas[0], dummyKatakana);
      });
    });

    group("upsert", () {
      test("should insert a new kana", () async {
        // Arrange
        final uid = dummyHiragana.uid.copyWith(uid: "kana-new");
        final newKana = dummyHiragana.copyWith(uid: uid);

        await service.upsert(newKana);

        // Get all kanas to check if the new one was added
        final kanas = await service.getByGroupIds([]);

        expect(kanas.length, 3); // 2 initial + 1 new
        expect(kanas.any((k) => k.uid.uid == "kana-new"), isTrue);
      });

      test("should update an existing kana", () async {
        // Arrange
        final updatedKana = dummyHiragana.copyWith(romaji: "updated-romaji");

        await service.upsert(updatedKana);

        // Get the updated kana
        final kanas = await service.getByGroupIds([dummyHiragana.groupUid]);

        expect(kanas.length, 1);
        expect(kanas[0].uid, equals(dummyHiragana.uid));
        expect(kanas[0].romaji, equals("updated-romaji"));
      });
    });

    group("delete", () {
      test("should remove a kana", () async {
        await service.delete(dummyHiragana.uid);

        // Get all kanas to verify deletion
        final kanas = await service.getByGroupIds([]);

        expect(kanas.length, 1); // 2 initial - 1 deleted
        expect(kanas.any((k) => k.uid == dummyHiragana.uid), isFalse);
        expect(kanas[0], dummyKatakana);
      });
    });
  });
}
