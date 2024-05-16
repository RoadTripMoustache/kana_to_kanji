import "dart:convert";

import "package:http/http.dart" as http;
import "package:isar/isar.dart";
import "package:kana_to_kanji/src/core/models/group.dart";
import "package:kana_to_kanji/src/core/models/kana.dart";
import "package:kana_to_kanji/src/core/models/kanji.dart";
import "package:kana_to_kanji/src/core/models/sync.dart";
import "package:kana_to_kanji/src/core/models/vocabulary.dart";
import "package:kana_to_kanji/src/core/services/api_service.dart";
import "package:kana_to_kanji/src/locator.dart";

class SyncService {
  final ApiService _apiService = locator<ApiService>();
  final Isar _isar = locator<Isar>();

  Future<Sync> getSyncData() {
    final lastLoadedVersionGroups =
        _isar.groups.where().versionProperty().max();
    final lastLoadedVersionKanas = _isar.kanas.where().versionProperty().max();
    final lastLoadedVersionKanjis =
        _isar.kanjis.where().versionProperty().max();
    final lastLoadedVersionVocabulary =
        _isar.vocabularys.where().versionProperty().max();

    var versionQueryParam = "";
    if (lastLoadedVersionGroups != null &&
        lastLoadedVersionGroups.compareTo(versionQueryParam) > 0) {
      versionQueryParam = "?version[current]=$lastLoadedVersionGroups";
    }
    if (lastLoadedVersionKanas != null &&
        lastLoadedVersionKanas.compareTo(versionQueryParam) > 0) {
      versionQueryParam = "?version[current]=$lastLoadedVersionKanas";
    }
    if (lastLoadedVersionKanjis != null &&
        lastLoadedVersionKanjis.compareTo(versionQueryParam) > 0) {
      versionQueryParam = "?version[current]=$lastLoadedVersionKanjis";
    }
    if (lastLoadedVersionVocabulary != null &&
        lastLoadedVersionVocabulary.compareTo(versionQueryParam) > 0) {
      versionQueryParam = "?version[current]=$lastLoadedVersionVocabulary";
    }

    return _apiService.get("/v1/sync$versionQueryParam").then(_extractData);
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
          groupsFlag: true,
          kana: true,
          kanji: true,
          learning: LearningSync(stages: true),
          vocabulary: true,
          forceReload: true);
    } else {
      // If the server did return something else,
      // returns an sync object with all flags to false.
      return const Sync(
          achievements: false,
          cleanup: false,
          groupsFlag: false,
          kana: false,
          kanji: false,
          learning: LearningSync(stages: false),
          vocabulary: false);
    }
  }
}
