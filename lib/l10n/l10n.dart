import 'package:flutter/material.dart';

class L10n {
  static final all = [
    const Locale('en'), // English
    const Locale('hi'), // Hindi
    const Locale('es'), // Spanish
    const Locale('fr'), // French
    const Locale('ar'), // Arabic
    const Locale('ur'), // Urdu
  ];

  static String getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'hi':
        return 'हिंदी';
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      case 'ar':
        return 'العربية';
      case 'ur':
        return 'اردو';
      default:
        return code;
    }
  }

  static bool isRTL(String code) {
    return ['ar', 'ur'].contains(code);
  }
}
