import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.lightBlue.shade300,
              Colors.lightBlue.shade700,
            ],
            stops: const [0.2, 0.8],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar section
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.security,
                      color: Colors.white.withOpacity(0.9),
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Victim Voice',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Main content
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo container with glass effect
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.lightBlue.shade900.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 120,
                          height: 120,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.support_rounded,
                                size: 80,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      // App name with larger text
                      Text(
                        'Victim Voice',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Tagline with elegant font
                      Text(
                        'Empowering Voices, Ensuring Justice',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 48),
                      
                      // Custom loading indicator
                      SizedBox(
                        width: 180,
                        child: Column(
                          children: [
                            // Progress bar with gradient
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                backgroundColor: Colors.white.withOpacity(0.2),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white.withOpacity(0.8),
                                ),
                                minHeight: 6,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Loading text with shimmer effect
                            ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                colors: [
                                  Colors.lightBlue.shade100,
                                  Colors.white,
                                  Colors.lightBlue.shade100,
                                ],
                                stops: const [0.0, 0.5, 1.0],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds),
                              child: Text(
                                'Loading...',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Bottom text
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Text(
                  'Your Safety Matters',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
