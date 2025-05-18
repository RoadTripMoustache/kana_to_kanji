import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/constants/preference_flags.dart";
import "package:kana_to_kanji/src/core/dataloaders/example_dataloader.dart";
import "package:kana_to_kanji/src/core/models/paginated_data.dart";
import "package:kana_to_kanji/src/core/models/resources/example.dart";
import "package:kana_to_kanji/src/core/models/resources/resource_uid.dart";
import "package:kana_to_kanji/src/core/services/database_service.dart";
import "package:kana_to_kanji/src/core/services/preferences_service.dart";
import "package:kana_to_kanji/src/core/services/resources/example_service.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:logger/logger.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

import "../../../../dummies/example.dart";
import "../../../../helpers.dart";
@GenerateNiceMocks([
  MockSpec<ExampleDataLoader>(),
  MockSpec<PreferencesService>(),
])
import "example_service_test.mocks.dart";

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late final DatabaseService databaseService;
  late ExampleService service;
  late MockExampleDataLoader mockDataLoader;
  late MockPreferencesService mockPreferencesService;

  group("ExampleService", () {
    setUpAll(() async {
      databaseService = await setupDatabaseService();
      mockDataLoader = MockExampleDataLoader();
      mockPreferencesService = MockPreferencesService();

      locator
        ..registerSingleton<Logger>(Logger())
        ..registerSingleton<PreferencesService>(mockPreferencesService);

      provideDummy<PaginatedData<Example>>(
        PaginatedData<Example>(data: dummyExamples),
      );
    });

    setUp(() async {
      // Create the service to test with mock data loader
      service = ExampleService(dataLoader: mockDataLoader);

      // Insert test data
      await databaseService.rawQuery(sqlInsertDummyExamples);
    });

    tearDown(() async {
      await databaseService.rawQuery("DELETE FROM ${service.tableName};");
      reset(mockDataLoader);
      reset(mockPreferencesService);
    });

    tearDownAll(() async {
      await unregister<DatabaseService>();
      await unregister<Logger>();
      await unregister<PreferencesService>();
    });

    group("get", () {
      test("should return a specific example by uid", () async {
        final example = await service.get(dummyExample1.uid);

        expect(example, isNotNull);
        expect(example.uid, dummyExample1.uid);
        expect(example.sentence, dummyExample1.sentence);
        expect(example.translation, dummyExample1.translation);
        expect(example.kanji, dummyExample1.kanji);
        expect(example.reading, dummyExample1.reading);
      });

      test("should fetch from API if not found locally", () async {
        final newUid = ResourceUid.fromJson("example-new");
        final newExample = dummyExample1.copyWith(uid: newUid);

        when(mockDataLoader.fetch(newUid)).thenAnswer((_) async => newExample);

        final example = await service.get(newUid);

        verify(mockDataLoader.fetch(newUid)).called(1);
        expect(example, newExample);

        // Verify it was saved to the database
        final savedExample = await service.get(newUid);
        expect(savedExample, newExample);
      });

      test("should throw an error if not found and API fails", () async {
        final notFoundUid = ResourceUid.fromJson("example-notfound");

        when(
          mockDataLoader.fetch(notFoundUid),
        ).thenThrow(Exception("Not found"));

        expect(() async => await service.get(notFoundUid), throwsException);
      });
    });

    group("getPage", () {
      // No tests for now as we do not paginate from the DB yet
    });

    group("upsertData", () {
      test("should insert a new example", () async {
        final newUid = ResourceUid.fromJson("example-new");
        final newExample = dummyExample1.copyWith(uid: newUid);

        await service.upsert(newExample);
        final retrievedExample = await service.get(newUid);

        expect(retrievedExample, isNotNull);
        expect(retrievedExample.uid, newExample.uid);
        expect(retrievedExample.sentence, newExample.sentence);
      });

      test("should update an existing example", () async {
        final updatedExample = dummyExample1.copyWith(
          translation: "Updated translation",
        );

        await service.upsert(updatedExample);
        final retrievedExample = await service.get(dummyExample1.uid);

        expect(retrievedExample, isNotNull);
        expect(retrievedExample.translation, "Updated translation");
      });
    });

    group("sync", () {
      final apiExamples = [
        dummyExample1.copyWith(translation: "API Example 1"),
        dummyExample2.copyWith(translation: "API Example 2"),
        dummyExample3.copyWith(translation: "API Example 3"),
      ];

      PaginatedData<Example> pageResult = PaginatedData<Example>(
        data: apiExamples,
      );

      setUp(() async {
        pageResult = PaginatedData<Example>(data: apiExamples);
        provideDummy<PaginatedData<Example>>(pageResult);
        when(
          mockDataLoader.fetchAll(latestVersion: anyNamed("latestVersion")),
        ).thenAnswer((_) async => pageResult);
      });

      test("should fetch and save examples from API", () async {
        await service.sync();

        verify(mockDataLoader.fetchAll()).called(1);

        // Verify that all examples were saved
        final savedExamples = await service.getPage(0);
        expect(savedExamples.data.length, apiExamples.length);

        // Verify translations were updated
        expect(savedExamples.data[0].translation, "API Example 1");
        expect(savedExamples.data[1].translation, "API Example 2");
        expect(savedExamples.data[2].translation, "API Example 3");

        // Verify preference was set with latest version
        final latestVersion = await service.latestVersion;
        verify(
          mockPreferencesService.setString(
            PreferenceFlags.exampleLastVersionSynced,
            latestVersion,
          ),
        ).called(1);
      });
    });

    group("healthCheck", () {
      setUp(() async {
        when(
          mockPreferencesService.getString(
            PreferenceFlags.exampleLastVersionSynced,
          ),
        ).thenAnswer((_) async => dummyExample1.version);
      });

      test("should not sync when versions match", () async {
        await service.healthCheck();

        // Verify that fetch was not called
        verifyNever(
          mockDataLoader.fetchAll(latestVersion: anyNamed("latestVersion")),
        );
      });

      test("should sync when versions don't match", () async {
        // Setup different versions
        when(
          mockPreferencesService.getString(
            PreferenceFlags.exampleLastVersionSynced,
          ),
        ).thenAnswer((_) async => "2024_01_01");

        await service.healthCheck();

        // Verify that fetch was called
        verify(mockDataLoader.fetchAll(latestVersion: "2024_01_01")).called(1);
      });
    });
  });
}
