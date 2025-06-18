import 'package:flutter/material.dart';

// UI Constants
const double kCardBorderRadius = 16.0;

// Colors
const Color kPrimaryColor = Color(0xFF1A73E8);
const Color kSecondaryColor = Color(0xFF66BB6A);
const Color kErrorColor = Color(0xFFE53935);
const Color kWarningColor = Color(0xFFFFA726);

// Gradients
const LinearGradient kBackgroundGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFFE3F2FD),
    Color(0xFFFFFFFF),
    Color(0xFFFFFFFF),
  ],
  stops: [0.0, 0.3, 1.0],
);

// Form Constants
const int kMaxAttachments = 5;
const int kMaxFileSizeMB = 10;

// Lists
const List<String> kComplaintTypes = [
  'Theft',
  'Assault',
  'Fraud',
  'Harassment',
  'Other'
];

const List<String> kSeverityLevels = ['Minor', 'Moderate', 'Severe'];

const List<String> kRelationTypes = [
  'Colleague',
  'Friend',
  'Family',
  'Stranger',
  'Neighbor',
  'Other'
];

const List<String> kCyberCrimeTypes = [
  'Online Harassment',
  'Cyberstalking',
  'Identity Theft',
  'Financial Fraud',
  'Social Media Account Hacking',
  'Email Phishing',
  'Data Breach',
  'Ransomware Attack',
  'Online Impersonation',
  'Other'
];

const List<String> kPlatforms = [
  'Email',
  'Facebook',
  'Instagram',
  'Twitter',
  'WhatsApp',
  'LinkedIn',
  'Dating Apps',
  'Gaming Platforms',
  'Other Social Media',
  'Website/Web Application'
];

const List<String> kImpactTypes = [
  'Financial Loss',
  'Identity Theft',
  'Emotional Distress',
  'Reputation Damage',
  'Data Loss',
  'Account Compromise',
  'Business Disruption',
  'Privacy Violation'
];

const List<Map<String, dynamic>> kUrgencyLevels = [
  {'level': 'Low', 'color': Colors.green},
  {'level': 'Medium', 'color': Colors.orange},
  {'level': 'High', 'color': Colors.red},
];
