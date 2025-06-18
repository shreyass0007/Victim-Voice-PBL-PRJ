// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:victim_voice/utils/validation_utils.dart';
import 'package:victim_voice/utils/feedback_utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    FeedbackUtils.showLoading(context);

    try {
      // TODO: Replace with actual API signup
      await Future.delayed(const Duration(seconds: 1));

      // Store user data
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', _nameController.text.trim());
      await prefs.setString('email', _emailController.text.trim());
      await prefs.setString('profileImage',
          'https://static.toiimg.com/thumb/msid-100225970,imgsize-51152,width-400,resizemode-4/100225970.jpg');
      await prefs.setBool('isLoggedIn', true);

      if (mounted) {
        FeedbackUtils.hideLoading(context);
        FeedbackUtils.showSuccess(context, 'Account created successfully');
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) {
        FeedbackUtils.hideLoading(context);
        FeedbackUtils.showError(
          context,
          'Failed to create account. Please try again.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Account',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDark
            ? Theme.of(context).appBarTheme.backgroundColor
            : const Color.fromARGB(255, 179, 212, 255),
        elevation: isDark ? 0 : 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black87),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    Theme.of(context).primaryColor.withOpacity(0.2),
                    Theme.of(context).scaffoldBackgroundColor,
                  ]
                : [
                    const Color.fromARGB(255, 179, 212, 255),
                    Colors.white,
                  ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.person_add,
                    size: 80,
                    color: isDark ? Colors.blue.shade300 : Colors.blue,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Join Victim Voice',
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
                    color: isDark ? Theme.of(context).cardColor : Colors.white,
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
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Full Name',
                              prefixIcon: Icon(
                                Icons.person,
                                color: isDark
                                    ? Colors.blue.shade300
                                    : primaryColor,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                            validator: ValidationUtils.validateName,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(
                                Icons.email,
                                color: isDark
                                    ? Colors.blue.shade300
                                    : primaryColor,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                            validator: ValidationUtils.validateEmail,
                            textInputAction: TextInputAction.next,
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
                                    : primaryColor,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: isDark
                                      ? Colors.blue.shade300
                                      : primaryColor,
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
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                            validator: ValidationUtils.validatePassword,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: isDark
                                    ? Colors.blue.shade300
                                    : primaryColor,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: isDark
                                      ? Colors.blue.shade300
                                      : primaryColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                            validator: _validateConfirmPassword,
                            textInputAction: TextInputAction.done,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleSignUp,
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
                                            AlwaysStoppedAnimation<Color>(isDark
                                                ? Colors.white.withOpacity(0.9)
                                                : Colors.white),
                                      ),
                                    )
                                  : Text(
                                      'Sign Up',
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
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text(
                      'Already have an account? Login',
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
    );
  }
}
