import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api';

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<Map<String, String>> _getHeaders({bool withAuth = true}) async {
    final token = await _getToken();
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (withAuth && token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  static dynamic _parseBody(String? body) {
    if (body == null || body.isEmpty) return null;
    try {
      return json.decode(body);
    } catch (_) {
      return body;
    }
  }

  static dynamic _handleResponse(http.Response response) {
    final body = _parseBody(response.body);
    print('API Response: ${response.statusCode} - $body');

    switch (response.statusCode) {
      case 200:
      case 201:
        return body;
      case 400:
        final errorMsg = body is Map ? body['message'] ?? 'Bad request' : 'Bad request';
        throw Exception(errorMsg.toString());
      case 401:
        _clearToken();
        throw Exception('Authentication failed. Please login again.');
      case 403:
        throw Exception('Access forbidden. Admin role required.');
      case 404:
        throw Exception('Resource not found');
      case 409:
        final errorMsg = body is Map ? body['message'] ?? 'Conflict' : 'Conflict';
        throw Exception(errorMsg.toString());
      case 422:
        final errorMsg = body is Map ? body['message'] ?? 'Validation failed' : 'Validation failed';
        throw Exception(errorMsg.toString());
      case 500:
        throw Exception('Server error. Please try again later.');
      default:
        throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  static Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userRole');
  }

  static Future<dynamic> login(String email, String password )async {
    try {
      final uri = Uri.parse('$baseUrl/auth/login');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> register(String email, String password) async {
    try {
      final uri = Uri.parse('$baseUrl/auth/register');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<dynamic>> getProducts() async {
    try {
      final headers = await _getHeaders();
      final uri = Uri.parse('$baseUrl/products');
      final response = await http.get(uri, headers: headers);

      final result = _handleResponse(response);
      return result is List ? result : [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<dynamic>> getUserOrders() async {
    try {
      final headers = await _getHeaders();
      final uri = Uri.parse('$baseUrl/orders/my-orders');
      final response = await http.get(uri, headers: headers);

      final result = _handleResponse(response);
      return result is List ? result : [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> createOrder(List<Map<String, dynamic>> items) async {
    try {
      final headers = await _getHeaders();
      final uri = Uri.parse('$baseUrl/orders');

      // Debug: Print the items we're sending
      print('Order items to send: $items');

      final response = await http.post(
        uri,
        headers: headers,
        body: json.encode(items),
      );

      return _handleResponse(response);
    } catch (e) {
      print('Error creating order: $e');
      rethrow;
    }
  }

  static Future<List<dynamic>> getAllOrders() async {
    try {
      final headers = await _getHeaders();
      final uri = Uri.parse('$baseUrl/admin/orders');
      final response = await http.get(uri, headers: headers);

      final result = _handleResponse(response);
      return result is List ? result : [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<dynamic>> getLowStockProducts({int threshold = 5}) async {
    try {
      final headers = await _getHeaders();
      final uri = Uri.parse('$baseUrl/admin/low-stock?threshold=$threshold');
      final response = await http.get(uri, headers: headers);

      final result = _handleResponse(response);
      return result is List ? result : [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> addProduct(Map<String, dynamic> product) async {
    try {
      final headers = await _getHeaders();
      final uri = Uri.parse('$baseUrl/products');
      final response = await http.post(
          uri,
          headers: headers,
          body: json.encode(product)
      );

      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> updateProduct(int productId, Map<String, dynamic> product) async {
    try {
      final headers = await _getHeaders();
      final uri = Uri.parse('$baseUrl/products/$productId');
      final response = await http.put(
          uri,
          headers: headers,
          body: json.encode(product)
      );

      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }
  static Future<dynamic> deleteProduct(int productId) async {
    try {
      final headers = await _getHeaders();
      final uri = Uri.parse('$baseUrl/products/$productId');

      print('DELETE request to: $uri');
      print('Headers: $headers');

      final response = await http.delete(uri, headers: headers);

      // Add detailed error logging
      print('DELETE response status: ${response.statusCode}');
      print('DELETE response body: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      print('Error in deleteProduct: $e');
      rethrow;
    }
  }
}