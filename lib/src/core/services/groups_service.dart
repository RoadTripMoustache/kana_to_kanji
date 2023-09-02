import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:isar/isar.dart';
import 'package:kana_to_kanji/src/core/constants/alphabets.dart';
import 'package:kana_to_kanji/src/core/models/group.dart';
import 'package:kana_to_kanji/src/locator.dart';
import 'package:http/http.dart' as http;

class GroupsService {
  final Isar _isar = locator<Isar>();

  Future<List<Group>> getGroups(Alphabets alphabet, {bool reload = false}) async {
    debugPrint("GET GROUPS");
    final groups = _isar.groups.where().alphabetEqualTo(alphabet).findAll();

    if (reload || groups.isEmpty) {
      deleteAll();
      loadCollection();
      return _isar.groups.where().alphabetEqualTo(alphabet).findAll();
    }

    return groups;
  }

  void deleteAll() {
    _isar.groups.where().deleteAll();
  }

  void insertOne(Group group) {
    _isar.groups.put(group);
  }

  void loadCollection() {
    debugPrint("LOAD GROUPS");
    http
        .get(Uri.parse('http://localhost:8080/v1/groups'))
        .then((response) => _extractGroups(response))
        .then((listGroups) => {
      for (var group in listGroups) {
        insertOne(group)
      }
    });
  }

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