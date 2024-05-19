// ignore_for_file: avoid_dynamic_calls
import "dart:convert";

import "package:http/http.dart" as http;
import "package:isar/isar.dart";
import "package:kana_to_kanji/src/core/models/kanji.dart";
import "package:kana_to_kanji/src/core/services/api_service.dart";
import "package:kana_to_kanji/src/core/utils/kana_utils.dart";
import "package:kana_to_kanji/src/locator.dart";

class KanjiDataLoader {
  final ApiService _apiService = locator<ApiService>();
  final Isar _isar = locator<Isar>();

  /// Load all the kanji from the API.
  /// If [forceReload] is true, the collection is cleared and populated again
  Future loadCollection({bool forceReload = false}) async {
    var versionQueryParam = "";

    // If force reload is needed, don't set the version and clear the collection
    if (forceReload) {
      await _isar.writeAsync((isar) => isar.kanjis.clear());
    } else {
      final lastLoadedVersion = _isar.kanjis.where().versionProperty().max();

      if (lastLoadedVersion != null) {
        versionQueryParam = "?version[current]=$lastLoadedVersion";
      }
    }

    return _apiService
        .get("/v1/kanjis?details=light$versionQueryParam")
        .then(_extractKanjis)
        .then((listKanji) =>
            _isar.write((isar) => isar.kanjis.putAll(listKanji)));
  }

  /// Extract all the kana from the API Response.
  List<Kanji> _extractKanjis(http.Response response) {
    if (response.statusCode == 200) {
      final List<Kanji> kanjis = [];
      final listKanji = jsonDecode(response.body);
      for (final k in listKanji["data"]) {
        if (k["meanings"] == null) {
          // TODO : To delete once "meanings" is not used anymore
          k["meanings"] = ["toto"];
        }
        if (k["on_readings"] == null) {
          // TODO : To delete once "on_readings" is not used anymore
          k["on_readings"] = ["ア"];
        }
        if (k["kun_readings"] == null) {
          // TODO : To delete once "on_readings" is not used anymore
          k["kun_readings"] = ["あ"];
        }
        k["jp_sort_syllables"] = [];
        if (k["kun_readings"] != null &&
            !k["kun_readings"].isEmpty &&
            k["kun_readings"][0] != "") {
          k["jp_sort_syllables"] = splitBySyllable(k["kun_readings"][0]);
        } else if (k["on_readings"] != null && !k["on_readings"].isEmpty) {
          k["jp_sort_syllables"] = splitBySyllable(k["on_readings"][0]);
        } else if (k["pronunciations"] != null &&
            !k["pronunciations"].isEmpty) {
          k["jp_sort_syllables"] =
              splitBySyllable(k["pronunciations"][0]["readings"][0]);
        }
        kanjis.add(Kanji.fromJson(k));
      }
      return kanjis;
    } else {
      // If the server did not return a 200 OK response,
      // then return an empty list.
      return List.empty();
    }
  }
}
