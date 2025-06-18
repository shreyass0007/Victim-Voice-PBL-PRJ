import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            children: [
              _buildProfileSection(),
              const SizedBox(height: 24),
              _buildSection(
                title: 'Appearance',
                icon: Icons.palette_outlined,
                children: [
                  _buildSettingTile(
                    icon: Icons.text_fields,
                    title: 'Font Size',
                    subtitle: 'Adjust text size',
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, size: 20),
                            onPressed: () => settings.setFontSize(
                              (settings.fontSize - 0.1).clamp(0.8, 1.5),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              '${(settings.fontSize * 100).round()}%',
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add, size: 20),
                            onPressed: () => settings.setFontSize(
                              (settings.fontSize + 0.1).clamp(0.8, 1.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildDivider(),
                  _buildSettingTile(
                    icon: Icons.language,
                    title: 'Language',
                    subtitle: settings.nativeLanguageName,
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: DropdownButton<String>(
                        value: settings.language,
                        underline: const SizedBox(),
                        items: settings.availableLanguages.map((String lang) {
                          return DropdownMenuItem<String>(
                            value: lang,
                            child: Text(
                              lang,
                              style: GoogleFonts.lato(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            settings.setLanguage(newValue);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSection(
                title: 'Notifications',
                icon: Icons.notifications_outlined,
                children: [
                  _buildSettingTile(
                    icon: Icons.notifications,
                    title: 'Push Notifications',
                    subtitle: 'Receive important updates',
                    trailing: Switch.adaptive(
                      value: settings.notificationsEnabled,
                      onChanged: (bool value) => settings.toggleNotifications(),
                      activeColor: Colors.blue,
                    ),
                  ),
                  _buildDivider(),
                  _buildSettingTile(
                    icon: Icons.volume_up,
                    title: 'Sound Effects',
                    subtitle: 'Play sounds for interactions',
                    trailing: Switch.adaptive(
                      value: settings.soundEffectsEnabled,
                      onChanged: (bool value) => settings.toggleSoundEffects(),
                      activeColor: Colors.blue,
                    ),
                  ),
                  _buildDivider(),
                  _buildSettingTile(
                    icon: Icons.vibration,
                    title: 'Vibration',
                    subtitle: 'Vibrate on interactions',
                    trailing: Switch.adaptive(
                      value: settings.vibrationEnabled,
                      onChanged: (bool value) => settings.toggleVibration(),
                      activeColor: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSection(
                title: 'About',
                icon: Icons.info_outline,
                children: [
                  _buildSettingTile(
                    icon: Icons.info_outline,
                    title: 'App Version',
                    subtitle: '1.0.0',
                  ),
                  _buildDivider(),
                  _buildSettingTile(
                    icon: Icons.restore,
                    title: 'Reset Settings',
                    subtitle: 'Restore default settings',
                    onTap: () => _showResetConfirmation(context, settings),
                    textColor: Colors.red,
                    iconColor: Colors.red,
                  ),
                ],
              ),
            ],
          ).animate().fadeIn(duration: 300.ms);
        },
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_outline,
              size: 30,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User Profile',
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage your account settings',
                  style: GoogleFonts.lato(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
            onPressed: () {
              // TODO: Navigate to profile settings
            },
          ),
        ],
      ),
    ).animate().slideX(begin: -0.2, end: 0, duration: 300.ms);
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Icon(icon, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    ).animate().slideX(begin: 0.2, end: 0, duration: 300.ms);
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Colors.blue),
      title: Text(
        title,
        style: GoogleFonts.lato(
          fontWeight: FontWeight.w600,
          color: textColor ?? Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.lato(
          color: Colors.grey[600],
        ),
      ),
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        height: 1,
        color: Colors.grey[200],
      ),
    );
  }

  void _showResetConfirmation(BuildContext context, SettingsProvider settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            const SizedBox(width: 8),
            Text(
              'Reset Settings',
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to reset all settings to default?',
          style: GoogleFonts.lato(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.lato(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              settings.resetToDefaults();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Reset',
              style: GoogleFonts.lato(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
