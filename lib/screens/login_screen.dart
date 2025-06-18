// ignore_for_file: unused_local_variable, duplicate_ignore, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:victim_voice/utils/feedback_utils.dart';
import 'package:victim_voice/services/auth_service.dart';
import 'package:victim_voice/utils/validation_utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    FeedbackUtils.showLoading(context);

    try {
      final authService = AuthService();
      final success = await authService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (success && mounted) {
        FeedbackUtils.hideLoading(context);
        FeedbackUtils.showSuccess(context, 'Login successful');
        Navigator.pushReplacementNamed(context, '/home');
      } else if (mounted) {
        FeedbackUtils.hideLoading(context);
        FeedbackUtils.showError(context,
            'Invalid credentials. Please check your email and password.');
      }
    } catch (e) {
      if (mounted) {
        FeedbackUtils.hideLoading(context);
        FeedbackUtils.showError(context,
            'Login failed. Please check your internet connection and try again.');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _checkLoginStatus() async {
    final authService = AuthService();
    if (await authService.isLoggedIn()) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // ignore: unused_local_variable
    final primaryColor = Theme.of(context).primaryColor;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? [
                      // ignore: deprecated_member_use
                      Colors.blue.shade900.withOpacity(0.2),
                      Colors.grey.shade900,
                    ]
                  : [
                      Colors.blue.shade100,
                      Colors.white,
                    ],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.security,
                      size: 80,
                      color: isDark ? Colors.blue.shade300 : Colors.blue,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Welcome to Victim Voice',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    Card(
                      elevation: isDark ? 2 : 4,
                      color:
                          isDark ? Theme.of(context).cardColor : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: isDark
                              ? Border.all(
                                  color: Colors.grey.shade800,
                                  width: 1,
                                )
                              : null,
                        ),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: isDark
                                      ? Colors.blue.shade300
                                      : Colors.blue,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: ValidationUtils.validateEmail,
                              autocorrect: false,
                              enableSuggestions: false,
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: isDark
                                      ? Colors.blue.shade300
                                      : Colors.blue,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: isDark
                                        ? Colors.blue.shade300
                                        : Colors.blue,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: ValidationUtils.validatePassword,
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isDark
                                      ? Colors.blue.withOpacity(0.8)
                                      : Colors.blue,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: isDark ? 2 : 4,
                                ),
                                child: _isLoading
                                    ? SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  isDark
                                                      ? Colors.white
                                                          .withOpacity(0.9)
                                                      : Colors.white),
                                        ),
                                      )
                                    : Text(
                                        'Login',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: isDark
                                              ? Colors.white.withOpacity(0.9)
                                              : Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/signup');
                      },
                      child: Text(
                        'Don\'t have an account? Sign Up',
                        style: TextStyle(
                          color: isDark ? Colors.blue.shade300 : Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
