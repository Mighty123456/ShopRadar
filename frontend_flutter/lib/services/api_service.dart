import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'network_config.dart';

class ApiService {
  // static const String baseUrl = 'http://10.0.2.2:3000'; // For Android emulator
   static const String baseUrl = 'http://localhost:3000'; // For iOS simulator
 // static const String baseUrl = 'http://192.168.6.56:3000'; // For physical device
  // Use network configuration helper
  static String get baseUrl => NetworkConfig.baseUrl;
  
  // Test connectivity before making requests
  static Future<bool> _testConnectivity() async {
    return await NetworkConfig.testConnectivity();
  }

  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<http.Response> get(String endpoint) async {
    try {
      // Test connectivity first
      final isConnected = await _testConnectivity();
      if (!isConnected) {
        throw Exception('Cannot connect to server. Please check your internet connection and try again.');
      }
      
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      ).timeout(const Duration(seconds: 30)); // Increased timeout
      return response;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    try {
      // Test connectivity first
      final isConnected = await _testConnectivity();
      if (!isConnected) {
        throw Exception('Cannot connect to server. Please check your internet connection and try again.');
      }
      
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 30)); // Increased timeout
      return response;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<http.Response> put(String endpoint, Map<String, dynamic> data) async {
    try {
      // Test connectivity first
      final isConnected = await _testConnectivity();
      if (!isConnected) {
        throw Exception('Cannot connect to server. Please check your internet connection and try again.');
      }
      
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 30)); // Increased timeout
      return response;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<http.Response> delete(String endpoint) async {
    try {
      // Test connectivity first
      final isConnected = await _testConnectivity();
      if (!isConnected) {
        throw Exception('Cannot connect to server. Please check your internet connection and try again.');
      }
      
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      ).timeout(const Duration(seconds: 30)); // Increased timeout
      return response;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await post('/api/auth/login', {
        'email': email,
        'password': password,
      });
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['token'] != null) {
        return {'success': true, 'token': data['token']};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> register(String email, String password) async {
    try {
      final response = await post('/api/auth/register', {
        'email': email,
        'password': password,
      });
      final data = jsonDecode(response.body);
      if ((response.statusCode == 201 || response.statusCode == 200) && data['token'] != null) {
        return {'success': true, 'token': data['token']};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Registration failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
} 
