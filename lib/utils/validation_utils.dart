class ValidationUtils {
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  static bool isValidEmail(String value) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(value.trim());
  }

  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your password';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }

    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name';
    }

    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters long';
    }

    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your phone number';
    }

    // Allow international format with optional country code
    // Examples: +1-234-567-8900, 1234567890, +91 98765 43210
    final phoneRegex = RegExp(
      r'^\+?[0-9]{1,4}?[-.\s]?\(?\d{1,}\)?[-.\s]?\d{1,}[-.\s]?\d{1,}$',
    );

    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  static bool isValidPhone(String value) {
    final phoneRegex = RegExp(
      r'^\+?[0-9]{1,4}?[-.\s]?\(?\d{1,}\)?[-.\s]?\d{1,}[-.\s]?\d{1,}$',
    );
    return phoneRegex.hasMatch(value.trim());
  }

  static bool isValidAge(String value) {
    final age = int.tryParse(value);
    return age != null && age > 0 && age < 150;
  }

  static bool isValidUrl(String value) {
    try {
      final uri = Uri.parse(value);
      return uri.isAbsolute && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (_) {
      return false;
    }
  }

  static String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // URL is optional
    }

    if (!isValidUrl(value.trim())) {
      return 'Please enter a valid URL';
    }

    return null;
  }

  static String sanitizeInput(String value) {
    // Remove any HTML tags
    value = value.replaceAll(RegExp(r'<[^>]*>'), '');
    // Remove special characters except basic punctuation
    value = value.replaceAll(RegExp(r'[^\w\s.,!?-]'), '');
    return value.trim();
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter $fieldName';
    }
    return null;
  }
}
