import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';
import 'screens/register_screen.dart';
import 'screens/otp_verification_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/reset_password_screen.dart';
import 'screens/home_screen.dart';
import 'screens/auth_success_screen.dart';
import 'screens/verification_success_screen.dart';
import 'screens/test_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/onboarding_screen.dart';
import 'widgets/auth_wrapper.dart';
import 'utils/onboarding_utils.dart';

void main() {
  runApp(const ShopRadarApp());
}

class ShopRadarApp extends StatefulWidget {
  const ShopRadarApp({super.key});

  @override
  State<ShopRadarApp> createState() => _ShopRadarAppState();
}

class _ShopRadarAppState extends State<ShopRadarApp> {
  bool _showOnboarding = false;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _checkInitialState();
  }

  Future<void> _checkInitialState() async {
    debugPrint('Starting _checkInitialState');
    try {
      final onboardingCompleted = await OnboardingUtils.isOnboardingComplete();
      debugPrint('onboardingCompleted: $onboardingCompleted');
      
      // Force onboarding to show for testing (remove this line later)
      // await OnboardingUtils.resetOnboarding();
      
      setState(() {
        _showOnboarding = true; // Force onboarding to show for testing
        _isInitializing = false;
      });
      debugPrint('Initialization complete - _showOnboarding: $_showOnboarding');
    } catch (e) {
      debugPrint('Error during initial state check: $e');
      setState(() {
        _showOnboarding = true; // Show onboarding on error
        _isInitializing = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
    return MaterialApp(
      title: 'ShopRadar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF2979FF),
          onPrimary: Colors.white,
          secondary: Color(0xFF2DD4BF),
          onSecondary: Colors.white,
          surface: Color(0xFFF7F8FA),
          onSurface: Color(0xFF232136),
          error: Color(0xFFF44336),
          onError: Colors.white,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: _showOnboarding
          ? OnboardingScreen(onFinish: () {
              setState(() {
                _showOnboarding = false;
              });
            })
          : const AuthWrapper(),
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/register': (context) => const RegisterScreen(),
        '/otp-verification': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
          return OTPVerificationScreen(
            email: args?['email'] ?? '',
            userId: args?['userId'] ?? '',
          );
        },
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/reset-password': (context) {
          final email = ModalRoute.of(context)!.settings.arguments as String? ?? '';
          return ResetPasswordScreen(email: email);
        },
        '/home': (context) => const HomeScreen(),
        '/auth-success': (context) => const AuthSuccessScreen(),
        '/verification-success': (context) => const VerificationSuccessScreen(),
        '/test': (context) => const TestScreen(),
      },
    );
  }
}
