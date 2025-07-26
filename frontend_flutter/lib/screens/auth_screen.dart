import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../widgets/social_login_buttons.dart';
import '../widgets/role_selector.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  bool isSignIn = true;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleAuthMode() {
    setState(() {
      isSignIn = !isSignIn;
      if (isSignIn) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      body: Stack(
        children: [
          // Animated gradient background
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 800),
              child: Container(
                key: ValueKey(isDark ? 'dark' : 'light'),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFF7F8FA),
                      Color(0xFFFFFFFF),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                double maxWidth = constraints.maxWidth < 600 ? constraints.maxWidth : 420;
                double horizontalPadding = constraints.maxWidth < 600 ? 16.0 : (constraints.maxWidth - maxWidth) / 2;
                return Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 32.0),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxWidth),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Hero(
                              tag: 'logo',
                              child: Text(
                                'SHOPRADAR',
                                style: GoogleFonts.orbitron(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2979FF),
                                  letterSpacing: 2.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 36),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(28),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 24,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                                child: Column(
                                  children: [
                                    // Custom Tab Bar
                                    Container(
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF7F8FA),
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                if (!isSignIn) toggleAuthMode();
                                              },
                                              child: AnimatedContainer(
                                                duration: const Duration(milliseconds: 300),
                                                decoration: BoxDecoration(
                                                  color: isSignIn ? const Color(0xFF2979FF) : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(24),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'Sign In',
                                                    style: GoogleFonts.poppins(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 16,
                                                      color: isSignIn ? Colors.white : Color(0xFF232136),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                if (isSignIn) toggleAuthMode();
                                              },
                                              child: AnimatedContainer(
                                                duration: const Duration(milliseconds: 300),
                                                decoration: BoxDecoration(
                                                  color: !isSignIn ? const Color(0xFF2979FF) : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(24),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'Sign Up',
                                                    style: GoogleFonts.poppins(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 16,
                                                      color: !isSignIn ? Colors.white : Color(0xFF232136),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 500),
                                      transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
                                      child: isSignIn
                                          ? Column(
                                              children: [
                                                const SizedBox(height: 28),
                                                _SignInForm(key: const ValueKey('signIn')),
                                              ],
                                            )
                                          : Column(
                                              children: [
                                                const SizedBox(height: 28),
                                                _SignUpForm(key: const ValueKey('signUp')),
                                              ],
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 36),
                            Text(
                              'Smart Store Finder with AI Offers',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF6B7280),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SignInForm extends StatelessWidget {
  const _SignInForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Email
        TextFormField(
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF7F8FA),
            labelText: 'Email',
            labelStyle: GoogleFonts.poppins(
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF6B7280)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF2979FF), width: 2),
            ),
          ),
          style: GoogleFonts.poppins(
            color: Color(0xFF232136),
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          keyboardType: TextInputType.emailAddress,
          cursorColor: const Color(0xFF2979FF),
        ),
        const SizedBox(height: 18),
        // Password
        TextFormField(
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF7F8FA),
            labelText: 'Password',
            labelStyle: GoogleFonts.poppins(
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF6B7280)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF2979FF), width: 2),
            ),
          ),
          style: GoogleFonts.poppins(
            color: Color(0xFF232136),
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          obscureText: true,
          cursorColor: const Color(0xFF2979FF),
        ),
        // Forgot Password
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 18.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {},
              child: Text(
                'Forgot Password?',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF2979FF),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ),
        // Sign In Button
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2979FF),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 2,
          ),
          child: Text('Sign In', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
        ),
        const SizedBox(height: 14),
        // Shop Now Button (Outlined)
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFF2979FF), width: 2),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: Text('Shop Now', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
        ),
        const SizedBox(height: 18),
        // Social Login Buttons
        const SocialLoginButtons(),
      ],
    );
  }
}

class _SignUpForm extends StatefulWidget {
  const _SignUpForm({Key? key}) : super(key: key);

  @override
  State<_SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<_SignUpForm> {
  bool agreeToTerms = false;
  String selectedRole = 'user';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Name
        TextFormField(
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF7F8FA),
            labelText: 'Name',
            labelStyle: GoogleFonts.poppins(
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF6B7280)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF2979FF), width: 2),
            ),
          ),
          style: GoogleFonts.poppins(
            color: Color(0xFF232136),
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          keyboardType: TextInputType.name,
          cursorColor: const Color(0xFF2979FF),
        ),
        const SizedBox(height: 18),
        // Email
        TextFormField(
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF7F8FA),
            labelText: 'Email',
            labelStyle: GoogleFonts.poppins(
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF6B7280)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF2979FF), width: 2),
            ),
          ),
          style: GoogleFonts.poppins(
            color: Color(0xFF232136),
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          keyboardType: TextInputType.emailAddress,
          cursorColor: const Color(0xFF2979FF),
        ),
        const SizedBox(height: 18),
        // Password
        TextFormField(
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF7F8FA),
            labelText: 'Password',
            labelStyle: GoogleFonts.poppins(
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF6B7280)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF2979FF), width: 2),
            ),
          ),
          style: GoogleFonts.poppins(
            color: Color(0xFF232136),
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          obscureText: true,
          cursorColor: const Color(0xFF2979FF),
        ),
        const SizedBox(height: 18),
        // Role Selector
        RoleSelector(
          selectedRole: selectedRole,
          onChanged: (role) => setState(() => selectedRole = role),
        ),
        const SizedBox(height: 18),
        // Terms & Conditions
        Row(
          children: [
            Checkbox(
              value: agreeToTerms,
              onChanged: (v) => setState(() => agreeToTerms = v ?? false),
              activeColor: const Color(0xFF2979FF),
              checkColor: const Color(0xFF23272F),
            ),
            Expanded(
              child: Text(
                'I agree to the Terms & Conditions',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF2979FF),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        // Sign Up Button
        ElevatedButton(
          onPressed: agreeToTerms ? () {} : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2979FF),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 2,
          ),
          child: Text('Sign Up', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
        ),
        const SizedBox(height: 14),
        // Apply Filter Button (Outlined)
        OutlinedButton(
          onPressed: agreeToTerms ? () {} : null,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFF2979FF), width: 2),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: Text('Apply Filter', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
        ),
        const SizedBox(height: 18),
        // Social Login Buttons
        const SocialLoginButtons(),
      ],
    );
  }
} 