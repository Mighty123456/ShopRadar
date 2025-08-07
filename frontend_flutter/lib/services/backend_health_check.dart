import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'network_config.dart';

class BackendHealthCheck {
  // Check if backend is running and accessible
  static Future<bool> isBackendHealthy() async {
    try {
      final response = await http.get(
        Uri.parse('${NetworkConfig.baseUrl}/health'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));
      
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('[BackendHealthCheck] Health check failed: $e');
      return false;
    }
  }
  
  // Test authentication endpoint
  static Future<bool> isAuthEndpointAccessible() async {
    try {
      final response = await http.get(
        Uri.parse('${NetworkConfig.baseUrl}/api/auth/test'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));
      
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('[BackendHealthCheck] Auth endpoint test failed: $e');
      return false;
    }
  }
  
  // Get detailed backend status
  static Future<Map<String, dynamic>> getBackendStatus() async {
    final status = <String, dynamic>{
      'timestamp': DateTime.now().toIso8601String(),
      'baseUrl': NetworkConfig.baseUrl,
      'isHealthy': false,
      'isAuthAccessible': false,
      'issues': <String>[],
      'solutions': <String>[],
    };
    
    try {
      // Test health endpoint
      status['isHealthy'] = await isBackendHealthy();
      
      // Test auth endpoint
      status['isAuthAccessible'] = await isAuthEndpointAccessible();
      
      // Add issues and solutions based on results
      if (!status['isHealthy']) {
        status['issues'].add('Backend server is not responding');
        status['solutions'].addAll([
          'Start the backend server: cd backend_node && npm start',
          'Check if port 3000 is available',
          'Verify MongoDB connection',
          'Check .env file configuration',
        ]);
      }
      
      if (!status['isAuthAccessible']) {
        status['issues'].add('Authentication endpoints are not accessible');
        status['solutions'].addAll([
          'Ensure backend server is running',
          'Check if auth routes are properly configured',
          'Verify database connection',
        ]);
      }
      
    } catch (e) {
      status['issues'].add('Error during health check: $e');
    }
    
    return status;
  }
  
  // Get quick status message
  static Future<String> getQuickStatus() async {
    final isHealthy = await isBackendHealthy();
    final isAuthAccessible = await isAuthEndpointAccessible();
    
    if (isHealthy && isAuthAccessible) {
      return '✅ Backend server is healthy and accessible';
    } else if (isHealthy && !isAuthAccessible) {
      return '⚠️ Backend is running but auth endpoints are not accessible';
    } else {
      return '❌ Backend server is not accessible';
    }
  }
  
  // Test specific URL
  static Future<bool> testUrl(String url) async {
    try {
      final response = await http.get(
        Uri.parse('$url/health'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));
      
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('[BackendHealthCheck] Failed to test URL $url: $e');
      return false;
    }
  }
} 