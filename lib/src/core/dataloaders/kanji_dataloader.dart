import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:kana_to_kanji/src/core/models/kanji.dart';
import 'package:kana_to_kanji/src/core/services/api_service.dart';
import 'package:kana_to_kanji/src/core/utils/kana_utils.dart';
import 'package:kana_to_kanji/src/locator.dart';
import 'package:http/http.dart' as http;

class KanjiDataLoader {
  final ApiService _apiService = locator<ApiService>();
  final Isar _isar = locator<Isar>();

  /// Load all the kanji from the API.
  Future loadCollection() async {
    var lastLoadedVersion = _isar.kanjis.where().versionProperty().max();

    var versionQueryParam = "";
    if (lastLoadedVersion != null) {
      versionQueryParam = "&version[current]=$lastLoadedVersion";
    }
    return _apiService
        .get('/v1/kanjis?details=light$versionQueryParam')
        .then((response) => _extractKanjis(response))
        .then((listKanji) =>
            _isar.write((isar) => isar.kanjis.putAll(listKanji)));
  }

  /// Extract all the kana from the API Response.
  List<Kanji> _extractKanjis(http.Response response) {
    if (response.statusCode == 200) {
      List<Kanji> kanjis = [];
      var listKanji = jsonDecode(response.body);
      for (final k in listKanji) {
        if (k["kun_readings"][0] != "") {
          k["jp_sort_syllables"] = splitBySyllable(k["kun_readings"][0]);
        } else {
          k["jp_sort_syllables"] = splitBySyllable(k["on_readings"][0]);
        }
        kanjis.add(Kanji.fromJson(k));
      }
      return kanjis;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return List.empty();
    }
  }
}
