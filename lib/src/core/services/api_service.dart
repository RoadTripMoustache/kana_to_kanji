import "package:http/http.dart" as http;
import "package:kana_to_kanji/src/core/constants/app_configuration.dart";
import "package:kana_to_kanji/src/core/services/token_service.dart";
import "package:kana_to_kanji/src/locator.dart";

class ApiService {
  final TokenService _tokenService = locator<TokenService>();

  /// get - Execute an HTTP GET request to the API using the path given in
  /// parameter. The authorization token is automatically injected in the
  /// headers.
  /// params :
  /// - path : String - Path of the API to call
  /// returns : Future<http.Response> - The response of the HTTP request.
  Future<http.Response> get(String path) async => http.get(
      Uri.parse("${AppConfiguration.apiUrl}$path"),
      headers: {"Authorization": "Bearer ${await _tokenService.getToken()}"});
}
