import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiConfig {
  static String url = 'http://localhost:3005';
  static String token = '';
}


class ApiException implements Exception {
  final String message;
  ApiException(this.message);
}

class Api {
  final http.Client httpClient;
  Api({http.Client? client}) : httpClient = client ?? http.Client();

  Future<dynamic> _makeRequest(Future<http.Response> Function() request) async {
    try {
      final response = await request();
        print(response.body);
        var data = json.decode(response.body);
        return data;
    } catch (e) {
      print("error: $e");
      throw ApiException('Failed to make request: $e');
    }
  }

  Future<dynamic> get(String route) async {
    return _makeRequest(() => httpClient.get(
          Uri.parse('${ApiConfig.url}$route'),
          headers: {'Authorization': 'Bearer ${ApiConfig.token}'},
        ));
  }

  Future<dynamic> post(String route, data) async {
    return _makeRequest(() => httpClient.post(
          Uri.parse('${ApiConfig.url}$route'),
          body: data,
          headers: {'Authorization': 'Bearer ${ApiConfig.token}'},
        ));
  }

  Future<dynamic> patch(String route, Map data) async {
    return _makeRequest(() => httpClient.patch(
          Uri.parse('${ApiConfig.url}$route'),
          body: data,
          headers: {'Authorization': 'Bearer ${ApiConfig.token}'},
        ));
  }

  Future<dynamic> delete(String route) async {
    return _makeRequest(() => httpClient.delete(
          Uri.parse('${ApiConfig.url}$route'),
          headers: {'Authorization': 'Bearer ${ApiConfig.token}'},
        ));
  }

  static setToken(String newToken) {
    ApiConfig.token = newToken;
    print("api token: " + ApiConfig.token);
  }

  static setTokenFromJson(Map<String, dynamic> json) {
    ApiConfig.token = json['token'];
  }
}

