# 🛡️ Victim Voice - Cyber Crime Support & Safety App

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-2.17+-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE.md)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-blue.svg)](https://flutter.dev/)
[![Version](https://img.shields.io/badge/Version-1.0.0-orange.svg)](pubspec.yaml)

> A comprehensive cross-platform Flutter application designed to empower and support victims of cybercrime and harassment through AI-powered assistance, emergency support, and secure reporting tools.

## 📱 Features

### 🚨 Emergency Support
- **One-tap Emergency Button** - Immediate access to emergency services
- **Emergency Contact Management** - Store and quick-dial trusted contacts
- **24/7 Emergency Numbers** - Direct access to police, ambulance, and specialized helplines
- **Location-based Emergency Services** - Find nearest emergency facilities
- **Real-time Location Sharing** - Share location with emergency contacts

### 🤖 AI-Powered Assistant
- **GPT-4 Powered Chatbot** - Intelligent support and guidance
- **Context-Aware Responses** - Personalized assistance based on user situation
- **Multi-language Support** - Available in multiple languages
- **Emotional Support** - Compassionate responses for crisis situations
- **Resource Recommendations** - AI-curated support services and resources
- **Threat Assessment** - AI-powered risk evaluation and safety recommendations

### 📋 Comprehensive Reporting System
- **Cyber Crime Reporting** - Specialized forms for various cybercrime types
- **Evidence Collection** - Secure document and image upload capabilities
- **Case Tracking** - Monitor complaint status and updates
- **Complaint History** - Complete record of all reported incidents
- **PDF Generation** - Export reports for official use
- **Digital Evidence Preservation** - Secure storage with metadata preservation

### 🔒 Security & Privacy
- **End-to-End Encryption** - Secure data transmission and storage
- **Biometric Authentication** - Fingerprint and face recognition support
- **Secure Local Storage** - Encrypted data storage on device
- **Privacy-First Design** - User data protection and anonymity options
- **Blockchain Verification** - Tamper-proof evidence storage (planned)
- **Zero-Knowledge Architecture** - User data privacy protection

### 🎨 User Experience
- **Material Design 3** - Modern, accessible interface
- **Dark/Light Theme** - Customizable appearance
- **Accessibility Features** - Screen reader support and text scaling
- **Offline Functionality** - Core features available without internet
- **Cross-Platform** - Works on Android, iOS, Web, and Desktop
- **Responsive Design** - Optimized for all screen sizes

## 🛠️ Technology Stack

### Core Framework
- **Flutter 3.0+** - Cross-platform UI framework
- **Dart 2.17+** - Programming language
- **Provider** - State management
- **SQLite** - Local database storage

### Key Dependencies
```yaml
# UI & Navigation
flutter_localizations: ^0.0.0
google_fonts: ^6.2.1
flutter_animate: ^4.5.2
shimmer: ^3.0.0

# State Management & Storage
provider: ^6.1.1
shared_preferences: ^2.2.2
sqflite: ^2.3.2
flutter_secure_storage: ^8.0.0

# AI & Communication
http: ^1.1.0
chat_bubbles: ^1.5.0
animated_text_kit: ^4.2.2

# File Handling & Media
image_picker: ^1.0.4
pdf: ^3.10.7
flutter_pdfview: ^1.0.0
printing: ^5.6.0

# Security & Permissions
permission_handler: ^11.3.0
crypto: ^3.0.3
email_validator: ^3.0.0

# Location & Connectivity
geolocator: ^10.1.0
connectivity_plus: ^5.0.2

# Notifications & Sharing
flutter_local_notifications: ^18.0.1
share_plus: ^10.1.4
```

## 📦 Installation

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.0.0 or higher)
- [Dart SDK](https://dart.dev/get-dart) (2.17.0 or higher)
- [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/)
- Git

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/shreyass0007/Victim-Voice.git
   cd Victim-Voice
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment variables**
   Create a `.env` file in the root directory:
   ```env
   ANTHROPIC_API_KEY=your_anthropic_api_key_here
   ```

4. **Run the application**
   ```bash
   # For mobile
   flutter run
   
   # For specific platform
   flutter run -d android
   flutter run -d ios
   flutter run -d chrome
   flutter run -d windows
   ```

## 🏗️ Project Structure

```
lib/
├── main.dart                 # Application entry point
├── screens/                  # UI screens
│   ├── home_screen.dart
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   ├── registration_form.dart
│   ├── chatbot_screen.dart
│   ├── emergency_contact_screen.dart
│   ├── cyber_crime_screen.dart
│   ├── complaint_history.dart
│   ├── rights_screen.dart
│   ├── safety_screen.dart
│   ├── support_screen.dart
│   └── settings_screen.dart
├── services/                 # Business logic services
│   ├── auth_service.dart
│   ├── chatgpt_service.dart
│   ├── database_service.dart
│   ├── image_service.dart
│   ├── cache_service.dart
│   └── network_service.dart
├── providers/                # State management
│   ├── theme_provider.dart
│   └── settings_provider.dart
├── models/                   # Data models
│   └── emergency_contact.dart
├── widgets/                  # Reusable UI components
│   ├── emergency_button.dart
│   ├── chat_message_widget.dart
│   ├── loading_indicator.dart
│   └── drawer.dart
├── utils/                    # Utility functions
│   ├── constants.dart
│   ├── validation_utils.dart
│   ├── file_handler.dart
│   └── error_handler.dart
├── l10n/                     # Localization files
└── generated/                # Generated localization code
```

## 🌐 Localization

The app supports multiple languages through Flutter's localization framework. To add or modify translations:

1. Edit files in `lib/l10n/`
2. Run `flutter gen-l10n` to generate localization code
3. Add new locales to `l10n.yaml`

## 🔧 Configuration

### Environment Variables
- `ANTHROPIC_API_KEY` - Required for AI chatbot functionality

### Platform-Specific Setup

#### Android
- Minimum SDK: 21 (configurable via flutter.minSdkVersion)
- Target SDK: 33
- Permissions: Camera, Location, Storage, Internet, Phone, Notifications

#### iOS
- Minimum iOS: 12.0
- Permissions: Camera, Location, Photo Library

#### Desktop
- SQLite FFI support for local database
- File system access for document storage

## 🚀 Deployment

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

### Desktop
```bash
flutter build windows --release
flutter build macos --release
flutter build linux --release
```

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make your changes**
4. **Add tests** (if applicable)
5. **Commit your changes**
   ```bash
   git commit -m "Add: your feature description"
   ```
6. **Push to the branch**
   ```bash
   git push origin feature/your-feature-name
   ```
7. **Open a Pull Request**

### Development Guidelines
- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful commit messages
- Add comments for complex logic
- Test on multiple platforms
- Ensure accessibility compliance
- Follow security best practices

## 📋 Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/

# Run with coverage
flutter test --coverage
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## 🆘 Support

### Emergency Resources
- **National Emergency**: 112
- **Police**: 100
- **Ambulance**: 108
- **Women's Helpline**: 1091
- **Cyber Crime Helpline**: 1930
- **Mental Health Support**: 1800-599-0019

### Technical Support
- **Issues**: [GitHub Issues](https://github.com/shreyass0007/Victim-Voice/issues)
- **Discussions**: [GitHub Discussions](https://github.com/shreyass0007/Victim-Voice/discussions)
- **Email**: support@victimvoice.app

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- OpenAI for AI capabilities
- All contributors and supporters
- Law enforcement agencies for guidance
- Mental health professionals for expertise
- Open source community for libraries and tools

## 📊 Project Status

- ✅ Core functionality implemented
- ✅ AI chatbot integration
- ✅ Emergency support features
- ✅ Cross-platform compatibility
- ✅ User authentication system
- ✅ Complaint management system
- ✅ Emergency contact management
- ✅ Simplified dependency structure
- 🔄 Blockchain integration (planned)
- 🔄 Advanced analytics (planned)
- 🔄 Community features (planned)
- 🔄 Multi-language support expansion (planned)

## 🔮 Roadmap

- [ ] Enhanced AI capabilities with custom training
- [ ] Blockchain-based evidence verification
- [ ] Advanced analytics dashboard
- [ ] Community support features
- [ ] Integration with law enforcement APIs
- [ ] Advanced security features
- [ ] Performance optimizations
- [ ] Enhanced emergency features
- [ ] Improved accessibility features

## 🆕 Recent Updates

### Version 1.0.0
- ✅ Simplified dependency structure
- ✅ Removed deprecated packages (telephony, uni_links)
- ✅ Streamlined Android configuration
- ✅ Enhanced emergency contact functionality
- ✅ Improved code formatting and structure
- ✅ Added comprehensive MIT license

---

<div align="center">
  <p><strong>Made with ❤️ for a safer digital world</strong></p>
  <p>If this project helps you, please consider giving it a ⭐</p>
  <p><em>Together, we can make the digital world safer for everyone.</em></p>
</div>
