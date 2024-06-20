// ignore_for_file: avoid_dynamic_calls
import "dart:convert";

import "package:http/http.dart" as http;
import "package:isar/isar.dart";
import "package:kana_to_kanji/src/core/models/user.dart";
import "package:kana_to_kanji/src/core/services/api_service.dart";
import "package:kana_to_kanji/src/locator.dart";

class UserDataLoader {
  final ApiService _apiService = locator<ApiService>();
  final Isar _isar = locator<Isar>();

  /// Load all the user data from the API.
  Future loadCollection() async =>
      _apiService.get("/v1/user").then(_extractUser).then((user) {
        if (user != null) {
          _isar.write((isar) => isar.users.put(user));
        }
      });

  /// Update the user data to the API.
  Future<bool> patchUser(Map<String, dynamic> extra) async => _apiService
      .patch("/v1/user", json.encode(extra))
      .then((response) => response.statusCode == 200);

  /// Delete the user data to the API.
  /// Returns true if the deletion is a success. Otherwise, false.
  Future<bool> deleteUser() async => _apiService
      .delete("/v1/user")
      .then((response) => response.statusCode == 200);

  /// Extract the user from the API Response.
  User? _extractUser(http.Response response) {
    if (response.statusCode == 200) {
      final jsonUser = jsonDecode(response.body);
      return User.fromJson(jsonUser);
    } else {
      // If the server did not return a 200 OK response,
      // then return `null`.
      return null;
    }
  }
}
