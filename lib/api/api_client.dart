import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiClient {
  static Future<http.Response> authenticate({
    required String login,
    required String password,
  }) {
    return http.post(
      Uri.parse('${ApiConfig.baseUrl}/patient'),
      headers: {'Accept': 'application/json'},
      body: {
        'login': login,
        'pass': password,
      },
    );
  }

  static Future<http.Response> registerPatient({
    required String login,
    required String password,
    required String phoneNumber,
  }) {
    return http.post(
      Uri.parse('${ApiConfig.baseUrl}/inscrire'),
      headers: {'Accept': 'application/json'},
      body: {
        'login': login,
        'password': password,
        'numTele': phoneNumber,
      },
    );
  }

  static Future<http.Response> getUser(String id) {
    return http.post(
      Uri.parse('${ApiConfig.baseUrl}/user'),
      headers: {'Accept': 'application/json'},
      body: {'id': id},
    );
  }
}
