import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkService {
  static const int timeoutDuration = 30; // seconds
  
  static Future<dynamic> get(String url, {Map<String, String>? headers}) async {
    try {
      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(Duration(seconds: timeoutDuration));
      return _handleResponse(response);
    } on SocketException {
      throw Exception('No internet connection');
    } on TimeoutException {
      throw Exception('Request timed out');
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  static Future<dynamic> post(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(Duration(seconds: timeoutDuration));
      return _handleResponse(response);
    } on SocketException {
      throw Exception('No internet connection');
    } on TimeoutException {
      throw Exception('Request timed out');
    } catch (e) {
      throw Exception('Failed to submit data: $e');
    }
  }

  static dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonDecode(response.body);
      case 400:
        throw Exception('Bad request: ${response.body}');
      case 401:
        throw Exception('Unauthorized: Please login again');
      case 403:
        throw Exception('Access denied');
      case 404:
        throw Exception('Resource not found');
      case 500:
        throw Exception('Server error. Please try again later');
      default:
        throw Exception('Failed with status code: ${response.statusCode}');
    }
  }

  static bool hasInternetConnection = true;
  static StreamController<bool> connectivityController = StreamController<bool>.broadcast();

  static void updateConnectivity(bool isConnected) {
    hasInternetConnection = isConnected;
    connectivityController.add(isConnected);
  }

  static Stream<bool> get connectivityStream => connectivityController.stream;
}
