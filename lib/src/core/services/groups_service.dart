import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:isar/isar.dart';
import 'package:kana_to_kanji/src/core/constants/alphabets.dart';
import 'package:kana_to_kanji/src/core/models/group.dart';
import 'package:kana_to_kanji/src/core/services/api_service.dart';
import 'package:kana_to_kanji/src/locator.dart';
import 'package:http/http.dart' as http;

class GroupsService {
  final Isar _isar = locator<Isar>();
  final ApiService _apiService = locator<ApiService>();

  Future<List<Group>> getGroups(Alphabets alphabet,
      {bool reload = false}) async {
    final groups = _isar.groups.where().alphabetEqualTo(alphabet).findAll();

    if (reload || groups.isEmpty) {
      deleteAll();
      return loadCollection().then(
          (_) => _isar.groups.where().alphabetEqualTo(alphabet).findAll());
    }

    return Future.value(groups);
  }

  void deleteAll() {
    _isar.write((isar) => {isar.groups.where().deleteAll()});
  }

  void insertOne(Group group) {
    _isar.write((isar) => isar.groups.put(group));
  }

  Future<dynamic> loadCollection() {
    return _apiService
        .get('/v1/groups')
        .then((response) => _extractgroups(response))
        .then((listGroups) =>
            _isar.write((isar) => isar.groups.putAll(listGroups)));
  }

  List<Group> _extractgroups(http.Response response) {
    if (response.statusCode == 200) {
      List<Group> groups = [];
      var listgroups = jsonDecode(response.body);
      for (final g in listgroups) {
        groups.add(Group.fromJson(g));
      }
      return groups;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return List.empty();
    }
  }
}
