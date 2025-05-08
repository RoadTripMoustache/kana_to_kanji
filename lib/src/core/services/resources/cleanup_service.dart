import "dart:convert";

import "package:flutter/cupertino.dart";
import "package:http/http.dart" as http;
import "package:kana_to_kanji/src/core/constants/preference_flags.dart";
import "package:kana_to_kanji/src/core/constants/resource_type.dart";
import "package:kana_to_kanji/src/core/models/cleanup.dart";
import "package:kana_to_kanji/src/core/models/resources/resource_uid.dart";
import "package:kana_to_kanji/src/core/services/api_service.dart";
import "package:kana_to_kanji/src/core/services/database_service.dart";
import "package:kana_to_kanji/src/core/services/preferences_service.dart";
import "package:kana_to_kanji/src/core/services/resources/group_service.dart";
import "package:kana_to_kanji/src/core/services/resources/kana_service.dart";
import "package:kana_to_kanji/src/core/services/resources/kanji_service.dart";
import "package:kana_to_kanji/src/core/services/resources/vocabulary_service.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:logger/logger.dart";
import "package:sqflite/sqflite.dart";

class CleanUpService {
  final ApiService _apiService = locator<ApiService>();
  final DatabaseService _databaseService = locator<DatabaseService>();
  final Logger _logger = locator<Logger>();
  final PreferencesService _preferencesService = locator<PreferencesService>();

  final GroupService _groupService = locator<GroupService>();
  final KanaService _kanaService = locator<KanaService>();
  final KanjiService _kanjiService = locator<KanjiService>();
  final VocabularyService _vocabularyService = locator<VocabularyService>();

  /// [groupService], [kanaService], [kanjiService], and [vocabularyService]
  /// are injected for testability only.
  CleanUpService();

  Future<List<ResourceUid>> _getResourceToCleanUp(String version) async =>
      _apiService
          .get("/v1/cleanup?version[current]=$version")
          .then(_extractData);

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

  Future healthCheck({
    required String version,
    bool cleanUpRequired = false,
  }) async {
    if (cleanUpRequired) {
      return executeCleanUp(version: version);
    }
    final lastVersionCleanedUp = await _preferencesService.getString(
      PreferenceFlags.lastVersionCleanedUp,
    );

    if (lastVersionCleanedUp == null) {
      return _preferencesService.setString(
        PreferenceFlags.lastVersionCleanedUp,
        version,
      );
    }

    if (lastVersionCleanedUp != version) {
      _logger.i(
        "CleanUpService: previous cleanup failed, cleaning from "
        "version $lastVersionCleanedUp",
      );
      return executeCleanUp(version: version);
    }
  }

  @visibleForTesting
  Future<void> executeCleanUp({required String version}) async {
    final resourcesToDelete = await _getResourceToCleanUp(version);

    _logger.d("CleanUpService: start cleaning up from version $version");

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

    await _preferencesService.setString(
      PreferenceFlags.lastVersionCleanedUp,
      version,
    );
    _logger.d("CleanUpService: finished");
  }
}
