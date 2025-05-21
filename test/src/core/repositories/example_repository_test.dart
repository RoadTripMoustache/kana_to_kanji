import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/models/paginated_data.dart";
import "package:kana_to_kanji/src/core/models/resources/example.dart";
import "package:kana_to_kanji/src/core/models/resources/resource_uid.dart";
import "package:kana_to_kanji/src/core/repositories/example_repository.dart";
import "package:kana_to_kanji/src/core/services/resources/example_service.dart";
import "package:kana_to_kanji/src/core/utils/sql/order_by.dart";
import "package:kana_to_kanji/src/core/utils/sql/where.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:logger/logger.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

import "../../../dummies/example.dart";
import "../../../helpers.dart";

@GenerateNiceMocks([MockSpec<ExampleService>()])
import "example_repository_test.mocks.dart";

void main() {
  late ExampleRepository repository;
  late MockExampleService mockService;

  group("ExampleRepository", () {
    setUpAll(() async {
      mockService = MockExampleService();

      // Provide dummy for PaginatedData<Example>
      provideDummy<PaginatedData<Example>>(
        PaginatedData<Example>(data: dummyExamples),
      );

      locator
        ..registerSingleton<Logger>(Logger())
        ..registerSingleton<ExampleService>(mockService);
    });

    setUp(() async {
      // Reset the repository for each test
      repository = ExampleRepository();
    });

    tearDown(() async {
      reset(mockService);
    });

    tearDownAll(() async {
      await unregister<Logger>();
      await unregister<ExampleService>();
    });

    group("get", () {
      test("should return a specific example by uid", () async {
        // Setup mock service
        when(
          mockService.get(dummyExample1.uid),
        ).thenAnswer((_) async => dummyExample1);

        // Call the repository method
        final example = await repository.get(dummyExample1.uid);

        // Verify the result
        expect(example, isNotNull);
        expect(example.uid, dummyExample1.uid);
        expect(example.sentence, dummyExample1.sentence);

        // Verify the service was called
        verify(mockService.get(dummyExample1.uid)).called(1);
      });

      test("should return cached example if available", () async {
        // First call to populate the cache
        when(
          mockService.get(dummyExample1.uid),
        ).thenAnswer((_) async => dummyExample1);
        await repository.get(dummyExample1.uid);

        // Reset the mock to verify it's not called again
        reset(mockService);

        // Second call should use the cache
        final example = await repository.get(dummyExample1.uid);

        // Verify the result
        expect(example, isNotNull);
        expect(example.uid, dummyExample1.uid);

        // Verify the service was not called again
        verifyNever(mockService.get(dummyExample1.uid));
      });
    });

    group("getMultiple", () {
      test("should return multiple examples", () async {
        // Setup mock service
        final paginatedData = PaginatedData<Example>(data: dummyExamples);
        when(
          mockService.getPage(
            any,
            where: anyNamed("where"),
            orderBy: anyNamed("orderBy"),
          ),
        ).thenAnswer((_) async => paginatedData);

        // Call the repository method
        final result = await repository.getMultiple(
          where: <Where>[],
          orderBy: <OrderBy>[],
        );

        // Verify the result
        expect(result.data.length, dummyExamples.length);
        expect(result.data, containsAll(dummyExamples));

        // Verify the service was called
        verify(
          mockService.getPage(
            any,
            where: anyNamed("where"),
            orderBy: anyNamed("orderBy"),
          ),
        ).called(1);
      });
    });

    group("getResourceExamples", () {
      test("should get examples for a kanji resource", () async {
        // Setup mock service
        final kanjiUid = ResourceUid.fromJson("kanji-1");
        final paginatedData = PaginatedData<Example>(
          data: [dummyExample1, dummyExample2],
        );
        when(
          mockService.getPage(
            any,
            where: anyNamed("where"),
            pageSize: anyNamed("pageSize"),
          ),
        ).thenAnswer((_) async => paginatedData);

        // Call the repository method
        final result = await repository.getResourceExamples(kanjiUid, limit: 2);

        // Verify the result
        expect(result.data.length, 2);
        expect(result.data, containsAll([dummyExample1, dummyExample2]));

        // Verify the service was called
        verify(
          mockService.getPage(any, where: anyNamed("where"), pageSize: 2),
        ).called(1);
      });

      test("should get examples for a vocabulary resource", () async {
        // Setup mock service
        final vocabUid = ResourceUid.fromJson("vocabulary-2");
        final paginatedData = PaginatedData<Example>(
          data: [dummyExample2, dummyExample3],
        );
        when(
          mockService.getPage(
            any,
            where: anyNamed("where"),
            pageSize: anyNamed("pageSize"),
          ),
        ).thenAnswer((_) async => paginatedData);

        // Call the repository method
        final result = await repository.getResourceExamples(vocabUid, limit: 2);

        // Verify the result
        expect(result.data.length, 2);
        expect(result.data, containsAll([dummyExample2, dummyExample3]));

        // Verify the service was called
        verify(
          mockService.getPage(any, where: anyNamed("where"), pageSize: 2),
        ).called(1);
      });

      test("should throw assertion error for invalid resource type", () async {
        // Create a UID with an invalid resource type
        final invalidUid = ResourceUid.fromJson("example-1");

        // Verify that calling getResourceExamples with an invalid resource type
        // throws an assertion error
        expect(
          () => repository.getResourceExamples(invalidUid),
          throwsA(isA<AssertionError>()),
        );
      });

      test("should throw assertion error for invalid limit", () async {
        // Create a valid UID
        final validUid = ResourceUid.fromJson("kanji-1");

        // Verify that calling getResourceExamples with an invalid limit throws
        // an assertion error
        expect(
          () => repository.getResourceExamples(validUid, limit: 0),
          throwsA(isA<AssertionError>()),
        );

        expect(
          () => repository.getResourceExamples(validUid, limit: 101),
          throwsA(isA<AssertionError>()),
        );
      });
    });
  });
}
