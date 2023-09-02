import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/locator.dart';
import 'package:http/http.dart' as http;

class KanaService {
  final Isar _isar = locator<Isar>();

  Future<List<Kana>> getByGroupIds(List<int> groupIds) async {
    dynamic kanaQuery = _isar.kanas.where();

    for (var i = 0; i < groupIds.length; i++) {
      if (i > 0) {
        kanaQuery = kanaQuery.or();
      }

      kanaQuery = kanaQuery.groupIdEqualTo(groupIds[i]);
    }

    final kanas = kanaQuery.findAll();

    if (kanas.isEmpty) {
      deleteAll();
      loadCollection();
      return kanaQuery.findAll();
    }

    return kanas;
  }

  Future<List<Kana>> getByGroupId(int groupId) async {
    return getByGroupIds([groupId]);
  }

  void deleteAll() {
    _isar.kanas.where().deleteAll();
  }

  void insertOne(Kana kana) {
    _isar.kanas.put(kana);
  }

  void loadCollection() {
    http
        .get(Uri.parse('http://localhost:8080/v1/kanas'))
        .then((response) => _extractKanas(response))
        .then((listKana) => {
      for (var kana in listKana) {
        insertOne(kana)
      }
    });
  }

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
