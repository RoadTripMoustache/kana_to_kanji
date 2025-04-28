import "dart:convert";

import "package:http/http.dart" as http;
import "package:kana_to_kanji/src/core/dataloaders/kanji_dataloader.dart";
import "package:kana_to_kanji/src/core/dataloaders/resource_dataloader.dart";
import "package:kana_to_kanji/src/core/dataloaders/vocabulary_dataloader.dart";
import "package:kana_to_kanji/src/core/models/group.dart";
import "package:kana_to_kanji/src/core/models/kana.dart";
import "package:kana_to_kanji/src/core/models/sync.dart";
import "package:kana_to_kanji/src/core/services/api_service.dart";
import "package:kana_to_kanji/src/core/services/cleanup_service.dart";
import "package:kana_to_kanji/src/core/services/group_service.dart";
import "package:kana_to_kanji/src/core/services/kana_service.dart";
import "package:kana_to_kanji/src/locator.dart";

class SyncService {
  final ApiService _apiService = locator<ApiService>();

  final ResourceDataLoader<Group> _groupDataLoader;
  final ResourceDataLoader<Kana> _kanaDataLoader;
  final KanjiDataLoader _kanjiDataLoader;
  final VocabularyDataLoader _vocabularyDataLoader;
  final CleanUpService _cleanUpService;

  /// [groupDataLoader], [kanaDataLoader], [kanjiDataLoader],
  SyncService({
    ResourceDataLoader<Group>? groupDataLoader,
    ResourceDataLoader<Kana>? kanaDataLoader,
    KanjiDataLoader? kanjiDataLoader,
    VocabularyDataLoader? vocabularyDataLoader,
    CleanUpService? cleanUpService,
  }) : _groupDataLoader =
           groupDataLoader ??
           ResourceDataLoader<Group>(
             service: GroupService(),
             fromJson: Group.fromJson,
             apiResourceType: "groups",
           ),
       _kanaDataLoader =
           kanaDataLoader ??
           ResourceDataLoader<Kana>(
             service: KanaService(),
             fromJson: Kana.fromJson,
             apiResourceType: "kanas",
           ),
       _kanjiDataLoader = kanjiDataLoader ?? KanjiDataLoader(),
       _vocabularyDataLoader = vocabularyDataLoader ?? VocabularyDataLoader(),
       _cleanUpService = cleanUpService ?? CleanUpService();

  Future<void> sync() async {
    final sync = await _getSyncData();

    if (sync.group) {
      await _groupDataLoader.fetchAll(
        forceReload: sync.forceReload,
        latestVersion: sync.groupVersion,
      );
    }
    if (sync.kana) {
      await _kanaDataLoader.fetchAll(
        forceReload: sync.forceReload,
        latestVersion: sync.kanaVersion,
      );
    }
    if (sync.kanji) {
      await _kanjiDataLoader.fetchAll(
        forceReload: sync.forceReload,
        latestVersion: sync.kanjiVersion,
      );
    }
    if (sync.vocabulary) {
      await _vocabularyDataLoader.fetchAll(
        forceReload: sync.forceReload,
        latestVersion: sync.vocabularyVersion,
      );
    }
    if (sync.cleanup) {
      await _cleanUpService.executeCleanUp(
        forceReload: sync.forceReload,
        version: sync.latestVersion,
      );
    }
  }

  Future<SyncConfiguration> _getSyncData() async {
    final lastLoadedVersionGroups = await _groupDataLoader.latestVersion;
    final lastLoadedVersionKanas = await _kanaDataLoader.latestVersion;
    final lastLoadedVersionKanjis = await _kanjiDataLoader.latestVersion;
    final lastLoadedVersionVocabulary =
        await _vocabularyDataLoader.latestVersion;

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
