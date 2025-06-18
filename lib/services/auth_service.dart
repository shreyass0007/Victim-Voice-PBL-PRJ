import 'package:shared_preferences/shared_preferences.dart';
import 'package:victim_voice/utils/validation_utils.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userEmailKey = 'userEmail';
  static const String _userTokenKey = 'userToken';

  Future<bool> login({required String email, required String password}) async {
    try {
      debugPrint('Login attempt - Email: $email, Password: $password');

      // Validate email format
      if (!ValidationUtils.isValidEmail(email)) {
        debugPrint('Email validation failed');
        return false;
      }

      // Validate password
      if (ValidationUtils.validatePassword(password) != null) {
        debugPrint('Password validation failed');
        return false;
      }

      // TODO: Replace with actual API call
      final response = await _authenticateUser(email.trim(), password);
      debugPrint('Auth response: ${response.success}');
      
      if (response.success) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_isLoggedInKey, true);
        await prefs.setString(_userEmailKey, email);
        await prefs.setString(_userTokenKey, response.token ?? '');
        debugPrint('Login successful');
        return true;
      }
      debugPrint('Login failed - invalid credentials');
      return false;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_userTokenKey);
      return (prefs.getBool(_isLoggedInKey) ?? false) && token != null;
    } catch (e) {
      return false;
    }
  }

  Future<String?> getUserEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userEmailKey);
    } catch (e) {
      return null;
    }
  }

  Future<AuthResponse> _authenticateUser(String email, String password) async {
    // For development, use hardcoded credentials
    // In production, this should be replaced with actual API authentication
    final inputEmail = email.toLowerCase();
    final validEmail = 'shreshshende.777@gmail.com';
    final validPassword = 'admin123';

    debugPrint('Comparing emails:');
    debugPrint('Input email: $inputEmail');
    debugPrint('Valid email: $validEmail');
    debugPrint('Password match: ${password == validPassword}');

    if (inputEmail == validEmail && password == validPassword) {
      return AuthResponse(true, 'dummy-token-${DateTime.now().millisecondsSinceEpoch}');
    }
    return AuthResponse(false, null);
  }
}

class AuthResponse {
  final bool success;
  final String? token;
  
  AuthResponse(this.success, this.token);
}
