import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import '../models/user_model.dart';

class AuthService {
  static const String _tokenKey = 'token';
  static const String _userKey = 'user';

  // Test backend connectivity
  static Future<bool> testBackendConnection() async {
    try {
      final response = await ApiService.get('/api/auth/test');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Register user and send OTP
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String fullName,
    required String role,
  }) async {
    try {
      debugPrint('Starting registration for email: $email');
      
      // Test connection first
      final isConnected = await testBackendConnection();
      debugPrint('Backend connection test: $isConnected');
      
      if (!isConnected) {
        debugPrint('Backend connection failed');
        return {
          'success': false,
          'message': 'Cannot connect to server. Please check your internet connection and try again.',
          'networkError': true,
        };
      }

      debugPrint('Sending registration request...');
      final response = await ApiService.post('/api/auth/register', {
        'email': email,
        'password': password,
        'fullName': fullName,
        'role': role,
      });

      debugPrint('Registration response status: ${response.statusCode}');
      debugPrint('Registration response body: ${response.body}');

      final data = jsonDecode(response.body);
      debugPrint('Backend registration response: $data');
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        // For registration, we expect needsVerification to be true
        // and no token until OTP is verified
        debugPrint('Registration successful, returning success response');
        return {
          'success': true,
          'message': data['message'] ?? 'Registration successful',
          'needsVerification': data['needsVerification'] ?? true, // Default to true for registration
          'userId': data['userId'],
        };
      } else {
        debugPrint('Registration failed with status: ${response.statusCode}');
        return {
          'success': false,
          'message': data['message'] ?? 'Registration failed',
          'needsVerification': data['needsVerification'] ?? false,
        };
      }
    } catch (e) {
      debugPrint('Registration error: $e');
      return {
        'success': false,
        'message': 'Network error: $e',
        'networkError': true,
      };
    }
  }

  // Verify OTP
  static Future<Map<String, dynamic>> verifyOTP({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await ApiService.post('/api/auth/verify-otp', {
        'email': email,
        'otp': otp,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _saveToken(data['token']);
        await _saveUser(data['user']);
        return {
          'success': true,
          'message': data['message'],
          'user': UserModel.fromJson(data['user']),
        };
      } else {
        final error = jsonDecode(response.body);
        return {'success': false, 'message': error['message'] ?? 'OTP verification failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Resend OTP
  static Future<Map<String, dynamic>> resendOTP({
    required String email,
  }) async {
    try {
      final response = await ApiService.post('/api/auth/resend-otp', {
        'email': email,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'],
        };
      } else {
        final error = jsonDecode(response.body);
        return {'success': false, 'message': error['message'] ?? 'Failed to resend OTP'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Login user
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiService.post('/api/auth/login', {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _saveToken(data['token']);
        await _saveUser(data['user']);
        return {
          'success': true,
          'message': data['message'],
          'user': UserModel.fromJson(data['user']),
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false, 
          'message': error['message'] ?? 'Login failed',
          'needsVerification': error['needsVerification'] ?? false,
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Forgot password
  static Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    try {
      final response = await ApiService.post('/api/auth/forgot-password', {
        'email': email,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'],
        };
      } else {
        final error = jsonDecode(response.body);
        return {'success': false, 'message': error['message'] ?? 'Failed to send reset email'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Reset password with OTP
  static Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final response = await ApiService.post('/api/auth/reset-password', {
        'email': email,
        'otp': otp,
        'newPassword': newPassword,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'],
        };
      } else {
        final error = jsonDecode(response.body);
        return {'success': false, 'message': error['message'] ?? 'Password reset failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Google Sign In
  static Future<Map<String, dynamic>> googleSignIn() async {
    try {
      // This will be implemented with the google_sign_in package
      // For now, we'll return a placeholder
      return {'success': false, 'message': 'Google sign in not implemented yet'};
    } catch (e) {
      return {'success': false, 'message': 'Google sign in error: $e'};
    }
  }

  // Logout user
  static Future<Map<String, dynamic>> logout() async {
    try {
      await ApiService.post('/api/auth/logout', {});
      await _clearToken();
      await _clearUser();
      return {'success': true, 'message': 'Logged out successfully'};
    } catch (e) {
      return {'success': false, 'message': 'Logout error: $e'};
    }
  }

  // Get user profile
  static Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await ApiService.get('/api/auth/profile');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true, 
          'user': UserModel.fromJson(data['user']),
        };
      } else {
        return {'success': false, 'message': 'Failed to get profile'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey) != null;
  }

  // Get stored token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Get stored user
  static Future<UserModel?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userString = prefs.getString(_userKey);
      if (userString != null && userString.isNotEmpty) {
        final userData = jsonDecode(userString);
        return UserModel.fromJson(userData);
      }
      return null;
    } catch (e) {
      // If there's an error parsing the user data, clear it and return null
      await _clearUser();
      return null;
    }
  }

  // Private methods for token and user management
  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<void> _saveUser(Map<String, dynamic> user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = jsonEncode(user);
      await prefs.setString(_userKey, userJson);
    } catch (e) {
      // If there's an error saving user data, clear it
      await _clearUser();
    }
  }

  static Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  static Future<void> _clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
} 