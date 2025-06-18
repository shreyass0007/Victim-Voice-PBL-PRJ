// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _navigateToScreen(BuildContext context, String route) {
    // Close drawer first
    Navigator.pop(context);

    // Get current route
    final currentRoute = ModalRoute.of(context)?.settings.name;

    // If we're already on the target route, don't navigate
    if (currentRoute == route) return;

    // Special handling for logout
    if (route == '/login') {
      // Clear all routes and go to login
      Navigator.pushNamedAndRemoveUntil(
        context,
        route,
        (route) => false,
      );
      return;
    }

    // For other routes, check if we need to replace or push
    if (currentRoute == '/login' || currentRoute == '/signup') {
      // Replace the current route if we're coming from login/signup
      Navigator.pushReplacementNamed(context, route).catchError((error) {
        _showError(context, 'Navigation error: $error');
        return null;
      });
    } else {
      // Push new route for other cases
      Navigator.pushNamed(context, route).catchError((error) {
        _showError(context, 'Navigation error: $error');
        return null;
      });
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: primaryColor,
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.security,
                    size: 64.0,
                    color: Colors.white,
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    'Victim Voice',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Home'),
                    onTap: () => _navigateToScreen(context, '/home'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.description),
                    title: const Text('File Complaint'),
                    onTap: () => _navigateToScreen(context, '/complaintForm'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.history),
                    title: const Text('Complaint History'),
                    onTap: () => _navigateToScreen(context, '/history'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.computer),
                    title: const Text('Cyber Crime'),
                    onTap: () => _navigateToScreen(context, '/cyberCrime'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.gavel),
                    title: const Text('Know Your Rights'),
                    onTap: () => _navigateToScreen(context, '/rights'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.support),
                    title: const Text('Support'),
                    onTap: () => _navigateToScreen(context, '/support'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.health_and_safety),
                    title: const Text('Safety Tips'),
                    onTap: () => _navigateToScreen(context, '/safety'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.emergency),
                    title: const Text('Emergency Contacts'),
                    onTap: () => _navigateToScreen(context, '/emergencyContact'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.chat),
                    title: const Text('Chat with Us'),
                    onTap: () => _navigateToScreen(context, '/chatbot'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: () => _navigateToScreen(context, '/login'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
