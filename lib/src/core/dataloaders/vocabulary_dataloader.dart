// ignore_for_file: avoid_dynamic_calls
import "dart:convert";

import "package:http/http.dart" as http;
import "package:isar/isar.dart";
import "package:kana_to_kanji/src/core/models/vocabulary.dart";
import "package:kana_to_kanji/src/core/services/api_service.dart";
import "package:kana_to_kanji/src/core/utils/kana_utils.dart";
import "package:kana_to_kanji/src/locator.dart";

class VocabularyDataLoader {
  final ApiService _apiService = locator<ApiService>();
  final Isar _isar = locator<Isar>();

  /// Load all the vocabulary from the API.
  /// If [forceReload] is true, the collection is cleared and populated again
  Future loadCollection({bool forceReload = false}) async {
    var versionQueryParam = "";

    // If force reload is needed, don't set the version and clear the collection
    if (forceReload) {
      await _isar.writeAsync((isar) => isar.vocabularys.clear());
    } else {
      final lastLoadedVersion =
          _isar.vocabularys.where().versionProperty().max();

      if (lastLoadedVersion != null) {
        versionQueryParam = "?version[current]=$lastLoadedVersion";
      }
    }

    return _apiService
        .get("/v1/vocabulary$versionQueryParam")
        .then(_extractVocabulary)
        .then((listVocabulary) =>
            _isar.write((isar) => isar.vocabularys.putAll(listVocabulary)));
  }

  /// Extract all the vocabulary from the API Response.
  List<Vocabulary> _extractVocabulary(http.Response response) {
    if (response.statusCode == 200) {
      final List<Vocabulary> vocabulary = [];
      final listVocabulary = jsonDecode(response.body);
      for (final k in listVocabulary["data"]) {
        if (k["meanings"] == null) {
          // TODO : Delete once "meanings" is not used anymore
          k["meanings"] = ["toto"];
        }

        k["kana_syllables"] = splitBySyllable(k["kana"]);
        vocabulary.add(Vocabulary.fromJson(k));
      }
      return vocabulary;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return List.empty();
    }
  }
}
