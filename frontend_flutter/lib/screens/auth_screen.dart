import 'package:flutter/material.dart';
import '../widgets/social_login_buttons.dart';
import '../widgets/role_selector.dart';
import '../services/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

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
                                style: GoogleFonts.poppins(
                                  fontSize: 44,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF2979FF),
                                  letterSpacing: 5,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
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
                                    color: Colors.black.withValues(alpha: 0.06),
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

class _SignInForm extends StatefulWidget {
  const _SignInForm({super.key});

  @override
  State<_SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<_SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final result = await AuthService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      if (result['success']) {
        // Navigate to home screen or show success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful!')),
        );
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message']), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
        // Email
          TextFormField(
            controller: _emailController,
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
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Colors.red),
              ),
          ),
          style: GoogleFonts.poppins(
            color: Color(0xFF232136),
            fontWeight: FontWeight.w500,
            fontSize: 16,
            ),
            keyboardType: TextInputType.emailAddress,
          cursorColor: const Color(0xFF2979FF),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
        const SizedBox(height: 18),
        // Password
          TextFormField(
            controller: _passwordController,
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
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF2979FF), width: 2),
            ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Colors.red),
              ),
          ),
          style: GoogleFonts.poppins(
            color: Color(0xFF232136),
            fontWeight: FontWeight.w500,
            fontSize: 16,
            ),
            obscureText: _obscurePassword,
          cursorColor: const Color(0xFF2979FF),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
        ),
        // Forgot Password
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 18.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/forgot-password');
              },
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
            onPressed: _isLoading ? null : _signIn,
            style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2979FF),
            foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 2,
            ),
            child: _isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text('Sign In', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
          ),
        const SizedBox(height: 14),
        // Social Login Buttons
          const SocialLoginButtons(),
        ],
      ),
    );
  }
}

class _SignUpForm extends StatefulWidget {
  const _SignUpForm({super.key});

  @override
  State<_SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<_SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool agreeToTerms = false;
  String selectedRole = 'user';
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    if (!agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please agree to Terms & Conditions'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await AuthService.register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: _nameController.text.trim(),
        role: selectedRole,
      );

      if (!mounted) return;

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successful! Please check your email for OTP.')),
        );
        // Navigate to OTP verification screen
        Navigator.of(context).pushNamed('/otp-verification', arguments: {
          'email': _emailController.text.trim(),
          'userId': result['userId'],
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message']), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
        // Name (for both User and Shop Owner)
        TextFormField(
            controller: _nameController,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF7F8FA),
            labelText: selectedRole == 'user' ? 'Full Name' : 'Owner Name',
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
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Colors.red),
              ),
          ),
          style: GoogleFonts.poppins(
            color: Color(0xFF232136),
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          keyboardType: TextInputType.name,
          cursorColor: const Color(0xFF2979FF),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
        ),
        const SizedBox(height: 18),
        
        // Shop-specific fields (only for Shop Owner)
        if (selectedRole == 'shop') ...[
          // Shop Name
          TextFormField(
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF7F8FA),
              labelText: 'Shop Name',
              labelStyle: GoogleFonts.poppins(
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              prefixIcon: const Icon(Icons.store, color: Color(0xFF6B7280)),
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
            cursorColor: const Color(0xFF2979FF),
          ),
          const SizedBox(height: 18),
          
          // Business Type
          TextFormField(
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF7F8FA),
              labelText: 'Business Type',
              labelStyle: GoogleFonts.poppins(
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              prefixIcon: const Icon(Icons.business, color: Color(0xFF6B7280)),
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
            cursorColor: const Color(0xFF2979FF),
          ),
          const SizedBox(height: 18),
          
          // Phone Number
          TextFormField(
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF7F8FA),
              labelText: 'Phone Number',
              labelStyle: GoogleFonts.poppins(
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              prefixIcon: const Icon(Icons.phone, color: Color(0xFF6B7280)),
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
            keyboardType: TextInputType.phone,
            cursorColor: const Color(0xFF2979FF),
          ),
          const SizedBox(height: 18),
          
          // Address
          TextFormField(
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF7F8FA),
              labelText: 'Shop Address',
              labelStyle: GoogleFonts.poppins(
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              prefixIcon: const Icon(Icons.location_on, color: Color(0xFF6B7280)),
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
            maxLines: 2,
            cursorColor: const Color(0xFF2979FF),
          ),
          const SizedBox(height: 18),
        ],
        
        // Email (for both)
        TextFormField(
            controller: _emailController,
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
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Colors.red),
              ),
          ),
          style: GoogleFonts.poppins(
            color: Color(0xFF232136),
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          keyboardType: TextInputType.emailAddress,
          cursorColor: const Color(0xFF2979FF),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
        ),
        const SizedBox(height: 18),
        
        // Password (for both)
        TextFormField(
            controller: _passwordController,
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
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF2979FF), width: 2),
            ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Colors.red),
              ),
          ),
          style: GoogleFonts.poppins(
            color: Color(0xFF232136),
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
            obscureText: _obscurePassword,
          cursorColor: const Color(0xFF2979FF),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 8) {
                return 'Password must be at least 8 characters long';
              }
              if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
                return 'Password must contain uppercase, lowercase, and number';
              }
              return null;
            },
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
              checkColor: Colors.white,
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
            onPressed: agreeToTerms && !_isLoading ? _signUp : null,
            style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2979FF),
            foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 2,
            ),
            child: _isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
            selectedRole == 'user' ? 'Sign Up' : 'Register Shop',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)
          ),
          ),
        const SizedBox(height: 14),
        
        // Remove secondary button (Apply Filter/Add Products)
        
        // Social Login Buttons
          const SocialLoginButtons(),
        ],
      ),
    );
  }
} 