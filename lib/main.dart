import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'screens/home_screen.dart';
import 'screens/registration_form.dart';
import 'screens/rights_screen.dart';
import 'screens/support_screen.dart';
import 'screens/safety_screen.dart';
import 'screens/chatbot_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/emergency_contact_screen.dart';
import 'screens/cyber_crime_screen.dart';
import 'screens/complaint_history.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'providers/settings_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';
import 'l10n/l10n.dart';
import 'screens/splash_screen.dart';

void main() async {
  // Enable performance optimizations
  if (kDebugMode) {
    debugPrintRebuildDirtyWidgets = false;
  }

  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logging
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });
  final log = Logger('main');

  // Initialize database for desktop platforms
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Load .env file
  try {
    await dotenv.load();
    log.info('Successfully loaded .env file');
    final apiKey = dotenv.env['ANTHROPIC_API_KEY'];
    log.info('API Key exists: ${apiKey != null && apiKey.isNotEmpty}');
  } catch (e) {
    log.severe('Error loading .env file: $e');
  }

  // Initialize providers
  final themeProvider = ThemeProvider();
  final settingsProvider = SettingsProvider();
  await settingsProvider.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeProvider),
        ChangeNotifierProvider(create: (_) => settingsProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  TextStyle? _scaleTextStyle(TextStyle? style, double scaleFactor) {
    return style?.copyWith(fontSize: style.fontSize != null ? style.fontSize! * scaleFactor : null);
  }

  ThemeData _scaleTextTheme(ThemeData theme, double scaleFactor) {
    return theme.copyWith(
      textTheme: theme.textTheme.apply(
        fontSizeFactor: scaleFactor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, SettingsProvider>(
      builder: (context, themeProvider, settingsProvider, child) {
        final theme = themeProvider.isDarkMode
            ? ThemeData.dark().copyWith(
                primaryColor: Colors.lightBlue,
                colorScheme: const ColorScheme.dark().copyWith(
                  primary: Colors.lightBlue,
                  secondary: Colors.lightBlue.shade200,
                ),
              )
            : ThemeData.light().copyWith(
                primaryColor: Colors.lightBlue,
                colorScheme: const ColorScheme.light().copyWith(
                  primary: Colors.lightBlue,
                  secondary: Colors.lightBlue.shade200,
                ),
              );

        // Get text scale factor
        final textScaleFactor = settingsProvider.textScaleFactor;
        final scaledTheme = _scaleTextTheme(theme, textScaleFactor);

        return MaterialApp(
          title: 'Victim Voice',
          theme: scaledTheme,
          debugShowCheckedModeBanner: false,
          home: FutureBuilder(
            future: Future.wait([
              // Minimum splash screen duration reduced to 500ms
              Future.delayed(const Duration(milliseconds: 5000)),
              settingsProvider.init(),
            ]),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  backgroundColor: theme.colorScheme.background,
                  appBar: AppBar(
                    title: const Text('Victim Voice'),
                    backgroundColor: theme.colorScheme.primary,
                  ),
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Initialization Error',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            '${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onBackground,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Reload the app
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const MyApp()),
                            );
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Try Again'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              
              if (snapshot.connectionState != ConnectionState.done) {
                return const SplashScreen();
              }
              
              return const LoginScreen();
            },
          ),
          routes: {
            '/home': (context) => const HomeScreen(),
            '/signup': (context) => const SignUpScreen(),
            '/register': (context) => RegistrationForm(),
            '/rights': (context) => const RightsScreen(),
            '/support': (context) => const SupportScreen(),
            '/safety': (context) => const SafetyScreen(),
            '/chatbot': (context) => const ChatbotScreen(),
            '/login': (context) => const LoginScreen(),
            '/complaintForm': (context) => RegistrationForm(),
            '/emergencyContact': (context) => EmergencyContactScreen(),
            '/cyberCrime': (context) => const CyberCrimeScreen(),
            '/history': (context) => const ComplaintHistory(),
          },
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: L10n.all,
        );
      },
    );
  }
}
