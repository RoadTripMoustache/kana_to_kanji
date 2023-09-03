import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:kana_to_kanji/src/core/constants/alphabets.dart';
import 'package:kana_to_kanji/src/core/models/group.dart';
import 'package:kana_to_kanji/src/core/services/api_service.dart';
import 'package:kana_to_kanji/src/locator.dart';
import 'package:http/http.dart' as http;

class GroupsService {
  final Isar _isar = locator<Isar>();
  final ApiService _apiService = locator<ApiService>();

  /// Get all the groups related to the alphabet given in parameter.
  Future<List<Group>> getGroups(Alphabets alphabet, {bool reload = false}) async {
    final groups = _isar.groups.where().alphabetEqualTo(alphabet).findAll();

    if (reload || groups.isEmpty) {
      deleteAll();
      return loadCollection().then(
          (_) => _isar.groups.where().alphabetEqualTo(alphabet).findAll());
    }

    return Future.value(groups);
  }

  /// Delete all the groups.
  void deleteAll() {
    _isar.write((isar) => {isar.groups.where().deleteAll()});
  }

  /// Load all the groups from the API.
  Future<dynamic> loadCollection() {
    return _apiService
        .get('/v1/groups')
        .then((response) => _extractGroups(response))
        .then((listGroups) => _isar.write((isar) => isar.groups.putAll(listGroups)) );
  }

  /// Extract all the groups
  /// from the API Response.
  List<Group> _extractGroups(http.Response response) {
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
