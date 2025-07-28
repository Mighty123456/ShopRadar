import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const ShopRadarApp());
}

class ShopRadarApp extends StatelessWidget {
  const ShopRadarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopRadar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF2979FF), // Royal Blue
          onPrimary: Colors.white,
          secondary: Color(0xFF2DD4BF), // Turquoise
          onSecondary: Colors.white,
          surface: Color(0xFFF7F8FA), // Light background
          onSurface: Color(0xFF232136), // Main text
          error: Color(0xFFF44336),
          onError: Colors.white,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const AuthScreen(),
    );
  }
}
