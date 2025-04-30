import "dart:convert";

import "package:http/http.dart" as http;
import "package:kana_to_kanji/src/core/constants/resource_type.dart";
import "package:kana_to_kanji/src/core/models/cleanup.dart";
import "package:kana_to_kanji/src/core/models/resources/resource_uid.dart";
import "package:kana_to_kanji/src/core/services/api_service.dart";
import "package:kana_to_kanji/src/core/services/database_service.dart";
import "package:kana_to_kanji/src/core/services/group_service.dart";
import "package:kana_to_kanji/src/core/services/kana_service.dart";
import "package:kana_to_kanji/src/core/services/kanji_service.dart";
import "package:kana_to_kanji/src/core/services/vocabulary_service.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:sqflite/sqflite.dart";

class CleanUpService {
  final ApiService _apiService = locator<ApiService>();
  final DatabaseService _databaseService = locator<DatabaseService>();

  final GroupService _groupService;
  final KanaService _kanaService;
  final KanjiService _kanjiService;
  final VocabularyService _vocabularyService;

  /// [groupService], [kanaService], [kanjiService], and [vocabularyService]
  /// are injected for testability only.
  CleanUpService({
    GroupService? groupService,
    KanaService? kanaService,
    KanjiService? kanjiService,
    VocabularyService? vocabularyService,
  }) : _groupService = groupService ?? GroupService(),
       _kanaService = kanaService ?? KanaService(),
       _kanjiService = kanjiService ?? KanjiService(),
       _vocabularyService = vocabularyService ?? VocabularyService();

  Future<List<ResourceUid>> _getResourceToCleanUp({
    bool forceReload = false,
    String? version,
  }) async {
    var versionQueryParam = "";
    if (!forceReload && version != null) {
      versionQueryParam = "?version[current]=$version";
    }

    return _apiService.get("/v1/cleanup$versionQueryParam").then(_extractData);
  }

  /// Extract the Clean up data from the API Response.
  List<ResourceUid> _extractData(http.Response response) {
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final CleanUpData data = CleanUpData.fromJson(jsonData);
      return data.deletedResources;
    } else {
      // If the server did return something else,
      // returns an sync object with all flags to false.
      return [];
    }
  }

  Future<void> executeCleanUp({
    bool forceReload = false,
    String? version,
  }) async {
    final resourcesToDelete = await _getResourceToCleanUp(
      forceReload: forceReload,
      version: version,
    );

    final groupToDelete =
        resourcesToDelete
            .where((e) => e.resourceType == ResourceType.group)
            .toList();
    final kanaToDelete =
        resourcesToDelete
            .where((e) => e.resourceType == ResourceType.kana)
            .toList();
    final kanjiToDelete =
        resourcesToDelete
            .where((e) => e.resourceType == ResourceType.kanji)
            .toList();
    final vocabularyToDelete =
        resourcesToDelete
            .where((e) => e.resourceType == ResourceType.vocabulary)
            .toList();

    await _databaseService.transaction((transaction) async {
      final Batch batch = transaction.batch();
      await Future.wait([
        if (groupToDelete.isNotEmpty)
          _groupService.deleteAll(groupToDelete, batch: batch),
        if (kanaToDelete.isNotEmpty)
          _kanaService.deleteAll(kanaToDelete, batch: batch),
        if (kanjiToDelete.isNotEmpty)
          _kanjiService.deleteAll(kanjiToDelete, batch: batch),
        if (vocabularyToDelete.isNotEmpty)
          _vocabularyService.deleteAll(vocabularyToDelete, batch: batch),
      ]);

      return batch.commit();
    });
  }
}
