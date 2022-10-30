import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  late String? baseUrl;
  late Map<String, String> headers;

  ApiService() {
    baseUrl = 'https://63036a359eb72a839d802cc4.mockapi.io/';
    headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
  }

  String? getBaseUrl() {
    return baseUrl;
  }

  Future<http.Response> get(String endpoint, {Map<String, String>? queryParameters}) async {
    try {
      var uri = Uri.parse(baseUrl! + endpoint).replace(queryParameters: queryParameters);
      http.Response response = await http.get(uri, headers: headers).timeout(const Duration(seconds: 300));

      return response;
    } catch (e) {
      throw "Ocorreu um erro, tente novamente.";
    }
  }

  Future<dynamic> post(String path, body) async {
    try {
      var uri = Uri.parse(baseUrl! + path);
      var response = await http.post(uri, headers: headers, body: jsonEncode(body));

      return response;
    } catch (e) {
      throw "Ocorreu um erro, tente novamente.";
    }
  }

  Future<dynamic> put(String endpoint, body) async {
    try {
      var uri = Uri.parse(baseUrl! + endpoint);
      var response = await http.put(uri, headers: headers, body: jsonEncode(body)).timeout(const Duration(seconds: 300));

      return response;
    } catch (e) {
      throw "Ocorreu um erro, tente novamente.";
    }
  }

  Future<dynamic> delete(String endpoint) async {
    try {
      var uri = Uri.parse(baseUrl! + endpoint);
      var response = await http.delete(uri, headers: headers).timeout(const Duration(seconds: 300));

      return response;
    } catch (e) {
      throw "Ocorreu um erro, tente novamente.";
    }
  }
}
