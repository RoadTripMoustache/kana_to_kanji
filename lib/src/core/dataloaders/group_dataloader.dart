import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:isar/isar.dart';
import 'package:kana_to_kanji/src/core/models/group.dart';
import 'package:kana_to_kanji/src/core/services/api_service.dart';
import 'package:kana_to_kanji/src/locator.dart';

class GroupDataLoader {
  final ApiService _apiService = locator<ApiService>();
  final Isar _isar = locator<Isar>();

  /// Load all the groups from the API.
  Future loadCollection(bool needForceReload) async {
    var versionQueryParam = "";

    if (needForceReload) {
      // If force reload is needed, don't set the version and clear the collection.
      await _isar.writeAsync((isar) {
        return isar.groups.clear();
      });
    } else {
      var lastLoadedVersion = _isar.groups.where().versionProperty().max();

      if (lastLoadedVersion != null) {
        versionQueryParam = "?version[current]=$lastLoadedVersion";
      }
    }

    return _apiService
        .get('/v1/groups$versionQueryParam')
        .then((response) => _extractGroups(response))
        .then((listGroups) =>
            _isar.write((isar) => isar.groups.putAll(listGroups)));
  }

  /// Extract all the groups
  /// from the API Response.
  List<Group> _extractGroups(http.Response response) {
    if (response.statusCode == 200) {
      List<Group> groups = [];
      var listGroups = jsonDecode(response.body);
      for (final g in listGroups) {
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
