import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/constants/alphabets.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";
import "package:kana_to_kanji/src/core/services/database_service.dart";
import "package:kana_to_kanji/src/core/services/group_service.dart";
import "package:kana_to_kanji/src/core/services/kana_service.dart";
import "package:sqflite/sqflite.dart";

import "../../../dummies/dummies.dart";
import "../../../helpers.dart";

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late final DatabaseService databaseService;
  late KanaService service;

  group("KanaService", () {
    setUpAll(() async {
      databaseService = await setupDatabaseService();
    });

    setUp(() async {
      // Create the service to test
      service = KanaService();
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
    });

    tearDownAll(() async {
      await unregister<DatabaseService>();
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
        final uid = dummyHiragana.uid.copyWith(uid: "kana-new");
        final newKana = dummyHiragana.copyWith(uid: uid);

        await service.upsert(newKana);

        final kanas = await service.getByGroupIds([]);

        expect(kanas.length, 3); // 2 initial + 1 new
        expect(kanas.any((k) => k.uid.uid == "kana-new"), isTrue);
      });

      test("should update an existing kana", () async {
        final updatedKana = dummyHiragana.copyWith(romaji: "updated-romaji");

        await service.upsert(updatedKana);

        final kanas = await service.getByGroupIds([dummyHiragana.groupUid]);

        expect(kanas.length, 1);
        expect(kanas[0].uid, equals(dummyHiragana.uid));
        expect(kanas[0].romaji, equals("updated-romaji"));
      });
    });

    group("upsertAll", () {
      test("should insert multiple kanas", () async {
        final newKana1 = dummyHiragana.copyWith(
          uid: ResourceUid.fromJson("kana-new1"),
        );
        final newKana2 = dummyKatakana.copyWith(
          uid: ResourceUid.fromJson("kana-new2"),
        );

        await service.upsertAll([newKana1, newKana2]);

        final kanas = await service.getByGroupIds([]);

        expect(kanas.length, 4); // 2 initial + 2 new
        expect(kanas.any((k) => k.uid.uid == "kana-new1"), isTrue);
        expect(kanas.any((k) => k.uid.uid == "kana-new2"), isTrue);
      });

      test("should update existing kanas", () async {
        final updatedKana1 = dummyHiragana.copyWith(romaji: "updated-romaji1");
        final updatedKana2 = dummyKatakana.copyWith(romaji: "updated-romaji2");

        await service.upsertAll([updatedKana1, updatedKana2]);

        final kanas = await service.getByGroupIds([
          dummyHiragana.groupUid,
          dummyKatakana.groupUid,
        ]);

        expect(kanas.length, 2);
        expect(kanas[0].uid, equals(dummyHiragana.uid));
        expect(kanas[0].romaji, equals("updated-romaji1"));
        expect(kanas[1].uid, equals(dummyKatakana.uid));
        expect(kanas[1].romaji, equals("updated-romaji2"));
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
