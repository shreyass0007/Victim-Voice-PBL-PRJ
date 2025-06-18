import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  final String _key = "isDarkMode";

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_key) ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, _isDarkMode);
    notifyListeners();
  }

  ThemeData getTheme() {
    return _isDarkMode ? _getDarkTheme() : _getLightTheme();
  }

  ThemeData _getLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
    );
  }

  ThemeData _getDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: Colors.grey[900],
    );
  }
}
