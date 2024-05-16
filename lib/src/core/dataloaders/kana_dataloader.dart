import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/core/services/api_service.dart';
import 'package:kana_to_kanji/src/locator.dart';
import 'package:http/http.dart' as http;

class KanaDataLoader {
  final ApiService _apiService = locator<ApiService>();
  final Isar _isar = locator<Isar>();

  /// Load all the kana from the API.
  Future loadCollection(bool needForceReload) async {
    var versionQueryParam = "";

    if (needForceReload) {
      // If force reload is needed, don't set the version and clear the collection.
      await _isar.writeAsync((isar) {
        return isar.kanas.clear();
      });
    } else {
      var lastLoadedVersion = _isar.kanas.where().versionProperty().max();

      if (lastLoadedVersion != null) {
        versionQueryParam = "?version[current]=$lastLoadedVersion";
      }
    }

    return _apiService
        .get('/v1/kanas$versionQueryParam')
        .then((response) => _extractKanas(response))
        .then((listKana) => _isar.write((isar) => isar.kanas.putAll(listKana)));
  }

  /// Extract all the kana from the API Response.
  List<Kana> _extractKanas(http.Response response) {
    if (response.statusCode == 200) {
      List<Kana> kanas = [];
      var listKana = jsonDecode(response.body);
      for (final k in listKana) {
        kanas.add(Kana.fromJson(k));
      }
      return kanas;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return List.empty();
    }
  }
}
