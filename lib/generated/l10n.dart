import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class S {
  static S? _current;
  static S get current {
    _current ??= S();
    return _current!;
  }

  static S of(BuildContext context) => Localizations.of<S>(context, S)!;

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  String get appTitle => Intl.message('Victim Voice', name: 'appTitle');
  String get home => Intl.message('Home', name: 'home');
  String get complaintForm =>
      Intl.message('Complaint Form', name: 'complaintForm');
  String get complaintHistory =>
      Intl.message('Complaint History', name: 'complaintHistory');
  String get emergencyContact =>
      Intl.message('Emergency Contact', name: 'emergencyContact');
  String get chatSupport => Intl.message('Chat Support', name: 'chatSupport');
  String get knowYourRights =>
      Intl.message('Know Your Rights', name: 'knowYourRights');
  String get supportServices =>
      Intl.message('Support Services', name: 'supportServices');
  String get safetyGuidelines =>
      Intl.message('Safety Guidelines', name: 'safetyGuidelines');
  String get settings => Intl.message('Settings', name: 'settings');
  String get signOut => Intl.message('Sign Out', name: 'signOut');
  String get darkMode => Intl.message('Dark Mode', name: 'darkMode');
  String get enableDarkTheme =>
      Intl.message('Enable dark theme', name: 'enableDarkTheme');
  String get fontSize => Intl.message('Font Size', name: 'fontSize');
  String get language => Intl.message('Language', name: 'language');
  String get notifications =>
      Intl.message('Notifications', name: 'notifications');
  String get enableNotifications =>
      Intl.message('Enable Notifications', name: 'enableNotifications');
  String get receiveUpdates =>
      Intl.message('Receive important updates', name: 'receiveUpdates');
  String get feedback => Intl.message('Feedback', name: 'feedback');
  String get soundEffects =>
      Intl.message('Sound Effects', name: 'soundEffects');
  String get playSoundEffects =>
      Intl.message('Play sound effects', name: 'playSoundEffects');
  String get vibration => Intl.message('Vibration', name: 'vibration');
  String get enableHapticFeedback =>
      Intl.message('Enable haptic feedback', name: 'enableHapticFeedback');
  String get close => Intl.message('Close', name: 'close');
  String get resetToDefaults =>
      Intl.message('Reset to defaults', name: 'resetToDefaults');
  String get resetSettingsTitle =>
      Intl.message('Reset Settings', name: 'resetSettingsTitle');
  String get resetSettingsMessage => Intl.message(
    'Are you sure you want to reset all settings to their default values?',
    name: 'resetSettingsMessage',
  );
  String get reset => Intl.message('Reset', name: 'reset');
  String get cancel => Intl.message('Cancel', name: 'cancel');
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi', 'es', 'fr', 'ar', 'ur'].contains(locale.languageCode);
  }

  @override
  Future<S> load(Locale locale) {
    return Future.value(S.current);
  }

  @override
  bool shouldReload(_SDelegate old) => false;
}
