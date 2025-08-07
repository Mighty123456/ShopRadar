import 'package:flutter/material.dart';
import '../services/auth_flow_manager.dart';
import '../screens/auth_screen.dart';
import '../screens/home_screen.dart';
import '../screens/otp_verification_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;
  String _initialRoute = '/auth';

  @override
  void initState() {
    super.initState();
    _determineInitialRoute();
  }

  Future<void> _determineInitialRoute() async {
    try {
      // Validate the authentication flow
      await AuthFlowManager.validateAuthFlow();
      
      // Get the appropriate initial route
      final route = await AuthFlowManager.getInitialRoute();
      
      if (mounted) {
        setState(() {
          _initialRoute = route;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _initialRoute = '/auth';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              SizedBox(height: 20),
              Text(
                'Loading ShopRadar...',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Return the appropriate screen based on initial route
    switch (_initialRoute) {
      case '/home':
        return const HomeScreen();
      case '/otp-verification':
        return FutureBuilder<String?>(
          future: AuthFlowManager.getUserEmail(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return OTPVerificationScreen(
                email: snapshot.data!,
                userId: '', // We'll get this from the backend if needed
              );
            } else {
              return const AuthScreen();
            }
          },
        );
      default:
        return const AuthScreen();
    }
  }
} 