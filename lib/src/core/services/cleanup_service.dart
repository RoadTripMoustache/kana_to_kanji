import "dart:convert";

import "package:http/http.dart" as http;
import "package:isar/isar.dart";
import "package:kana_to_kanji/src/core/constants/resource_type.dart";
import "package:kana_to_kanji/src/core/models/cleanup.dart";
import "package:kana_to_kanji/src/core/models/group.dart";
import "package:kana_to_kanji/src/core/models/kana.dart";
import "package:kana_to_kanji/src/core/models/kanji.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";
import "package:kana_to_kanji/src/core/models/vocabulary.dart";
import "package:kana_to_kanji/src/core/repositories/groups_repository.dart";
import "package:kana_to_kanji/src/core/repositories/kana_repository.dart";
import "package:kana_to_kanji/src/core/repositories/kanji_repository.dart";
import "package:kana_to_kanji/src/core/repositories/vocabulary_repository.dart";
import "package:kana_to_kanji/src/core/services/api_service.dart";
import "package:kana_to_kanji/src/locator.dart";

class CleanUpService {
  final ApiService _apiService = locator<ApiService>();
  final Isar _isar = locator<Isar>();
  final GroupsRepository _groupsRepository = locator<GroupsRepository>();
  final KanaRepository _kanaRepository = locator<KanaRepository>();
  final KanjiRepository _kanjiRepository = locator<KanjiRepository>();
  final VocabularyRepository _vocabularyRepository =
      locator<VocabularyRepository>();

  Future<List<ResourceUid>> getSyncData({bool forceReload = false}) {
    final lastLoadedVersionGroups =
        _isar.groups.where().versionProperty().max();
    final lastLoadedVersionKanas = _isar.kanas.where().versionProperty().max();
    final lastLoadedVersionKanjis =
        _isar.kanjis.where().versionProperty().max();
    final lastLoadedVersionVocabulary =
        _isar.vocabularys.where().versionProperty().max();

    var versionQueryParam = "";
    if (!forceReload) {
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

  Future<void> executeCleanUp({bool forceReload = false}) async {
    final resourcesToDelete =
        await getSyncData(forceReload: forceReload);

    await Future.wait(resourcesToDelete.map((element) {
      switch (element.resourceType) {
        case ResourceType.group:
          return _groupsRepository.delete(element);
        case ResourceType.kana:
          return _kanaRepository.delete(element);
        case ResourceType.kanji:
          return _kanjiRepository.delete(element);
        case ResourceType.vocabulary:
          return _vocabularyRepository.delete(element);
      }
    }));
  }
}
