import 'package:http/http.dart' as http;
import 'package:kana_to_kanji/src/core/constants/app_configuration.dart';

class ApiService {
  Future<http.Response> get(String path) {
    return http.get(Uri.parse('${AppConfiguration.apiUrl}$path'));
  }
}
