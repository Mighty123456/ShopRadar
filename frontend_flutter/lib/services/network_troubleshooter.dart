import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'network_config.dart';
import 'network_status.dart';

class NetworkTroubleshooter {
  // Comprehensive network diagnostics
  static Future<Map<String, dynamic>> runDiagnostics() async {
    final diagnostics = <String, dynamic>{
      'timestamp': DateTime.now().toIso8601String(),
      'currentEnvironment': NetworkConfig.currentEnvironment,
      'baseUrl': NetworkConfig.baseUrl,
      'isBackendRunning': false,
      'workingUrls': <String>[],
      'issues': <String>[],
      'solutions': <String>[],
    };

    try {
      // Test backend connectivity
      diagnostics['isBackendRunning'] = await NetworkStatus.isBackendRunning();
      
      if (!diagnostics['isBackendRunning']) {
        diagnostics['issues'].add('Backend server is not responding');
        diagnostics['solutions'].addAll([
          'Start the backend server: cd backend_node && npm start',
          'Check if port 3000 is available',
          'Verify the IP address is correct for your setup',
        ]);
      }

      // Test alternative URLs
      diagnostics['workingUrls'] = await NetworkStatus.getWorkingUrls();
      
      if (diagnostics['workingUrls'].isEmpty) {
        diagnostics['issues'].add('No working URLs found');
        diagnostics['solutions'].addAll([
          'Check your network configuration',
          'Try different IP addresses',
          'Verify firewall settings',
        ]);
      }

      // Environment-specific suggestions
      if (NetworkConfig.currentEnvironment == NetworkConfig.emulator) {
        diagnostics['solutions'].addAll([
          'For Android emulator, ensure backend runs on 10.0.2.2:3000',
          'Check if backend is accessible from emulator network',
        ]);
      } else if (NetworkConfig.currentEnvironment == NetworkConfig.physicalDevice) {
        diagnostics['solutions'].addAll([
          'For physical device, use your computer\'s actual IP address',
          'Ensure device and computer are on same network',
          'Check if IP address is correct for your network',
        ]);
      }

    } catch (e) {
      diagnostics['issues'].add('Error during diagnostics: $e');
    }

    return diagnostics;
  }

  // Get quick status
  static Future<String> getQuickStatus() async {
    final isRunning = await NetworkStatus.isBackendRunning();
    if (isRunning) {
      return '✅ Backend server is running and accessible';
    } else {
      return '❌ Backend server is not accessible';
    }
  }

  // Get troubleshooting steps
  static List<String> getTroubleshootingSteps() {
    return [
      '1. Start backend server: cd backend_node && npm start',
      '2. Check if port 3000 is not in use',
      '3. Verify network configuration in network_config.dart',
      '4. For emulator: use 10.0.2.2:3000',
      '5. For physical device: use computer\'s IP address',
      '6. Check firewall settings',
      '7. Ensure device and server are on same network',
    ];
  }

  // Test specific URL
  static Future<bool> testUrl(String url) async {
    try {
      final response = await http.get(
        Uri.parse('$url/api/auth/test'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));
      
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Failed to test URL $url: $e');
      return false;
    }
  }

  // Get network info for debugging
  static Map<String, dynamic> getNetworkInfo() {
    return {
      'currentEnvironment': NetworkConfig.currentEnvironment,
      'baseUrl': NetworkConfig.baseUrl,
      'alternativeUrls': NetworkConfig.alternativeUrls,
      'testUrl': NetworkConfig.testUrl,
      'isPhysicalDevice': NetworkConfig.isPhysicalDevice,
    };
  }
} 