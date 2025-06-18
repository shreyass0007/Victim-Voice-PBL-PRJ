import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  late SharedPreferences _prefs;
  bool _isInitialized = false;

  // Settings keys
  static const String _fontSizeKey = 'fontSize';
  static const String _languageKey = 'language';
  static const String _notificationsKey = 'notifications';
  static const String _soundEffectsKey = 'soundEffects';
  static const String _vibrationKey = 'vibration';

  // Default values
  double _fontSize = 1.0; // Scale factor
  String _language = 'en';
  bool _notificationsEnabled = true;
  bool _soundEffectsEnabled = true;
  bool _vibrationEnabled = true;

  // Language settings map
  final Map<String, Map<String, dynamic>> _languageSettings = {
    'en': {'name': 'English', 'code': 'en', 'rtl': false},
    'hi': {'name': 'हिंदी', 'code': 'hi', 'rtl': false},
    'ar': {'name': 'العربية', 'code': 'ar', 'rtl': true},
  };

  // Getters
  bool get isInitialized => _isInitialized;
  double get fontSize => _fontSize;
  String get language => _language;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get soundEffectsEnabled => _soundEffectsEnabled;
  bool get vibrationEnabled => _vibrationEnabled;

  // Available languages
  List<String> get availableLanguages => _languageSettings.keys.toList();

  // Get text direction
  TextDirection get textDirection {
    return _languageSettings[_language]!['rtl'] == true
        ? TextDirection.rtl
        : TextDirection.ltr;
  }

  // Get language code
  String get languageCode => _languageSettings[_language]!['code'] as String;

  // Get language display name
  String getLanguageDisplayName(String language) {
    if (!_languageSettings.containsKey(language)) {
      return language;
    }
    return _languageSettings[language]!['name'] as String;
  }

  // Get native language name
  String get nativeLanguageName => getLanguageDisplayName(language);

  double get textScaleFactor => _prefs.getDouble('textScaleFactor') ?? 1.0;

  // Initialize settings
  Future<void> init() async {
    if (_isInitialized) return; // Don't initialize twice
    
    _prefs = await SharedPreferences.getInstance();
    _loadSettings();
    _isInitialized = true;
    debugPrint('Settings initialized successfully');
    debugPrint('Current settings state:');
    _printCurrentSettings();
    notifyListeners();
  }

  void _loadSettings() {
    try {
      // Load all settings at once for better performance
      final settings = {
        _fontSizeKey: _prefs.getDouble(_fontSizeKey),
        _languageKey: _prefs.getString(_languageKey),
        _notificationsKey: _prefs.getBool(_notificationsKey),
        _soundEffectsKey: _prefs.getBool(_soundEffectsKey),
        _vibrationKey: _prefs.getBool(_vibrationKey),
      };

      // Apply settings with defaults
      _fontSize = settings[_fontSizeKey] as double? ?? 1.0;
      _language = (settings[_languageKey] as String?) ?? 'en';
      _notificationsEnabled = settings[_notificationsKey] as bool? ?? true;
      _soundEffectsEnabled = settings[_soundEffectsKey] as bool? ?? true;
      _vibrationEnabled = settings[_vibrationKey] as bool? ?? true;

      // Validate language
      if (!_languageSettings.containsKey(_language)) {
        _language = 'en';
      }

      debugPrint('Settings loaded successfully');
      _printCurrentSettings();
    } catch (e) {
      debugPrint('Error loading settings: $e');
      // Use defaults on error
      _fontSize = 1.0;
      _language = 'en';
      _notificationsEnabled = true;
      _soundEffectsEnabled = true;
      _vibrationEnabled = true;
    }
  }

  // Update font size
  Future<void> setFontSize(double size) async {
    try {
      final oldSize = _fontSize;
      _fontSize = size;
      await _prefs.setDouble(_fontSizeKey, size);
      debugPrint('Font size updated: $oldSize -> $size');
      notifyListeners();
    } catch (e) {
      debugPrint('Error setting font size: $e');
      // Revert to previous value if there's an error
      _fontSize = _prefs.getDouble(_fontSizeKey) ?? 1.0;
      notifyListeners();
    }
  }

  // Update language
  Future<void> setLanguage(String lang) async {
    try {
      if (!_languageSettings.containsKey(lang)) {
        throw Exception('Invalid language selected');
      }

      final oldLang = _language;
      _language = lang;
      await _prefs.setString(_languageKey, lang);
      debugPrint(
          'Language updated: $oldLang -> $lang (${_languageSettings[lang]?['name']})');
      notifyListeners();
    } catch (e) {
      debugPrint('Error setting language: $e');
      _language = _prefs.getString(_languageKey) ?? 'en';
      notifyListeners();
    }
  }

  // Toggle notifications
  Future<void> toggleNotifications() async {
    try {
      final oldValue = _notificationsEnabled;
      _notificationsEnabled = !_notificationsEnabled;
      await _prefs.setBool(_notificationsKey, _notificationsEnabled);
      debugPrint('Notifications toggled: $oldValue -> $_notificationsEnabled');
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling notifications: $e');
      // Revert to previous value if there's an error
      _notificationsEnabled = _prefs.getBool(_notificationsKey) ?? true;
      notifyListeners();
    }
  }

  // Toggle sound effects
  Future<void> toggleSoundEffects() async {
    try {
      final oldValue = _soundEffectsEnabled;
      _soundEffectsEnabled = !_soundEffectsEnabled;
      await _prefs.setBool(_soundEffectsKey, _soundEffectsEnabled);
      debugPrint('Sound effects toggled: $oldValue -> $_soundEffectsEnabled');
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling sound effects: $e');
      // Revert to previous value if there's an error
      _soundEffectsEnabled = _prefs.getBool(_soundEffectsKey) ?? true;
      notifyListeners();
    }
  }

  // Toggle vibration
  Future<void> toggleVibration() async {
    try {
      final oldValue = _vibrationEnabled;
      _vibrationEnabled = !_vibrationEnabled;
      await _prefs.setBool(_vibrationKey, _vibrationEnabled);
      debugPrint('Vibration toggled: $oldValue -> $_vibrationEnabled');
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling vibration: $e');
      // Revert to previous value if there's an error
      _vibrationEnabled = _prefs.getBool(_vibrationKey) ?? true;
      notifyListeners();
    }
  }

  // Helper method to print current settings state
  void _printCurrentSettings() {
    debugPrint('''
    Current Settings State:
    - Font Size: $_fontSize
    - Language: $_language
    - Notifications Enabled: $_notificationsEnabled
    - Sound Effects Enabled: $_soundEffectsEnabled
    - Vibration Enabled: $_vibrationEnabled
    ''');
  }

  // Clear all settings
  Future<void> resetToDefaults() async {
    try {
      await _prefs.remove(_fontSizeKey);
      await _prefs.remove(_languageKey);
      await _prefs.remove(_notificationsKey);
      await _prefs.remove(_soundEffectsKey);
      await _prefs.remove(_vibrationKey);

      _fontSize = 1.0;
      _language = 'en';
      _notificationsEnabled = true;
      _soundEffectsEnabled = true;
      _vibrationEnabled = true;

      debugPrint('Settings reset to defaults');
      _printCurrentSettings();
      notifyListeners();
    } catch (e) {
      debugPrint('Error resetting settings: $e');
    }
  }

  // Check if language is RTL
  bool isRTL(String language) {
    return _languageSettings[language]?['rtl'] ?? false;
  }
}
