import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/registration_form.dart';
import 'screens/rights_screen.dart';
import 'screens/support_screen.dart';
import 'screens/safety_screen.dart';
import 'screens/chatbot_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/emergency_contact_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter App',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 143, 197, 241),
      ),
      home: const LoginScreen(),
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
        '/emergencyContact': (context) => const EmergencyContactScreen(),
      },
    );
  }
}
