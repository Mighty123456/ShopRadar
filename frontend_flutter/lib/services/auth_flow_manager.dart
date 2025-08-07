import 'package:flutter/material.dart';
import 'auth_service.dart';

class AuthFlowManager {

  // Authentication flow states
  static const String flowInitial = 'initial';
  static const String flowRegistered = 'registered';
  static const String flowVerified = 'verified';
  static const String flowLoggedIn = 'logged_in';

  // Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    try {
      final token = await AuthService.getToken();
      final user = await AuthService.getUser();
      return token != null && user != null && user.isEmailVerified;
    } catch (e) {
      return false;
    }
  }

  // Get current authentication state
  static Future<String> getAuthState() async {
    final token = await AuthService.getToken();
    final user = await AuthService.getUser();
    
    if (token == null || user == null) {
      return flowInitial;
    }
    
    if (!user.isEmailVerified) {
      return flowRegistered;
    }
    
    return flowLoggedIn;
  }

  // Handle successful registration
  static Future<void> handleSuccessfulRegistration({
    required BuildContext context,
    required String message,
    required String email,
    required String userId,
  }) async {
    try {
      debugPrint('Handling successful registration for: $email');
      
      // Show success message
      _showSuccessMessage(context, message);
      
      // Navigate to OTP verification
      await Future.delayed(const Duration(seconds: 1));
      if (context.mounted) {
        debugPrint('Navigating to OTP verification...');
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/otp-verification',
          (route) => false,
          arguments: {
            'email': email,
            'userId': userId,
          },
        );
      }
    } catch (e) {
      debugPrint('Navigation error: $e');
      // If navigation fails, show error and go back to auth
      if (context.mounted) {
        _showErrorMessage(context, 'Navigation error: $e');
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/auth',
          (route) => false,
        );
      }
    }
  }

  // Handle successful OTP verification
  static Future<void> handleSuccessfulVerification({
    required BuildContext context,
    required String message,
  }) async {
    // Show success message
    _showSuccessMessage(context, message);
    
    // Navigate to verification success screen first, then login
    await Future.delayed(const Duration(seconds: 1));
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/verification-success',
        (route) => false,
      );
    }
  }

  // Handle successful login
  static Future<void> handleSuccessfulLogin({
    required BuildContext context,
    required String message,
  }) async {
    // Show success message
    _showSuccessMessage(context, message);
    
    // Navigate to success screen first, then home
    await Future.delayed(const Duration(seconds: 1));
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/auth-success',
        (route) => false,
      );
    }
  }

  // Handle logout
  static Future<void> handleLogout({
    required BuildContext context,
  }) async {
    await AuthService.logout();
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/auth',
        (route) => false,
      );
    }
  }

  // Show success message
  static void _showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Show error message
  static void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Check if user needs email verification
  static Future<bool> needsEmailVerification() async {
    try {
      final user = await AuthService.getUser();
      return user != null && !user.isEmailVerified;
    } catch (e) {
      return false;
    }
  }

  // Get user's email for verification
  static Future<String?> getUserEmail() async {
    try {
      final user = await AuthService.getUser();
      return user?.email;
    } catch (e) {
      return null;
    }
  }

  // Validate authentication flow
  static Future<bool> validateAuthFlow() async {
    final token = await AuthService.getToken();
    final user = await AuthService.getUser();
    
    // If no token, user should be at initial state
    if (token == null) {
      return true;
    }
    
    // If token exists but no user, clear token
    if (user == null) {
      await AuthService.logout();
      return true;
    }
    
    // If user exists but not verified, they should be in verification flow
    if (!user.isEmailVerified) {
      return true;
    }
    
    return true;
  }

  // Get appropriate initial route based on auth state
  static Future<String> getInitialRoute() async {
    final isAuth = await isAuthenticated();
    
    if (isAuth) {
      return '/home';
    }
    
    final needsVerification = await needsEmailVerification();
    if (needsVerification) {
      return '/otp-verification';
    }
    
    return '/auth';
  }
} 