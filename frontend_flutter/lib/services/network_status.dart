import 'package:http/http.dart' as http;
import 'network_config.dart';

class NetworkStatus {
  // Check if backend server is running
  static Future<bool> isBackendRunning() async {
    try {
      final response = await http.get(
        Uri.parse(NetworkConfig.testUrl),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
  
  // Get detailed network diagnostics
  static Future<Map<String, dynamic>> getNetworkDiagnostics() async {
    final diagnostics = <String, dynamic>{
      'currentEnvironment': NetworkConfig.currentEnvironment,
      'baseUrl': NetworkConfig.baseUrl,
      'isBackendRunning': false,
      'suggestions': <String>[],
    };
    
    // Test backend connectivity
    diagnostics['isBackendRunning'] = await isBackendRunning();
    
    // Add suggestions based on results
    if (!diagnostics['isBackendRunning']) {
      diagnostics['suggestions'].addAll([
        'Backend server is not running. Start it with: cd backend_node && npm start',
        'Check if port 3000 is available and not blocked by firewall',
        'Verify the IP address is correct for your network setup',
        'For Android emulator, ensure backend is running on 10.0.2.2:3000',
        'For physical device, use your computer\'s actual IP address',
      ]);
    }
    
    return diagnostics;
  }
  
  // Test alternative URLs
  static Future<List<String>> getWorkingUrls() async {
    final workingUrls = <String>[];
    
    // Test current URL
    if (await isBackendRunning()) {
      workingUrls.add(NetworkConfig.baseUrl);
    }
    
    // Test alternative URLs
    for (final url in NetworkConfig.alternativeUrls) {
      try {
        final response = await http.get(
          Uri.parse('$url/api/auth/test'),
          headers: {'Content-Type': 'application/json'},
        ).timeout(const Duration(seconds: 3));
        
        if (response.statusCode == 200) {
          workingUrls.add(url);
        }
      } catch (e) {
        // URL failed, continue to next
      }
    }
    
    return workingUrls;
  }
  
  // Get troubleshooting steps
  static List<String> getTroubleshootingSteps() {
    return [
      '1. Start the backend server: cd backend_node && npm start',
      '2. Check if port 3000 is not in use by another application',
      '3. Verify your network configuration in network_config.dart',
      '4. For Android emulator, use 10.0.2.2:3000',
      '5. For physical device, use your computer\'s IP address',
      '6. Check firewall settings and allow port 3000',
      '7. Try running backend on a different port if 3000 is blocked',
    ];
  }
} 