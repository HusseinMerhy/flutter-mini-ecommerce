import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _email;
  String? _userId;
  String? _role;
  bool _isLoading = false;

  String? get token => _token;
  String? get email => _email;
  String? get userId => _userId;
  String? get role => _role;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _loadAuthData();
  }

  Future<void> _loadAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    _email = prefs.getString('userEmail');
    _userId = prefs.getString('userId');
    _role = prefs.getString('userRole');
    notifyListeners();
  }

  // Update the isAdmin getter to handle different role formats
  bool get isAdmin {
    if (_role == null) return false;

    // Check for various possible admin role representations
    final adminRoles = ['ROLE_ADMIN', 'ADMIN', 'ROLE_ADMINISTRATOR', 'ADMINISTRATOR'];
    return adminRoles.contains(_role!.toUpperCase());
  }

// Update the login method to ensure proper role extraction
  Future<bool> login(String email, String password) async {
    setLoading(true);
    try {
      final response = await ApiService.login(email, password);
      print('Login response: $response');

      final prefs = await SharedPreferences.getInstance();
      final token = response['token'];

      await prefs.setString('token', token);
      await prefs.setString('userEmail', email);

      // Enhanced role extraction
      String role = 'ROLE_USER'; // Default role

      try {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        dynamic rolesClaim = decodedToken['roles'];

        if (rolesClaim is String) {
          List<String> roles = rolesClaim.split(',').map((r) => r.trim().toUpperCase()).toList();
          role = roles.isNotEmpty ? roles[0] : 'ROLE_USER';
        } else if (rolesClaim is List) {
          role = rolesClaim.isNotEmpty ? rolesClaim[0].toString().toUpperCase() : 'ROLE_USER';
        }

        print('Extracted role from token: $role');
      } catch (e) {
        print('Error decoding token: $e');
        // Fallback to response data
        final userData = response['user'] ?? response;
        role = userData['role']?.toString()?.toUpperCase() ?? 'ROLE_USER';
        print('Extracted role from response: $role');
      }

      await prefs.setString('userRole', role);
      _role = role;

      final userId = response['id']?.toString() ?? response['user']?['id']?.toString();
      if (userId != null) {
        await prefs.setString('userId', userId);
        _userId = userId;
      }

      _token = token;
      _email = email;

      setLoading(false);
      return true;
    } catch (error) {
      setLoading(false);
      rethrow;
    }
  }
  Future<bool> register(String email, String password) async {
    setLoading(true);
    try {
      final response = await ApiService.register(email, password);
      // Try to login after successful registration
      final loginResult = await login(email, password);
      setLoading(false);
      return loginResult;
    } catch (error) {
      setLoading(false);
      rethrow;
    }
  }
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userEmail');
    await prefs.remove('userId');
    await prefs.remove('userRole');

    _token = null;
    _email = null;
    _userId = null;
    _role = null;

    notifyListeners();
  }
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  bool get isAuthenticated => _token != null;
}
