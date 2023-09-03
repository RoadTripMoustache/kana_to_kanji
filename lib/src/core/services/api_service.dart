import 'package:http/http.dart' as http;

class ApiService {
  Future<http.Response> get(String path) {
    return http.get(Uri.parse('http://10.0.2.2:8080$path')); // TODO : Move into a configuration
  }
}
