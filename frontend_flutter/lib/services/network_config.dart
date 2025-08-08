import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class NetworkConfig {
  // Network environment types
  static const String emulator = 'emulator';
  static const String physicalDevice = 'physical_device';
  static const String simulator = 'simulator';
  
  // Current environment - change this based on your setup
  static const String currentEnvironment = physicalDevice; // Changed to physical device for real device testing
  
  // Network URLs for different environments
  static const Map<String, String> baseUrls = {
    emulator: 'http://10.0.2.2:3000', // Android emulator
    physicalDevice: 'http://10.211.29.145:3000', // Use your computer's actual IP
    simulator: 'http://localhost:3000', // iOS simulator
  };
  
  // Alternative IP addresses for physical device testing
  static const List<String> alternativeIPs = [
    'http://10.211.29.145:3000', // Your computer's actual IP
    'http://192.168.1.100:3000', // Common home network
    'http://192.168.0.100:3000', // Alternative home network
    'http://10.0.0.100:3000', // Some office networks
    'http://172.20.10.100:3000', // iPhone hotspot
    'http://localhost:3000', // Local development
  ];
  
  // Get the current base URL
  static String get baseUrl {
    final url = baseUrls[currentEnvironment] ?? baseUrls[physicalDevice]!;
    // Debug print for network troubleshooting
    debugPrint('[NetworkConfig] Using baseUrl: $url');
    return url;
  }
  
  // Test URL for connectivity
  static String get testUrl {
    return '$baseUrl/api/auth/test';
  }
  
  // Get alternative URLs for testing
  static List<String> get alternativeUrls {
    return alternativeIPs;
  }
  
  // Check if current setup is for physical device
  static bool get isPhysicalDevice {
    return currentEnvironment == physicalDevice;
  }
  
  // Get network info for debugging
  static Map<String, dynamic> getNetworkInfo() {
    return {
      'currentEnvironment': currentEnvironment,
      'baseUrl': baseUrl,
      'alternativeUrls': alternativeUrls,
      'isPhysicalDevice': isPhysicalDevice,
    };
  }
  
  // Get alternative base URL if current one fails
  static String get fallbackUrl {
    return alternativeIPs.first;
  }
  
  // Get detailed network info for debugging
  static Map<String, dynamic> getDetailedNetworkInfo() {
    return {
      'currentEnvironment': currentEnvironment,
      'baseUrl': baseUrl,
      'alternativeUrls': alternativeUrls,
      'isPhysicalDevice': isPhysicalDevice,
      'suggestions': [
        'Make sure backend server is running on port 3000',
        'Check if IP address is correct for your network',
        'Try alternative IPs if current one fails',
        'For emulator, use 10.0.2.2:3000',
        'For physical device, use your computer\'s IP address',
        'Run: cd backend_node && npm start',
        'Check if port 3000 is not blocked by firewall',
        'Ensure MongoDB is running and accessible',
      ],
    };
  }
  
  // Test connectivity to current server
  static Future<bool> testConnectivity() async {
    try {
      final response = await http.get(Uri.parse(testUrl));
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('[NetworkConfig] Connectivity test failed: $e');
      return false;
    }
  }
  
  // Get working URL from alternatives
  static Future<String?> getWorkingUrl() async {
    // Test current URL first
    if (await testConnectivity()) {
      return baseUrl;
    }
    
    // Test alternative URLs
    for (final url in alternativeIPs) {
      try {
        final response = await http.get(Uri.parse('$url/api/auth/test'));
        if (response.statusCode == 200) {
          debugPrint('[NetworkConfig] Found working URL: $url');
          return url;
        }
      } catch (e) {
        debugPrint('[NetworkConfig] Failed to connect to $url: $e');
      }
    }
    
    return null;
  }
  
  // Get troubleshooting steps
  static List<String> getTroubleshootingSteps() {
    return [
      '1. Start backend server: cd backend_node && npm start',
      '2. Check if MongoDB is running and accessible',
      '3. Verify network configuration in network_config.dart',
      '4. For emulator: use 10.0.2.2:3000',
      '5. For physical device: use computer\'s IP address',
      '6. Check firewall settings and allow port 3000',
      '7. Ensure device and server are on same network',
      '8. Check if .env file is properly configured',
    ];
  }
} 