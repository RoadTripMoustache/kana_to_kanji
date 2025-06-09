import "dart:convert";

import "package:http/http.dart" as http;
import "package:kana_to_kanji/src/authentication/services/auth_service.dart";
import "package:kana_to_kanji/src/core/constants/app_configuration.dart";
import "package:kana_to_kanji/src/locator.dart";

class ApiService {
  final AuthService _authService = locator<AuthService>();

  /// get - Execute an HTTP GET request to the API using the path given in
  /// parameter. The authorization token is automatically injected in the
  /// headers.
  /// params :
  /// - path : String - Path of the API to call
  /// returns: The response of the HTTP request.
  Future<http.Response> get(String path) async => http.get(
    Uri.parse("${AppConfiguration.apiUrl}$path"),
    headers: {"Authorization": "Bearer ${await _authService.getAuthToken()}"},
  );

  /// patch - Execute an HTTP PATCH request to the API using the path given in
  /// parameter. The authorization token is automatically injected in the
  /// headers.
  /// params :
  /// - path : String - Path of the API to call
  /// - body : Object? - The body of the request, can be null, if not it must be
  ///     json encodable.
  /// returns: The response of the HTTP request.
  Future<http.Response> patch(String path, {Object? body}) async => http.patch(
    Uri.parse("${AppConfiguration.apiUrl}$path"),
    headers: {
      "Authorization": "Bearer ${await _authService.getAuthToken()}",
      "content-type": "application/json",
      "accept": "application/json",
    },
    body: jsonEncode(body),
  );
}
