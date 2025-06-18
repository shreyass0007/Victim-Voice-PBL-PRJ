// ignore_for_file: undefined_hidden_name, unused_element, unused_local_variable, library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import '../utils/error_handler.dart' hide LoadingOverlay;
import '../utils/constants.dart';
import '../utils/validation_utils.dart';
import '../widgets/registration_form/form_widgets.dart'
    hide kErrorColor, kCardBorderRadius;
import '../widgets/registration_form/personal_details_section.dart';
import '../widgets/registration_form/complaint_details_section.dart';
import '../widgets/registration_form/accused_section.dart';
import '../widgets/registration_form/attachments_section.dart';
import '../widgets/registration_form/terms_section.dart';
import '../widgets/registration_form/cyber_crime_section.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:crypto/crypto.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  bool _isLoading = false;
  String _loadingText = 'Submitting form...';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _witnessNameController = TextEditingController();
  final TextEditingController _witnessContactController =
      TextEditingController();
  final TextEditingController _policeReportController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _deviceInfoController = TextEditingController();
  final TextEditingController _digitalEvidenceController =
      TextEditingController();
  final TextEditingController _financialLossController =
      TextEditingController();
  final TextEditingController _ipAddressController = TextEditingController();
  final TextEditingController _suspiciousActivityController =
      TextEditingController();

  final List<Map<String, dynamic>> _attachments = [];
  Position? _currentPosition;
  bool _termsAccepted = false;
  String _csrfToken = '';
  final List<TextEditingController> _accusedControllers = [
    TextEditingController()
  ];
  String? _selectedGender;
  String? _selectedComplaintType;
  bool _isAnonymous = false;
  String policeWhatsAppNumber = '+919022159520'; // Replace with actual number

  String? _selectedUrgency;
  bool _isCaptchaVerified = false;
  bool isIOS = false;

  // Crime details
  String? _crimeType;
  String? _selectedSeverityLevel;
  List<String> _selectedRelations = [];
  bool _isRepeatOffense = false;

  // Cyber crime specific fields
  String? _selectedCyberCrimeType;
  final List<String> _selectedPlatforms = [];
  final List<String> _selectedImpacts = [];
  bool _hasScreenshots = false;
  DateTime? _incidentStartDate;
  DateTime? _incidentEndDate;
  bool _dataBackupAvailable = false;
  bool _accountsSecured = false;
  bool _evidencePreserved = false;

  Timer? _autoSaveTimer;

  // Email configuration from environment variables
  late final String policeEmail;
  late final String emailSubject;
  late final String smtpUsername;
  late final String smtpPassword;

  // Add a getter for location
  String get currentLocation => _currentPosition != null
      ? '${_currentPosition!.latitude}, ${_currentPosition!.longitude}'
      : '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isIOS = Theme.of(context).platform == TargetPlatform.iOS;
  }

  @override
  void initState() {
    super.initState();
    _loadEmailConfig();
    _generateCsrfToken();
    _getCurrentLocation();
    _loadSavedForm();
    _autoSaveTimer =
        Timer.periodic(const Duration(seconds: 30), (_) => _autoSaveForm());
  }

  Future<void> _loadEmailConfig() async {
    try {
      policeEmail = dotenv.env['POLICE_EMAIL'] ?? 'default@example.com';
      emailSubject = dotenv.env['EMAIL_SUBJECT'] ?? 'New Complaint Report';
      smtpUsername = dotenv.env['SMTP_USERNAME'] ?? '';
      smtpPassword = dotenv.env['SMTP_PASSWORD'] ?? '';

      if (smtpUsername.isEmpty || smtpPassword.isEmpty) {
        ErrorHandler.showError(context, 'Email configuration is missing');
      }
    } catch (e) {
      ErrorHandler.showError(context, 'Failed to load email configuration');
    }
  }

  void _generateCsrfToken() {
    final random = DateTime.now().millisecondsSinceEpoch.toString();
    final bytes = utf8.encode(random);
    _csrfToken = sha256.convert(bytes).toString();
  }

  String? _validateInput(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    // Sanitize input
    value = ValidationUtils.sanitizeInput(value);

    switch (fieldName.toLowerCase()) {
      case 'email':
        if (!ValidationUtils.isValidEmail(value)) {
          return 'Please enter a valid email address';
        }
        break;
      case 'age':
        if (!ValidationUtils.isValidAge(value)) {
          return 'Please enter a valid age';
        }
        break;
      case 'url':
        if (value.isNotEmpty && !ValidationUtils.isValidUrl(value)) {
          return 'Please enter a valid URL';
        }
        break;
      case 'phone':
        if (value.isNotEmpty && !ValidationUtils.isValidPhone(value)) {
          return 'Please enter a valid phone number';
        }
        break;
    }
    return null;
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        setState(() => _isLoading = true);
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        setState(() {
          _isLoading = false;
          _currentPosition = position;
          _locationController.text =
              '${position.latitude}, ${position.longitude}';
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<bool> _validateAttachments() async {
    const maxSize = 10 * 1024 * 1024; // 10MB
    const allowedExtensions = [
      'pdf',
      'jpg',
      'jpeg',
      'png',
      'doc',
      'docx',
      'mp4'
    ];

    for (final attachment in _attachments) {
      final bytes = attachment['bytes'] as List<int>;
      final size = bytes.length;
      if (size > maxSize) {
        ErrorHandler.showError(
          context,
          'File ${attachment['name']} exceeds maximum size of 10MB',
        );
        return false;
      }

      final ext = attachment['type'] as String;
      if (!allowedExtensions.contains(ext.toLowerCase())) {
        ErrorHandler.showError(
          context,
          'File type .$ext is not allowed',
        );
        return false;
      }
    }
    return true;
  }

  Future<void> _loadSavedForm() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedForm = prefs.getString('complaint_draft');
      if (savedForm != null) {
        final data = json.decode(savedForm);
        setState(() {
          _nameController.text = data['name'] ?? '';
          _emailController.text = data['email'] ?? '';
          _ageController.text = data['age'] ?? '';
          _dateController.text = data['date'] ?? '';
          _descController.text = data['description'] ?? '';
          _locationController.text = data['location'] ?? '';
          _selectedGender = data['gender'];
          _selectedComplaintType = data['complaintType'];
          _isAnonymous = data['isAnonymous'] ?? false;
          _selectedUrgency = data['urgency'];
          _crimeType = data['crimeType'];
          _selectedSeverityLevel = data['severityLevel'];
          _selectedRelations = List<String>.from(data['relations'] ?? []);
          _isRepeatOffense = data['isRepeatOffense'] ?? false;
        });
      }
    } catch (e) {
      debugPrint('Error loading saved form: $e');
    }
  }

  Future<void> _autoSaveForm() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final formData = {
        'name': _nameController.text,
        'email': _emailController.text,
        'age': _ageController.text,
        'date': _dateController.text,
        'description': _descController.text,
        'location': _locationController.text,
        'gender': _selectedGender,
        'complaintType': _selectedComplaintType,
        'isAnonymous': _isAnonymous,
        'urgency': _selectedUrgency,
        'crimeType': _crimeType,
        'severityLevel': _selectedSeverityLevel,
        'relations': _selectedRelations,
        'isRepeatOffense': _isRepeatOffense,
        'lastSaved': DateTime.now().toIso8601String(),
      };
      await prefs.setString('complaint_draft', json.encode(formData));
      debugPrint('Form auto-saved successfully');
    } catch (e) {
      debugPrint('Error auto-saving form: $e');
    }
  }

  void _handleAttachmentChange(Map<String, dynamic> fileData) {
    setState(() {
      _attachments.add(fileData);
    });
  }

  void _removeAttachment(int index) {
    setState(() {
      _attachments.removeAt(index);
    });
  }

  void _addAccused() {
    setState(() {
      _accusedControllers.add(TextEditingController());
    });
  }

  void _removeAccused(int index) {
    setState(() {
      _accusedControllers[index].dispose();
      _accusedControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Complaint Form',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: isDark ? theme.scaffoldBackgroundColor : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        loadingText: _loadingText,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? [
                      Colors.grey.shade900,
                      Colors.blue.shade900.withOpacity(0.2),
                    ]
                  : [
                      Colors.white,
                      Colors.white,
                    ],
            ),
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildProgressIndicator(),
                  const SizedBox(height: 16),
                  _buildAnonymousSwitch(),
                  const SizedBox(height: 16),
                  if (!_isAnonymous) ...[
                    FormSectionCard(
                      title: 'Personal Details',
                      children: [
                        PersonalDetailsSection(
                          nameController: _nameController,
                          emailController: _emailController,
                          ageController: _ageController,
                          selectedGender: _selectedGender,
                          onGenderChanged: (value) =>
                              setState(() => _selectedGender = value),
                          isAnonymous: _isAnonymous,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                  FormSectionCard(
                    title: 'Complaint Details',
                    children: [
                      ComplaintDetailsSection(
                        selectedComplaintType: _selectedComplaintType,
                        crimeType: _crimeType,
                        selectedUrgency: _selectedUrgency,
                        dateController: _dateController,
                        locationController: _locationController,
                        descController: _descController,
                        onComplaintTypeChanged: (value) =>
                            setState(() => _selectedComplaintType = value),
                        onCrimeTypeChanged: (value) =>
                            setState(() => _crimeType = value),
                        onUrgencyChanged: (value) =>
                            setState(() => _selectedUrgency = value),
                        onLocationPressed: _getCurrentLocation,
                        onDatePressed: _showDatePicker,
                      ),
                      if (_selectedComplaintType == 'Cyber Crime')
                        CyberCrimeSection(
                          urlController: _urlController,
                          deviceInfoController: _deviceInfoController,
                          digitalEvidenceController: _digitalEvidenceController,
                          financialLossController: _financialLossController,
                          ipAddressController: _ipAddressController,
                          suspiciousActivityController:
                              _suspiciousActivityController,
                          selectedCyberCrimeType: _selectedCyberCrimeType,
                          selectedPlatforms: _selectedPlatforms,
                          selectedImpacts: _selectedImpacts,
                          hasScreenshots: _hasScreenshots,
                          dataBackupAvailable: _dataBackupAvailable,
                          accountsSecured: _accountsSecured,
                          evidencePreserved: _evidencePreserved,
                          incidentStartDate: _incidentStartDate,
                          incidentEndDate: _incidentEndDate,
                          onCyberCrimeTypeChanged: (value) =>
                              setState(() => _selectedCyberCrimeType = value),
                          onScreenshotsChanged: (value) =>
                              setState(() => _hasScreenshots = value),
                          onDataBackupChanged: (value) =>
                              setState(() => _dataBackupAvailable = value),
                          onAccountsSecuredChanged: (value) =>
                              setState(() => _accountsSecured = value),
                          onEvidencePreservedChanged: (value) =>
                              setState(() => _evidencePreserved = value),
                          onStartDateChanged: (value) =>
                              setState(() => _incidentStartDate = value),
                          onEndDateChanged: (value) =>
                              setState(() => _incidentEndDate = value),
                          onPlatformToggled: (platform, selected) {
                            setState(() {
                              if (selected) {
                                _selectedPlatforms.add(platform);
                              } else {
                                _selectedPlatforms.remove(platform);
                              }
                            });
                          },
                          onImpactToggled: (impact, selected) {
                            setState(() {
                              if (selected) {
                                _selectedImpacts.add(impact);
                              } else {
                                _selectedImpacts.remove(impact);
                              }
                            });
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FormSectionCard(
                    title: 'Accused Information',
                    children: [
                      AccusedSection(
                        accusedControllers: _accusedControllers,
                        onAddAccused: _addAccused,
                        onRemoveAccused: _removeAccused,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FormSectionCard(
                    title: 'Evidence & Attachments',
                    children: [
                      AttachmentsSection(
                        attachments: _attachments,
                        onFileSelected: (fileData) {
                          setState(() {
                            _attachments.add(fileData);
                          });
                        },
                        onRemoveAttachment: (index) =>
                            setState(() => _attachments.removeAt(index)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FormSectionCard(
                    title: 'Terms & Verification',
                    children: [
                      TermsSection(
                        agreedToTerms: _termsAccepted,
                        isCaptchaVerified: _isCaptchaVerified,
                        onTermsChanged: (value) =>
                            setState(() => _termsAccepted = value ?? false),
                        onShowTerms: _showTerms,
                        onShowPrivacyPolicy: _showPrivacyPolicy,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSubmitButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            'Form Progress',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.blue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? theme.cardColor : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  isDark ? Colors.grey.shade800 : Colors.blue.withOpacity(0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.2)
                    : Colors.blue.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: _calculateProgress(),
                  backgroundColor: isDark
                      ? Colors.grey.shade800
                      : Colors.blue.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(
                      isDark ? Colors.blue.shade300 : Colors.blue),
                  minHeight: 12,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${(_calculateProgress() * 100).toInt()}% completed',
                style: TextStyle(
                  color: isDark ? Colors.grey.shade300 : Colors.blue.shade700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  double _calculateProgress() {
    int totalSteps = 5; // Total number of sections
    int completedSteps = 1; // Start with 1 for Filing Type

    if (!_isAnonymous && _nameController.text.isNotEmpty) completedSteps++;
    if (_selectedComplaintType != null) completedSteps++;
    if (_accusedControllers.first.text.isNotEmpty) completedSteps++;
    if (_attachments.isNotEmpty || _termsAccepted) completedSteps++;

    return completedSteps / totalSteps;
  }

  Widget _buildAnonymousSwitch() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? theme.cardColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.blue.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.2)
                : Colors.blue.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SwitchListTile(
        title: Text(
          'File Anonymous Complaint',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.blue.shade700,
          ),
        ),
        subtitle: Text(
          'Your personal details will not be included',
          style: TextStyle(
            color: isDark ? Colors.grey.shade400 : Colors.blue.shade600,
          ),
        ),
        value: _isAnonymous,
        onChanged: (bool value) {
          setState(() {
            _isAnonymous = value;
            if (value) {
              _nameController.clear();
              _emailController.clear();
              _ageController.clear();
              _selectedGender = null;
            }
          });
        },
        activeColor: isDark ? Colors.blue.shade300 : Colors.blue,
      ),
    );
  }

  Widget _buildSubmitButtons() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          Colors.blue.shade700,
                          Colors.blue.shade900,
                        ]
                      : [
                          Colors.blue.shade600,
                          Colors.blue.shade900,
                        ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withOpacity(0.3)
                        : Colors.blue.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _submitForm,
                icon: Icon(
                  Icons.send_rounded,
                  color: isDark ? Colors.white.withOpacity(0.9) : Colors.white,
                ),
                label: Text(
                  'Submit Complaint',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color:
                        isDark ? Colors.white.withOpacity(0.9) : Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: isDark ? theme.cardColor : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withOpacity(0.2)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: OutlinedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        'Clear Form',
                        style: TextStyle(
                          color: isDark ? Colors.red.shade300 : kErrorColor,
                        ),
                      ),
                      content: Text(
                        'Are you sure you want to clear all entered information?',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark
                              ? Colors.grey.shade300
                              : Colors.grey.shade800,
                        ),
                      ),
                      backgroundColor:
                          isDark ? theme.dialogBackgroundColor : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: isDark
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _clearForm();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isDark ? Colors.red.shade900 : kErrorColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Clear',
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white.withOpacity(0.9)
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                icon: Icon(
                  Icons.refresh_rounded,
                  color: isDark ? Colors.red.shade300 : kErrorColor,
                ),
                label: Text(
                  'Clear Form',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.red.shade300 : kErrorColor,
                    letterSpacing: 0.5,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDatePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _dateController.text =
            '${pickedDate.day}-${pickedDate.month}-${pickedDate.year}';
      });
    }
  }

  void _showTerms() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: const SingleChildScrollView(
          child: Text(
            'Your terms of service ..\n\n'
            '1. By submitting this form, you confirm that all information provided is true and accurate.\n'
            '2. False complaints may result in legal action.\n'
            '3. Your information will be handled as per our privacy policy.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'Your privacy policy text here...\n\n'
            '1. We collect and process your information to handle your complaint.\n'
            '2. Your information is kept confidential and secure.\n'
            '3. We share information only with relevant law enforcement authorities.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _verifyCaptcha() async {
    setState(() => _isLoading = true);
    try {
      bool? result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Verify you are human'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Please check the box below to verify'),
              const SizedBox(height: 16),
              Checkbox(
                value: _isCaptchaVerified,
                onChanged: (value) {
                  setState(() => _isCaptchaVerified = value ?? false);
                  Navigator.of(context).pop(value);
                },
              ),
            ],
          ),
        ),
      );
      setState(() => _isCaptchaVerified = result ?? false);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _clearForm() {
    setState(() {
      _nameController.clear();
      _emailController.clear();
      _ageController.clear();
      _dateController.clear();
      _descController.clear();
      _locationController.clear();
      _witnessNameController.clear();
      _witnessContactController.clear();
      _selectedGender = null;
      _selectedComplaintType = null;
      _isAnonymous = false;
      _attachments.clear();
      _accusedControllers.clear();
      _accusedControllers.add(TextEditingController());
      _selectedUrgency = null;
      _termsAccepted = false;
      _isCaptchaVerified = false;
      _crimeType = null;
      _selectedCyberCrimeType = null;
      _selectedPlatforms.clear();
      _urlController.clear();
      _deviceInfoController.clear();
      _digitalEvidenceController.clear();
      _hasScreenshots = false;
      _incidentStartDate = null;
      _incidentEndDate = null;
      _financialLossController.clear();
      _ipAddressController.clear();
      _suspiciousActivityController.clear();
      _selectedImpacts.clear();
      _dataBackupAvailable = false;
      _accountsSecured = false;
      _evidencePreserved = false;
    });

    ErrorHandler.showSuccess(context, 'Form cleared successfully!');
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      ErrorHandler.showError(
          context, 'Please fill all required fields correctly');
      return;
    }

    if (!_termsAccepted) {
      ErrorHandler.showError(
          context, 'Please agree to the terms and conditions');
      return;
    }

    if (!_isCaptchaVerified) {
      await _verifyCaptcha();
      if (!_isCaptchaVerified) {
        ErrorHandler.showError(
            context, 'Please complete the CAPTCHA verification');
        return;
      }
    }

    setState(() {
      _isLoading = true;
      _loadingText = 'Submitting complaint...';
    });

    try {
      // Create safe copies of lists with null checks
      final relations = List<String>.from(_selectedRelations);
      final platforms = List<String>.from(_selectedPlatforms);
      final impacts = List<String>.from(_selectedImpacts);
      final accusedNames = _accusedControllers
          .map((controller) => controller.text)
          .where((text) => text.isNotEmpty)
          .toList();

      // Generate complaint data for PDF
      final Map<String, dynamic> complaintData = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'timestamp': DateTime.now().toIso8601String(),
        'status': 'Sent',
        'isAnonymous': _isAnonymous,
        'complaintType': _selectedComplaintType ?? '',
        'description': _descController.text,
        'location': _locationController.text,
        'name': _isAnonymous ? 'Anonymous' : _nameController.text,
        'email': _isAnonymous ? 'anonymous@example.com' : _emailController.text,
        'age': _isAnonymous ? '' : _ageController.text,
        'gender': _isAnonymous ? '' : (_selectedGender ?? ''),
        'accusedNames': accusedNames,
        'urgencyLevel': _selectedUrgency ?? 'Medium',
        'crimeType': _crimeType ?? '',
        'severityLevel': _selectedSeverityLevel ?? '',
        'relations': relations,
        'isRepeatOffense': _isRepeatOffense,
        'policeReport': _policeReportController.text,
        'attachments': _attachments
            .map((attachment) => attachment['bytes'] as List<int>)
            .toList(),
      };

      // Generate PDF
      final pdf = pw.Document();
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              // Header with logo and title
              pw.Header(
                level: 0,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Victim Voice',
                            style: pw.TextStyle(
                                fontSize: 28, fontWeight: pw.FontWeight.bold)),
                        pw.Text('Complaint Details Report',
                            style: pw.TextStyle(
                                fontSize: 16, color: PdfColors.grey700)),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'Generated on:',
                          style: pw.TextStyle(color: PdfColors.grey700),
                        ),
                        pw.Text(
                          DateFormat('dd MMM yyyy, HH:mm')
                              .format(DateTime.now()),
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Complaint ID and Status Section
              pw.Container(
                padding: pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Complaint ID: #${complaintData['id']}',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Status: ${complaintData['status']}',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Filing Type Section
              pw.Container(
                padding: pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      complaintData['isAnonymous'] as bool
                          ? 'Anonymous Complaint'
                          : 'Named Complaint',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      'Submitted on: ${DateFormat('dd MMM yyyy, HH:mm').format(DateTime.parse(complaintData['timestamp'] as String))}',
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 15),

              // Personal Details Section (if not anonymous)
              if (!(complaintData['isAnonymous'] as bool)) ...[
                pw.Container(
                  padding: pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Personal Details',
                          style: pw.TextStyle(
                              fontSize: 16, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 10),
                      _buildPDFDetailRow(
                          'Name', complaintData['name'] as String),
                      _buildPDFDetailRow('Age', complaintData['age'] as String),
                      _buildPDFDetailRow(
                          'Gender', complaintData['gender'] as String),
                      _buildPDFDetailRow(
                          'Email', complaintData['email'] as String),
                    ],
                  ),
                ),
                pw.SizedBox(height: 15),
              ],

              // Complaint Details Section
              pw.Container(
                padding: pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Complaint Details',
                        style: pw.TextStyle(
                            fontSize: 16, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 10),
                    _buildPDFDetailRow(
                        'Type', complaintData['complaintType'] as String),
                    _buildPDFDetailRow(
                        'Crime Type', complaintData['crimeType'] as String),
                    _buildPDFDetailRow('Urgency Level',
                        complaintData['urgencyLevel'] as String),
                    _buildPDFDetailRow('Severity Level',
                        complaintData['severityLevel'] as String),
                    _buildPDFDetailRow(
                        'Location', complaintData['location'] as String),
                    pw.SizedBox(height: 10),
                    pw.Text('Description:',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Container(
                      padding: pw.EdgeInsets.all(8),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.grey200,
                        borderRadius: pw.BorderRadius.circular(4),
                      ),
                      child: pw.Text(complaintData['description'] as String),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 15),

              // Accused Information Section
              if (accusedNames.isNotEmpty) ...[
                pw.Container(
                  padding: pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Accused Information',
                          style: pw.TextStyle(
                              fontSize: 16, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 10),
                      ...accusedNames.asMap().entries.map((entry) {
                        return pw.Text(
                            'Accused ${entry.key + 1}: ${entry.value}');
                      }),
                    ],
                  ),
                ),
                pw.SizedBox(height: 15),
              ],

              // Footer
              pw.Divider(color: PdfColors.grey400),
              pw.SizedBox(height: 10),
              pw.Text(
                'This is an official copy of the complaint submission. Please keep this document for your records.',
                style: pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey600,
                  fontStyle: pw.FontStyle.italic,
                ),
                textAlign: pw.TextAlign.center,
              ),
            ];
          },
        ),
      );

      // Save PDF temporarily
      final output = await getTemporaryDirectory();
      final fileName =
          'complaint_${complaintData['id']}_${DateFormat('ddMMyyyy').format(DateTime.now())}.pdf';
      final file = File('${output.path}/$fileName');
      await file.writeAsBytes(await pdf.save());

      // Create the email message
      final message = Message()
        ..from =
            Address(smtpUsername, 'Victim Voice - Official Complaint System')
        ..recipients.add(policeEmail)
        ..subject = emailSubject
        ..text = '''
Dear Sir/Madam,

This is an official communication from the Victim Voice Complaint Management System.

A new complaint has been submitted and requires your attention. Please find the detailed complaint report attached to this email.

Complaint Details:
- Complaint ID: #${complaintData['id']}
- Submission Date: ${DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now())}
- Complaint Type: ${complaintData['complaintType']}
- Urgency Level: ${complaintData['urgencyLevel']}

Please review the attached PDF document for complete details of the complaint.

Best regards,
Victim Voice Complaint Management System
''';

      // Add the PDF as an attachment
      message.attachments.add(
        FileAttachment(file)
          ..location = Location.attachment
          ..cid = '<complaint_report.pdf>',
      );

      // Add other attachments if any
      if (_attachments.isNotEmpty) {
        for (var attachment in _attachments) {
          if (attachment['bytes'] != null) {
            final attachmentBytes = attachment['bytes'] as List<int>;
            final fileName = attachment['name'] as String;
            message.attachments.add(
              StreamAttachment(
                Stream.fromIterable([attachmentBytes]),
                fileName,
              )
                ..location = Location.attachment
                ..cid = '<$fileName>',
            );
          }
        }
      }

      // Set up SMTP server with explicit configuration
      final smtpServer = SmtpServer(
        'smtp.gmail.com',
        port: 587,
        username: smtpUsername,
        password: smtpPassword,
        ssl: false,
        allowInsecure: true,
      );

      // Send email with timeout and error handling
      try {
        final sendReport = await send(message, smtpServer).timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            throw TimeoutException(
                'Email sending timed out. Please try again.');
          },
        );

        // Save to history
        final prefs = await SharedPreferences.getInstance();
        List<String> complaintsList =
            prefs.getStringList('complaints_history') ?? [];
        complaintsList.add(jsonEncode(complaintData));
        await prefs.setStringList('complaints_history', complaintsList);

        // Clear form after successful submission
        await prefs.remove('complaint_draft');
        _clearForm();
        ErrorHandler.showSuccess(context, 'Complaint submitted successfully!');
      } catch (e) {
        throw Exception('Failed to send email: ${e.toString()}');
      }
    } catch (e) {
      debugPrint('Error in submission: $e');
      ErrorHandler.showError(
          context, 'Failed to submit complaint: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  pw.Widget _buildPDFDetailRow(String label, String value) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 120,
            child: pw.Text(
              label,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Expanded(
            child: pw.Text(value),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _dateController.dispose();
    _descController.dispose();
    _locationController.dispose();
    _witnessNameController.dispose();
    _witnessContactController.dispose();
    _policeReportController.dispose();
    _urlController.dispose();
    _deviceInfoController.dispose();
    _digitalEvidenceController.dispose();
    _financialLossController.dispose();
    _ipAddressController.dispose();
    _suspiciousActivityController.dispose();
    for (var controller in _accusedControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
