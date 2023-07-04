import 'package:kana_to_kanji/src/core/constants/alphabets.dart';
import 'package:kana_to_kanji/src/core/constants/group_queries.dart';
import 'package:kana_to_kanji/src/core/models/group.dart';
import 'package:kana_to_kanji/src/locator.dart';
import 'package:kana_to_kanji/src/quiz/repositories/groups_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kana_to_kanji/src/core/services/database_service.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers.dart';
@GenerateNiceMocks([MockSpec<DatabaseService>()])
import 'groups_repository_test.mocks.dart';

void main() {
  const Group groupSample =
      Group(id: 1, alphabet: Alphabets.hiragana, name: "test");
  final databaseServiceMock = MockDatabaseService();

  late GroupsRepository service;

  setUpAll(() {
    locator.registerSingleton<DatabaseService>(databaseServiceMock);
  });

  setUp(() {
    service = GroupsRepository();
  });

  tearDown(() {
    reset(databaseServiceMock);
  });

  tearDownAll(() {
    unregister<DatabaseService>();
  });

  group("GroupsRepository", () {
    group("getGroups", () {
      test("should call the database to retrieve the groups of the alphabet",
          () async {
        when(databaseServiceMock.getMultiple(getGroupsQuery, Group.fromJson,
                arguments: [Alphabets.hiragana.value]))
            .thenAnswer((_) async => <Group>[groupSample]);

        final results = await service.getGroups(groupSample.alphabet);

        expect(results, [groupSample]);
        verify(databaseServiceMock.getMultiple(getGroupsQuery, Group.fromJson,
            arguments: [Alphabets.hiragana.value]));
        verifyNoMoreInteractions(databaseServiceMock);
      });

      test(
          "shouldn't call the database to retrieve the groups of the alphabet if not necessary",
          () async {
        when(databaseServiceMock.getMultiple(getGroupsQuery, Group.fromJson,
                arguments: [Alphabets.hiragana.value]))
            .thenAnswer((_) async => <Group>[groupSample]);

        List<Group> results = await service.getGroups(groupSample.alphabet);

        expect(results, [groupSample]);
        verify(databaseServiceMock.getMultiple(getGroupsQuery, Group.fromJson,
            arguments: [Alphabets.hiragana.value]));

        results = await service.getGroups(groupSample.alphabet, reload: false);

        expect(results, [groupSample]);
        verifyNoMoreInteractions(databaseServiceMock);
      });
    });
  });
}
