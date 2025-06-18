// ignore_for_file: unused_field, unused_local_variable, deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/settings_provider.dart';
import '../utils/feedback_utils.dart';
import '../generated/l10n.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-0.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSignOut(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        // ignore: use_build_context_synchronously
        FeedbackUtils.showLoading(context);
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        if (context.mounted) {
          FeedbackUtils.hideLoading(context);
          FeedbackUtils.showSuccess(context, 'Signed out successfully');
          Navigator.pushReplacementNamed(context, '/login');
        }
      } catch (e) {
        if (context.mounted) {
          FeedbackUtils.hideLoading(context);
          FeedbackUtils.showError(
            context,
            'Error signing out. Please try again.',
          );
        }
      }
    }
  }

  Future<Map<String, String>> _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('name') ?? 'User',
      'email': prefs.getString('email') ?? 'user@example.com',
      'profileImage': prefs.getString('profileImage') ?? 'default_image_url',
    };
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context); // Get the localized strings
    final primaryColor = Colors.blue;

    return FutureBuilder<Map<String, String>>(
      future: _getUserData(),
      builder: (context, snapshot) {
        final userData = snapshot.data ??
            {
              'name': 'Loading...',
              'email': 'Loading...',
              'profileImage': 'default_image_url',
            };

        return Drawer(
          backgroundColor: Theme.of(context).drawerTheme.backgroundColor,
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.22,
                  constraints: const BoxConstraints(maxHeight: 200),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        primaryColor,
                        primaryColor.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 35,
                            color: primaryColor.withOpacity(0.7),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        userData['name']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userData['email']!,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          _buildDrawerItem(
                            icon: CupertinoIcons.home,
                            title: s.home,
                            context: context,
                            onTap: () => Navigator.pushNamed(context, '/home'),
                            color: primaryColor,
                          ),
                          _buildDrawerItem(
                            icon: CupertinoIcons.doc_plaintext,
                            title: s.complaintForm,
                            context: context,
                            onTap: () =>
                                Navigator.pushNamed(context, '/complaintForm'),
                            color: primaryColor,
                          ),
                          _buildDrawerItem(
                            icon: CupertinoIcons.clock,
                            title: s.complaintHistory,
                            context: context,
                            onTap: () =>
                                Navigator.pushNamed(context, '/history'),
                            color: primaryColor,
                          ),
                          _buildDrawerItem(
                            icon: CupertinoIcons.phone_circle,
                            title: s.emergencyContact,
                            context: context,
                            onTap: () => Navigator.pushNamed(
                              context,
                              '/emergencyContact',
                            ),
                            color: primaryColor,
                          ),
                          _buildDrawerItem(
                            icon: CupertinoIcons.chat_bubble_2,
                            title: s.chatSupport,
                            context: context,
                            onTap: () =>
                                Navigator.pushNamed(context, '/chatbot'),
                            color: primaryColor,
                          ),
                          _buildDrawerItem(
                            icon: CupertinoIcons.doc_text,
                            title: s.knowYourRights,
                            context: context,
                            onTap: () =>
                                Navigator.pushNamed(context, '/rights'),
                            color: primaryColor,
                          ),
                          _buildDrawerItem(
                            icon: CupertinoIcons.heart,
                            title: s.supportServices,
                            context: context,
                            onTap: () =>
                                Navigator.pushNamed(context, '/support'),
                            color: primaryColor,
                          ),
                          _buildDrawerItem(
                            icon: CupertinoIcons.shield,
                            title: s.safetyGuidelines,
                            context: context,
                            onTap: () =>
                                Navigator.pushNamed(context, '/safety'),
                            color: primaryColor,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Divider(thickness: 0.5),
                          ),
                          _buildDrawerItem(
                            icon: CupertinoIcons.settings,
                            title: s.settings,
                            context: context,
                            onTap: () => _showSettingsDialog(context),
                            color: primaryColor,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Divider(thickness: 0.5),
                          ),
                          _buildDrawerItem(
                            icon: Icons.logout,
                            title: s.signOut,
                            context: context,
                            onTap: () => _handleSignOut(context),
                            color: Colors.red,
                            isSignOut: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required BuildContext context,
    required VoidCallback onTap,
    required Color color,
    bool isSignOut = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final buttonColor = isSignOut ? Colors.red : Colors.blue;
    final s = S.of(context); // Get the localized strings

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isSignOut
            ? Colors.red.withOpacity(isDark ? 0.15 : 0.08)
            : (isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.blue.withOpacity(0.05)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(icon, color: buttonColor, size: 26),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: isSignOut
                          ? Colors.red
                          : (isDark ? Colors.white : Colors.black87),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                if (!isSignOut)
                  Icon(
                    Icons.chevron_right,
                    color:
                        isDark ? Colors.white54 : Colors.blue.withOpacity(0.4),
                    size: 22,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return SwitchListTile(
                  title: const Text('Dark Mode'),
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                );
              },
            ),
            Consumer<SettingsProvider>(
              builder: (context, settingsProvider, child) {
                return ListTile(
                  title: const Text('Font Size'),
                  trailing: DropdownButton<double>(
                    value: settingsProvider.fontSize,
                    items: const [
                      DropdownMenuItem(
                        value: 0.8,
                        child: Text('Small'),
                      ),
                      DropdownMenuItem(
                        value: 1.0,
                        child: Text('Normal'),
                      ),
                      DropdownMenuItem(
                        value: 1.2,
                        child: Text('Large'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        settingsProvider.setFontSize(value);
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
