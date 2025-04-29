import "dart:convert";

import "package:http/http.dart" as http;
import "package:kana_to_kanji/src/core/models/sync.dart";
import "package:kana_to_kanji/src/core/services/api_service.dart";
import "package:kana_to_kanji/src/core/services/cleanup_service.dart";
import "package:kana_to_kanji/src/core/services/group_service.dart";
import "package:kana_to_kanji/src/core/services/kana_service.dart";
import "package:kana_to_kanji/src/core/services/kanji_service.dart";
import "package:kana_to_kanji/src/core/services/vocabulary_service.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:logger/logger.dart";

class SyncService {
  final ApiService _apiService = locator<ApiService>();
  final Logger _logger = locator<Logger>();

  final GroupService _groupService;
  final KanaService _kanaService;
  final KanjiService _kanjiService;
  final VocabularyService _vocabularyService;
  final CleanUpService _cleanUpService;

  bool _syncInProgress = false;
  bool get syncInProgress => _syncInProgress;

  /// [groupService], [kanaService], [kanjiService], [vocabularyService] are
  /// visible for testing purpose
  SyncService({
    GroupService? groupService,
    KanaService? kanaService,
    KanjiService? kanjiService,
    VocabularyService? vocabularyService,
    CleanUpService? cleanUpService,
  }) : _groupService = groupService ?? GroupService(),
       _kanaService = kanaService ?? KanaService(),
       _kanjiService = kanjiService ?? KanjiService(),
       _vocabularyService = vocabularyService ?? VocabularyService(),
       _cleanUpService = cleanUpService ?? CleanUpService();

  Future<void> sync() async {
    if (_syncInProgress) {
      _logger.w("SyncService: sync in progress. Skipping for now");
    }
    _syncInProgress = true;
    final sync = await _getSyncData();

    if (sync.group) {
      await _groupService.sync(forceReload: sync.forceReload);
    }
    if (sync.kana) {
      await _kanaService.sync(forceReload: sync.forceReload);
    }
    if (sync.kanji) {
      await _kanjiService.sync(forceReload: sync.forceReload);
    }
    if (sync.vocabulary) {
      await _vocabularyService.sync(forceReload: sync.forceReload);
    }
    if (sync.cleanup) {
      await _cleanUpService.executeCleanUp(
        forceReload: sync.forceReload,
        version: sync.latestVersion,
      );
    }
    _syncInProgress = false;
  }

  Future<SyncConfiguration> _getSyncData() async {
    final lastLoadedVersionGroups = await _groupService.latestVersion;
    final lastLoadedVersionKanas = await _kanaService.latestVersion;
    final lastLoadedVersionKanjis = await _kanjiService.latestVersion;
    final lastLoadedVersionVocabulary = await _vocabularyService.latestVersion;

    var versionQueryParam = "";
    if (lastLoadedVersionGroups != null &&
        lastLoadedVersionGroups.compareTo(versionQueryParam) > 0) {
      versionQueryParam = lastLoadedVersionGroups;
    }
    if (lastLoadedVersionKanas != null &&
        lastLoadedVersionKanas.compareTo(versionQueryParam) > 0) {
      versionQueryParam = lastLoadedVersionKanas;
    }
    if (lastLoadedVersionKanjis != null &&
        lastLoadedVersionKanjis.compareTo(versionQueryParam) > 0) {
      versionQueryParam = lastLoadedVersionKanjis;
    }
    if (lastLoadedVersionVocabulary != null &&
        lastLoadedVersionVocabulary.compareTo(versionQueryParam) > 0) {
      versionQueryParam = lastLoadedVersionVocabulary;
    }

    if (versionQueryParam.isNotEmpty) {
      versionQueryParam = "?version[current]=$versionQueryParam";
    }

    final Sync syncNeeded = await _apiService
        .get("/v1/sync$versionQueryParam")
        .then(_extractData);

    return SyncConfiguration(
      group: syncNeeded.groups,
      groupVersion: lastLoadedVersionGroups,
      kana: syncNeeded.kana,
      kanaVersion: lastLoadedVersionKanas,
      kanji: syncNeeded.kanji,
      kanjiVersion: lastLoadedVersionKanjis,
      vocabulary: syncNeeded.vocabulary,
      vocabularyVersion: lastLoadedVersionVocabulary,
      cleanup: syncNeeded.cleanup,
      achievements: syncNeeded.achievements,
      forceReload: syncNeeded.forceReload,
    );
  }

  /// Extract the Sync data from the API Response.
  Sync _extractData(http.Response response) {
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final Sync data = Sync.fromJson(jsonData);
      return data;
    } else if (response.statusCode == 404) {
      // If the server did return a 404 response,
      // returns an sync object with all flags to true.
      return const Sync(
        achievements: true,
        cleanup: true,
        groups: true,
        kana: true,
        kanji: true,
        learning: LearningSync(stages: true),
        vocabulary: true,
        forceReload: true,
      );
    } else {
      // If the server did return something else,
      // returns an sync object with all flags to false.
      return const Sync(
        achievements: false,
        cleanup: false,
        groups: false,
        kana: false,
        kanji: false,
        learning: LearningSync(stages: false),
        vocabulary: false,
      );
    }
  }
}
