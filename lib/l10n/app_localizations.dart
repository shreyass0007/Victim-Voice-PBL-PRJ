import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('es'),
    Locale('fr'),
    Locale('ar'),
    Locale('ur')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Victim Voice'**
  String get appTitle;

  /// Home navigation item
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Complaint form navigation item
  ///
  /// In en, this message translates to:
  /// **'Complaint Form'**
  String get complaintForm;

  /// Complaint history navigation item
  ///
  /// In en, this message translates to:
  /// **'Complaint History'**
  String get complaintHistory;

  /// Emergency contact navigation item
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact'**
  String get emergencyContact;

  /// Chat support navigation item
  ///
  /// In en, this message translates to:
  /// **'Chat Support'**
  String get chatSupport;

  /// Know your rights navigation item
  ///
  /// In en, this message translates to:
  /// **'Know Your Rights'**
  String get knowYourRights;

  /// Support services navigation item
  ///
  /// In en, this message translates to:
  /// **'Support Services'**
  String get supportServices;

  /// Safety guidelines navigation item
  ///
  /// In en, this message translates to:
  /// **'Safety Guidelines'**
  String get safetyGuidelines;

  /// Settings navigation item
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Sign out navigation item
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// Dark mode setting
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Dark mode setting description
  ///
  /// In en, this message translates to:
  /// **'Enable dark theme'**
  String get enableDarkTheme;

  /// Font size setting
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get fontSize;

  /// Language setting
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Notifications section title
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Enable notifications setting
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotifications;

  /// Notifications setting description
  ///
  /// In en, this message translates to:
  /// **'Receive important updates'**
  String get receiveUpdates;

  /// Feedback section title
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// Sound effects setting
  ///
  /// In en, this message translates to:
  /// **'Sound Effects'**
  String get soundEffects;

  /// Sound effects setting description
  ///
  /// In en, this message translates to:
  /// **'Play sound effects'**
  String get playSoundEffects;

  /// Vibration setting
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get vibration;

  /// Vibration setting description
  ///
  /// In en, this message translates to:
  /// **'Enable haptic feedback'**
  String get enableHapticFeedback;

  /// Close button text
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Reset settings button text
  ///
  /// In en, this message translates to:
  /// **'Reset to defaults'**
  String get resetToDefaults;

  /// Reset settings dialog title
  ///
  /// In en, this message translates to:
  /// **'Reset Settings'**
  String get resetSettingsTitle;

  /// Reset settings confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset all settings to their default values?'**
  String get resetSettingsMessage;

  /// Reset button text
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'hi': return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
