import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";
import "package:kana_to_kanji/src/core/services/database_service.dart";
import "package:kana_to_kanji/src/core/services/group_service.dart" as groups;
import "package:kana_to_kanji/src/core/services/kanji_service.dart" as kanji;
import "package:kana_to_kanji/src/core/services/vocabulary_service.dart";
import "package:sqflite/sqflite.dart";
import "package:sqflite/utils/utils.dart";

import "../../../dummies/dummies.dart";
import "../../../helpers.dart";

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late final DatabaseService databaseService;
  late VocabularyService service;

  group("VocabularyService", () {
    setUpAll(() async {
      databaseService = await setupDatabaseService();
    });

    setUp(() async {
      // Create the service to test
      service = VocabularyService();

      await databaseService.transaction((txn) async {
        final Batch batch = txn.batch();

        sqlInsertDummiesVocabulary.split(";").forEach((sql) {
          if (sql.trim().isNotEmpty) {
            batch.rawQuery(sql.trim());
          }
        });

        await batch.commit(noResult: true);
      });
    });

    tearDown(() async {
      await databaseService.transaction((txn) async {
        final Batch batch =
            txn.batch()
              ..delete(service.tableName)
              ..delete(sqlKanjiReadingsTable)
              ..delete(sqlRelatedKanjiTable)
              ..delete(sqlVocabularyGroupsTable)
              ..delete(groups.sqlGroupsTable)
              ..delete(kanji.sqlKanjiTable);

        await batch.commit(noResult: true);
      });
    });

    tearDownAll(() async {
      await unregister<DatabaseService>();
    });

    group("getAll", () {
      test("should return all vocabulary items", () async {
        final vocabularies = await service.getAll();

        expect(vocabularies, isNotEmpty);
        expect(vocabularies, containsAll(dummiesVocabulary));
      });
    });

    group("get", () {
      test("should return a specific vocabulary by uid", () async {
        final vocabulary = await service.get(dummyVocabulary.uid);

        expect(vocabulary, isNotNull);
        expect(vocabulary, dummyVocabulary);
      });

      test("should throw an error if not found", () async {
        expect(
          () async =>
              await service.get(ResourceUid.fromJson("vocabulary-notFound")),
          throwsException,
        );
      });
    });

    group("upsert", () {
      test("should insert a new vocabulary", () async {
        final uid = ResourceUid.fromJson("vocabulary-new");
        final newVocabulary = dummyVocabulary.copyWith(uid: uid);

        await service.upsert(newVocabulary);

        // Get all vocabulary to check if the new one was added
        final vocabularies = await service.getAll();

        expect(vocabularies.length, dummiesVocabulary.length + 1);
        expect(vocabularies, contains(newVocabulary));
      });

      test("should update an existing vocabulary", () async {
        final updatedVocabulary = dummyVocabulary.copyWith(
          meanings: ["updated meaning", "secondary meaning"],
        );

        await service.upsert(updatedVocabulary);

        // Get the updated vocabulary
        final vocabulary = await service.get(dummyVocabulary.uid);

        expect(vocabulary, updatedVocabulary);
      });

      test("should update related kanji and groups", () async {
        final vocabularyWithRelations = dummyVocabulary.copyWith(
          relatedKanjis: dummyVocabularyWithRelatedData.relatedKanjis,
          groups: dummyVocabularyWithRelatedData.groups,
        );

        await service.upsert(vocabularyWithRelations);

        // Get the updated vocabulary with relations
        final vocabulary = await service.get(dummyVocabulary.uid);

        expect(vocabulary, vocabularyWithRelations);
      });
    });

    group("upsertAll", () {
      test("should insert multiple new vocabulary items", () async {
        final uid1 = ResourceUid.fromJson("vocabulary-batch1");
        final uid2 = ResourceUid.fromJson("vocabulary-batch2");

        final newVocabularies = [
          dummyVocabulary.copyWith(uid: uid1, kanji: "新"),
          dummyVocabulary.copyWith(uid: uid2, kanji: "語"),
        ];

        await service.upsertAll(newVocabularies);

        // Get all vocabulary to check if the new ones were added
        final vocabularies = await service.getAll();

        expect(
          vocabularies.length,
          dummiesVocabulary.length + newVocabularies.length,
        );
        expect(vocabularies, containsAll(newVocabularies));
      });

      test("should update multiple existing vocabulary items", () async {
        final updatedVocabularies = [
          dummyVocabulary.copyWith(meanings: ["updated meaning 1"]),
          dummyVocabularyWithoutKanji.copyWith(meanings: ["updated meaning 2"]),
        ];

        await service.upsertAll(updatedVocabularies);

        // Get updated vocabulary items
        final vocabulary1 = await service.get(dummyVocabulary.uid);
        final vocabulary2 = await service.get(dummyVocabularyWithoutKanji.uid);

        expect(vocabulary1, updatedVocabularies[0]);
        expect(vocabulary2, updatedVocabularies[1]);
      });

      test("should handle force reload parameter", () async {
        final uid1 = ResourceUid.fromJson("vocabulary-reload1");
        final uid2 = ResourceUid.fromJson("vocabulary-reload2");

        final newVocabularies = [
          dummyVocabulary.copyWith(uid: uid1, kanji: "天"),
          dummyVocabulary.copyWith(uid: uid2, kanji: "地"),
        ];

        await service.upsertAll(newVocabularies, forceReload: true);

        // Get all vocabulary to check if only new ones exist
        final vocabularies = await service.getAll();

        expect(vocabularies.length, 2);
        expect(vocabularies, containsAll(newVocabularies));
      });
    });

    group("delete", () {
      test("should remove a vocabulary", () async {
        await service.delete(dummyVocabulary.uid);

        // Get all vocabulary to verify deletion
        final vocabularies = await service.getAll();

        expect(vocabularies.length, dummiesVocabulary.length - 1);
        expect(vocabularies, isNot(contains(dummyVocabulary)));
      });

      test("should remove related data when vocabulary is deleted", () async {
        await service.delete(dummyVocabularyWithRelatedData.uid);

        // Check if related data is removed
        final relatedKanjiCount = await databaseService.query(
          sqlRelatedKanjiTable,
          columns: [sqlCountColumn],
          where: "$sqlVocabularyUidColumn = ?",
          whereArgs: [dummyVocabulary.uid.uid],
        );

        final groupsCount = await databaseService.query(
          sqlVocabularyGroupsTable,
          columns: [sqlCountColumn],
          where: "$sqlVocabularyUidColumn = ?",
          whereArgs: [dummyVocabulary.uid.uid],
        );

        final kanjiReadingsCount = await databaseService.query(
          sqlKanjiReadingsTable,
          columns: [sqlCountColumn],
          where: "$sqlVocabularyUidColumn = ?",
          whereArgs: [dummyVocabulary.uid.uid],
        );

        expect(relatedKanjiCount.first[sqlCountColumn], 0);
        expect(groupsCount.first[sqlCountColumn], 0);
        expect(kanjiReadingsCount.first[sqlCountColumn], 0);
      });
    });

    group("deleteAll", () {
      test("should remove multiple vocabulary items", () async {
        final vocabulariesToDelete = [
          dummyVocabulary.uid,
          dummyVocabularyWithoutKanji.uid,
        ];

        await service.deleteAll(vocabulariesToDelete);

        // Get all vocabulary to verify deletion
        final vocabularies = await service.getAll();
        expect(vocabularies.length, dummiesVocabulary.length - 2);

        // Verify each vocabulary no longer exists
        for (final uid in vocabulariesToDelete) {
          expect(
            () async => await service.get(uid),
            throwsException,
            reason:
                "should throw an exception when trying to get deleted vocabulary",
          );
        }

        // Verify the remaining vocabulary is still there
        expect(vocabularies, contains(dummyVocabularyWithRelatedData));
      });

      test(
        "should remove related data when multiple vocabulary items are deleted",
        () async {
          final vocabulariesToDelete = [dummyVocabularyWithRelatedData.uid];

          await service.deleteAll(vocabulariesToDelete);

          // Check if related data is removed
          final relatedKanjiCount = await databaseService.query(
            sqlRelatedKanjiTable,
            columns: [sqlCountColumn],
            where: "$sqlVocabularyUidColumn = ?",
            whereArgs: [dummyVocabularyWithRelatedData.uid.uid],
          );

          final groupsCount = await databaseService.query(
            sqlVocabularyGroupsTable,
            columns: [sqlCountColumn],
            where: "$sqlVocabularyUidColumn = ?",
            whereArgs: [dummyVocabularyWithRelatedData.uid.uid],
          );

          final kanjiReadingsCount = await databaseService.query(
            sqlKanjiReadingsTable,
            columns: [sqlCountColumn],
            where: "$sqlVocabularyUidColumn = ?",
            whereArgs: [dummyVocabularyWithRelatedData.uid.uid],
          );

          expect(relatedKanjiCount.first[sqlCountColumn], 0);
          expect(groupsCount.first[sqlCountColumn], 0);
          expect(kanjiReadingsCount.first[sqlCountColumn], 0);
        },
      );

      test("should handle empty list", () async {
        await service.deleteAll([]);

        // Verify all vocabulary items still exist
        final vocabularies = await service.getAll();
        expect(
          vocabularies.length,
          dummiesVocabulary.length,
        ); // All vocabulary should remain
      });
    });

    group("latestVersion", () {
      test("should return the latest version from the database", () async {
        // The test data already has vocabulary items with versions
        final latestVersion = await service.latestVersion;

        // Verify that a version is returned
        expect(latestVersion, isNotNull);
        expect(latestVersion, isA<String>());
      });

      test("should return null when no vocabulary items exist", () async {
        // Delete all vocabulary items
        await databaseService.delete(service.tableName);

        // Check that latestVersion returns null
        final latestVersion = await service.latestVersion;
        expect(latestVersion, isNull);
      });
    });
  });
}
