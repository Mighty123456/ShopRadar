import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const ShopRadarApp());
}

class ShopRadarApp extends StatelessWidget {
  const ShopRadarApp({Key? key}) : super(key: key);

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
          primary: Color(0xFF6A1B9A), // Deep Purple
          onPrimary: Colors.white,
          secondary: Color(0xFF00BFA5), // Teal Accent
          onSecondary: Colors.white,
          background: Color(0xFFF9F9F9), // Light background
          onBackground: Color(0xFF212121), // Main text
          surface: Color(0xFFFFFFFF), // Cards, surfaces
          onSurface: Color(0xFF212121),
          error: Color(0xFFFF5252),
          onError: Colors.white,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFF2979FF), // Royal Blue
          onPrimary: Colors.white,
          secondary: Color(0xFF536DFE), // Light Indigo
          onSecondary: Colors.white,
          background: Color(0xFF121212), // Dark Slate Gray
          onBackground: Color(0xFFE0E0E0), // Light Gray text
          surface: Color(0xFF1E1E1E), // Charcoal Gray
          onSurface: Color(0xFFE0E0E0),
          error: Color(0xFFD32F2F), // Crimson Red
          onError: Colors.white,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData(brightness: Brightness.dark).textTheme),
      ),
      themeMode: ThemeMode.system,
      home: const AuthScreen(),
    );
  }
}
