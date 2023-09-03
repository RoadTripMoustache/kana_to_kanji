import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:isar/isar.dart';
import 'package:kana_to_kanji/src/core/constants/alphabets.dart';
import 'package:kana_to_kanji/src/core/models/group.dart';
import 'package:kana_to_kanji/src/locator.dart';
import 'package:http/http.dart' as http;

class ApiService {

  Future<http.Response> get(String path) {
    return http.get(Uri.parse('http://10.0.2.2:8080$path'));
  }

}