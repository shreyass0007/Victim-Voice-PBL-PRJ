import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'dart:html' as html;
import 'package:flutter/cupertino.dart';

const _cardBorderRadius = 16.0;
const _primaryColor = Color(0xFF1A73E8);
const _secondaryColor = Color(0xFF66BB6A);
const _errorColor = Color(0xFFE53935);
const _warningColor = Color(0xFFFFA726);

const _backgroundGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFFE3F2FD),
    Color(0xFFFFFFFF),
    Color(0xFFFFFFFF),
  ],
  stops: [0.0, 0.3, 1.0],
);

class CustomCupertinoNavigationBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomCupertinoNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBar(
      middle: Text('Complaint Form'),
      backgroundColor: CupertinoColors.systemBlue.withOpacity(0.1),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(44.0);
}

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _compController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _witnessNameController = TextEditingController();
  final TextEditingController _witnessContactController =
      TextEditingController();
  final TextEditingController _policeReportController = TextEditingController();

  String? _selectedGender;
  String? _selectedComplaintType;
  bool _isAnonymous = false;
  final List<Map<String, dynamic>> _attachments = [];
  final List<String> complaintTypes = [
    'Theft',
    'Assault',
    'Fraud',
    'Harassment',
    'Other'
  ];
  final int _maxAttachments = 5;
  final int _maxFileSizeMB = 10;

  String policeWhatsAppNumber = '+919022159520'; // Replace with actual number

  List<TextEditingController> _accusedControllers = [TextEditingController()];

  String? _selectedUrgency;
  final List<Map<String, dynamic>> urgencyLevels = [
    {'level': 'Low', 'color': Colors.green},
    {'level': 'Medium', 'color': Colors.orange},
    {'level': 'High', 'color': Colors.red},
  ];

  bool _agreedToTerms = false;
  bool _isCaptchaVerified = false;
  bool isIOS = false;

  String? _crimeType;

  String? _selectedSeverityLevel;
  List<String> _selectedRelations = [];
  bool _isRepeatOffense = false;

  final List<String> severityLevels = ['Minor', 'Moderate', 'Severe'];
  final List<String> relationTypes = [
    'Colleague',
    'Friend',
    'Family',
    'Stranger',
    'Neighbor',
    'Other'
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isIOS = Theme.of(context).platform == TargetPlatform.iOS;
  }

  Future<void> _addAttachment() async {
    if (_attachments.length >= _maxAttachments) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Maximum $_maxAttachments attachments allowed'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx', 'mp4'],
        allowMultiple: true,
        withData: true,
      );

      if (result != null) {
        for (var file in result.files) {
          if (_attachments.length >= _maxAttachments) break;

          final sizeInMB = file.size / (1024 * 1024);
          if (sizeInMB > _maxFileSizeMB) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${file.name} exceeds $_maxFileSizeMB MB limit'),
                backgroundColor: Colors.red,
              ),
            );
            continue;
          }

          setState(() {
            _attachments.add({
              'file': file,
              'name': file.name,
              'size': sizeInMB.toStringAsFixed(2),
              'type': file.extension ?? 'unknown',
              'bytes': file.bytes,
            });
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking files: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
    return Scaffold(
      appBar: isIOS
          ? CustomCupertinoNavigationBar()
          : AppBar(
              title: Text(
                'Complaint Form',
                style: TextStyle(
                    color: _primaryColor, fontWeight: FontWeight.bold),
              ),
              elevation: 0,
              backgroundColor: Colors.white,
              centerTitle: true,
            ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: _backgroundGradient,
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  _buildProgressIndicator(),
                  // Filing Type Section
                  _buildSectionCard(
                    title: 'Filing Type',
                    children: [
                      _buildAnonymousSwitch(),
                    ],
                  ),

                  // Personal Details Section (if not anonymous)
                  if (!_isAnonymous)
                    _buildSectionCard(
                      title: 'Personal Details',
                      children: [
                        _buildPersonalDetailsFields(),
                      ],
                    ),

                  // Complaint Details Section
                  _buildSectionCard(
                    title: 'Complaint Details',
                    children: [
                      _buildComplaintDetailsFields(),
                    ],
                  ),

                  // Accused Information Section
                  _buildSectionCard(
                    title: 'Accused Information',
                    children: [
                      _buildAccusedSection(),
                    ],
                  ),

                  // Evidence & Attachments Section
                  _buildSectionCard(
                    title: 'Evidence & Attachments',
                    children: [
                      _buildAttachmentsSection(),
                    ],
                  ),

                  // Terms & Verification Section
                  _buildSectionCard(
                    title: 'Terms & Verification',
                    children: [
                      _buildTermsAndCaptcha(),
                    ],
                  ),

                  SizedBox(height: 24),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            'Form Progress',
            style: TextStyle(
              color: _primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 2),
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
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
                  minHeight: 12,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '${(_calculateProgress() * 100).toInt()}% completed',
                style: TextStyle(
                  color: Colors.grey.shade600,
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
    if (_attachments.isNotEmpty || _agreedToTerms) completedSteps++;

    return completedSteps / totalSteps;
  }

  Widget _buildAnonymousSwitch() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: SwitchListTile(
        title: Text(
          'File Anonymous Complaint',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _primaryColor,
          ),
        ),
        subtitle: Text(
          'Your personal details will not be included',
          style: TextStyle(color: Colors.grey.shade600),
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
        activeColor: _secondaryColor,
      ),
    );
  }

  Widget _buildPersonalDetailsFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputField(
          controller: _nameController,
          label: 'Name',
          icon: Icons.person,
          validator: (value) =>
              !_isAnonymous && value!.isEmpty ? 'Please enter your name' : null,
        ),
        _buildInputField(
          controller: _ageController,
          label: 'Age',
          icon: Icons.calendar_today,
          keyboardType: TextInputType.number,
          validator: (value) =>
              !_isAnonymous && value!.isEmpty ? 'Please enter your age' : null,
        ),
        _buildGenderSelector(),
        _buildInputField(
          controller: _emailController,
          label: 'Email',
          icon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          validator: (value) =>
              !_isAnonymous && value!.isEmpty ? 'Please enter an email' : null,
        ),
      ],
    );
  }

  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Gender:', style: TextStyle(fontWeight: FontWeight.bold)),
        Column(
          children: ['Male', 'Female', 'Other'].map((gender) {
            return RadioListTile<String>(
              title: Text(gender),
              value: gender,
              groupValue: _selectedGender,
              onChanged: (value) {
                setState(() => _selectedGender = value);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildComplaintDetailsFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDropdownField<String>(
          label: 'Complaint Type',
          icon: Icons.category,
          value: _selectedComplaintType,
          items: complaintTypes,
          onChanged: (value) {
            setState(() => _selectedComplaintType = value);
          },
          itemLabel: (item) => item,
          validator: (value) =>
              value == null ? 'Please select complaint type' : null,
        ),
        SizedBox(height: 16),
        _buildCrimeTypeSelector(),
        _buildUrgencySelector(),
        SizedBox(height: 16),
        _buildDateAndLocationFields(),
        _buildDescriptionField(),
        _buildAdditionalComplaintDetails(),
      ],
    );
  }

  Widget _buildDateAndLocationFields() {
    return Column(
      children: [
        _buildInputField(
          controller: _dateController,
          label: 'Date of Incident',
          icon: Icons.event,
          suffixIcon: IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => _showDatePicker(),
          ),
          validator: (value) => value!.isEmpty ? 'Please select a date' : null,
        ),
        _buildInputField(
          controller: _locationController,
          label: 'Location of Incident',
          icon: Icons.location_on,
          suffixIcon: IconButton(
            icon: Icon(Icons.my_location),
            onPressed: _getCurrentLocation,
          ),
          validator: (value) => value!.isEmpty ? 'Please enter location' : null,
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return _buildInputField(
      controller: _descController,
      label: 'Complaint Description',
      icon: Icons.description,
      maxLines: 5,
      validator: (value) =>
          value!.isEmpty ? 'Please enter your description' : null,
    );
  }

  Widget _buildSubmitButtons() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
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
                  colors: [
                    _primaryColor,
                    Color(0xFF0D47A1), // Darker blue
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: _confirmSubmission,
                icon: Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 24,
                ),
                label: Text(
                  'Submit Complaint',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
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
          SizedBox(width: 16),
          Expanded(
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: Offset(0, 4),
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
                        style: TextStyle(color: _errorColor),
                      ),
                      content: Text(
                        'Are you sure you want to clear all entered information?',
                        style: TextStyle(fontSize: 16),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _clearForm();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _errorColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text('Clear'),
                        ),
                      ],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  );
                },
                icon: Icon(
                  Icons.refresh_rounded,
                  color: _errorColor,
                  size: 24,
                ),
                label: Text(
                  'Clear Form',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: _errorColor,
                    letterSpacing: 0.5,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
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

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _locationController.text = '${position.latitude}, ${position.longitude}';
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not get location. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _verifyCaptcha() async {
    setState(() => _isLoading = true);
    try {
      // Using a simple checkbox CAPTCHA for now
      bool? result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text('Verify you are human'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Please check the box below to verify'),
              SizedBox(height: 16),
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

  Future<void> _confirmSubmission() async {
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please agree to the Terms and Privacy Policy'),
          backgroundColor: _errorColor,
        ),
      );
      return;
    }

    if (!_isCaptchaVerified) {
      await _verifyCaptcha();
      if (!_isCaptchaVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please complete the CAPTCHA verification'),
            backgroundColor: _errorColor,
          ),
        );
        return;
      }
    }

    if (_formKey.currentState!.validate()) {
      bool? confirm = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Confirm Submission',
              style: TextStyle(
                color: _primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: _secondaryColor,
                  size: 48,
                ),
                SizedBox(height: 16),
                Text(
                  'Are you sure you want to submit the complaint?',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            actionsPadding: EdgeInsets.all(16),
          );
        },
      );

      if (confirm == true) {
        _submitForm();
      }
    }
  }

  Future<void> _submitForm() async {
    try {
      _showNotification('Opening WhatsApp...', true);

      final message = _formatWhatsAppMessage();
      final encodedMessage = Uri.encodeComponent(message);
      final whatsappUrl =
          "https://web.whatsapp.com/send?phone=$policeWhatsAppNumber&text=$encodedMessage";

      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        await launchUrl(
          Uri.parse(whatsappUrl),
          mode: LaunchMode.platformDefault,
          webOnlyWindowName: '_blank',
        );

        // Clear saved draft after successful submission
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('complaint_draft');

        // Clear form after a short delay
        Future.delayed(Duration(seconds: 2), () {
          _clearForm();
        });

        _showNotification('Complaint submitted successfully!', true);
      } else {
        throw 'Could not launch WhatsApp';
      }
    } catch (e) {
      _showNotification('Error submitting complaint. Please try again.', false);
    }
  }

  String _formatWhatsAppMessage() {
    final accusedNames = _accusedControllers
        .map((controller) => controller.text)
        .where((text) => text.isNotEmpty)
        .toList();

    final message = '''
*${_isAnonymous ? 'ANONYMOUS ' : ''}COMPLAINT REGISTRATION FORM*

${_isAnonymous ? '*Anonymous Complaint*' : '''*Personal Details:*
Name: ${_nameController.text}
Age: ${_ageController.text}
Gender: $_selectedGender
Email: ${_emailController.text}'''}

*Complaint Details:*
Type: $_selectedComplaintType
Crime Type: ${_crimeType ?? 'Not specified'}
Urgency: ${_selectedUrgency ?? 'Not specified'}
${accusedNames.length > 1 ? 'Accused Names:' : 'Accused Name:'} ${accusedNames.join(', ')}
Date of Incident: ${_dateController.text}
Location: ${_locationController.text}

*Description:*
${_descController.text}

${_witnessNameController.text.isNotEmpty ? '''*Witness Details:*
Name: ${_witnessNameController.text}
Contact: ${_witnessContactController.text}''' : ''}

*Attachments:*
${_attachments.isNotEmpty ? "- Files attached: ${_attachments.map((file) => file['name']).join(', ')}" : "No attachments"}
${_attachments.any((file) => file['type'] == 'mp4') ? "- Video file available (will be shared separately)" : ""}

*Additional Details:*
Severity Level: ${_selectedSeverityLevel ?? 'Not specified'}
${_selectedRelations.isNotEmpty ? 'Relation to Accused: ${_selectedRelations.join(', ')}' : ''}
${_isRepeatOffense ? 'This is a repeat offense' : ''}
${_policeReportController.text.isNotEmpty ? 'Police Report Reference: ${_policeReportController.text}' : ''}

*Form ID:* ${DateTime.now().millisecondsSinceEpoch}

This ${_isAnonymous ? 'anonymous ' : ''}complaint was submitted through the official complaint registration system.
''';
    return message;
  }

  void _clearForm() {
    setState(() {
      _nameController.clear();
      _emailController.clear();
      _ageController.clear();
      _dateController.clear();
      _compController.clear();
      _descController.clear();
      _locationController.clear();
      _witnessNameController.clear();
      _witnessContactController.clear();
      _selectedGender = null;
      _selectedComplaintType = null;
      _isAnonymous = false;
      _attachments.clear();
      for (var controller in _accusedControllers) {
        controller.dispose();
      }
      _accusedControllers = [TextEditingController()];
      _selectedUrgency = null;
      _agreedToTerms = false;
      _isCaptchaVerified = false;
      _crimeType = null;
      _selectedSeverityLevel = null;
      _selectedRelations = [];
      _isRepeatOffense = false;
      _policeReportController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Form cleared successfully')),
    );
  }

  Widget _buildAttachmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Attachments',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text(
          'Allowed files: Images, PDF, DOC, MP4 (Max ${_maxFileSizeMB}MB each)',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _addAttachment,
                icon: Icon(Icons.attach_file, color: _primaryColor),
                label: Text(
                    'Add Files (${_attachments.length}/$_maxAttachments)',
                    style: TextStyle(fontSize: 16, color: _primaryColor)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        if (_attachments.isNotEmpty) ...[
          _buildAttachmentsList(),
        ] else
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                'No attachments added',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAttachmentsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _attachments.length,
      itemBuilder: (context, index) {
        final attachment = _attachments[index];
        return Card(
          elevation: 2,
          margin: EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: Icon(_getFileIcon(attachment['type'])),
            title: Text(
              attachment['name'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text('${attachment['size']} MB'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (kIsWeb)
                  IconButton(
                    icon: Icon(Icons.visibility, color: Colors.blue),
                    onPressed: () => _previewFile(attachment),
                  ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeAttachment(index),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _previewFile(Map<String, dynamic> attachment) {
    if (kIsWeb && attachment['bytes'] != null) {
      final blob = html.Blob([attachment['bytes']]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.window.open(url, '_blank');
      // Revoke the URL after a delay to ensure the browser has time to open it
      Future.delayed(Duration(seconds: 1), () {
        html.Url.revokeObjectUrl(url);
      });
    }
  }

  IconData _getFileIcon(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'mp4':
        return Icons.video_file;
      default:
        return Icons.insert_drive_file;
    }
  }

  Widget _buildAccusedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Accused Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton.icon(
              onPressed: _addAccused,
              icon: Icon(Icons.add),
              label: Text('Add Another'),
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _accusedControllers.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _accusedControllers[index],
                      decoration: InputDecoration(
                        labelText: 'Accused ${index + 1}',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter accused name' : null,
                    ),
                  ),
                  if (_accusedControllers.length > 1)
                    IconButton(
                      icon: Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () => _removeAccused(index),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildUrgencySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Urgency Level',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Row(
          children: urgencyLevels.map((urgency) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedUrgency = urgency['level'];
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedUrgency == urgency['level']
                        ? urgency['color']
                        : Colors.grey[300],
                    foregroundColor: _selectedUrgency == urgency['level']
                        ? Colors.white
                        : Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(urgency['level']),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCrimeTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Crime Type',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: Text('Online'),
                value: 'Online',
                groupValue: _crimeType,
                onChanged: (value) {
                  setState(() => _crimeType = value);
                },
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: Text('Offline'),
                value: 'Offline',
                groupValue: _crimeType,
                onChanged: (value) {
                  setState(() => _crimeType = value);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTermsAndCaptcha() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListTile(
          title: Row(
            children: [
              Text('I agree to the '),
              TextButton(
                onPressed: () => _showTerms(),
                child: Text('Terms',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: _primaryColor)),
              ),
              Text(' and '),
              TextButton(
                onPressed: () => _showPrivacyPolicy(),
                child: Text('Privacy Policy',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: _primaryColor)),
              ),
            ],
          ),
          value: _agreedToTerms,
          onChanged: (value) {
            setState(() => _agreedToTerms = value ?? false);
          },
        ),
        if (_isCaptchaVerified)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 20),
                SizedBox(width: 8),
                Text('CAPTCHA verified', style: TextStyle(color: Colors.green)),
              ],
            ),
          ),
        SizedBox(height: 16),
      ],
    );
  }

  void _showTerms() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Terms of Service'),
        content: SingleChildScrollView(
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
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Privacy Policy'),
        content: SingleChildScrollView(
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
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showNotification(String message, bool isSuccess) {
    if (isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                isSuccess ? Icons.check_circle : Icons.error,
                color: Colors.white,
              ),
              SizedBox(width: 8),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: isSuccess ? Colors.green : Colors.red,
          duration: Duration(seconds: isSuccess ? 3 : 4),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          action: SnackBarAction(
            label: 'DISMISS',
            textColor: Colors.white,
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentSnackBar(),
          ),
        ),
      );
    }
  }

  Widget _buildAdditionalComplaintDetails() {
    return _buildSectionCard(
      title: 'Additional Details',
      backgroundColor: Colors.grey.shade50,
      children: [
        _buildDropdownField<String>(
          label: 'Crime Severity Level',
          icon: Icons.warning_amber_rounded,
          value: _selectedSeverityLevel,
          items: severityLevels,
          onChanged: (value) => setState(() => _selectedSeverityLevel = value),
          itemLabel: (item) => item,
        ),
        Text('Relation to Accused (Optional)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            )),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade200),
          ),
          padding: EdgeInsets.all(12),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: relationTypes.map((String relation) {
              return FilterChip(
                label: Text(relation),
                selected: _selectedRelations.contains(relation),
                onSelected: (bool selected) {
                  setState(() {
                    if (selected) {
                      _selectedRelations.add(relation);
                    } else {
                      _selectedRelations.remove(relation);
                    }
                  });
                },
                backgroundColor: Colors.grey.shade100,
                selectedColor: Colors.blue.shade100,
                labelStyle: TextStyle(
                  color: _selectedRelations.contains(relation)
                      ? Colors.blue.shade700
                      : Colors.black87,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: CheckboxListTile(
            title: Text('This is a repeat offense',
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('The accused has committed this offense before'),
            value: _isRepeatOffense,
            onChanged: (bool? value) {
              setState(() => _isRepeatOffense = value ?? false);
            },
            activeColor: Colors.blue.shade400,
          ),
        ),
        SizedBox(height: 16),
        _buildInputField(
          controller: _policeReportController,
          label: 'Police Report Reference Number (Optional)',
          icon: Icons.assignment,
          hintText: 'Enter if already reported to police',
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _dateController.dispose();
    _compController.dispose();
    _descController.dispose();
    _locationController.dispose();
    _witnessNameController.dispose();
    _witnessContactController.dispose();
    _policeReportController.dispose();
    for (var controller in _accusedControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}

Widget _buildSectionHeader(String title) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 24),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.arrow_right, color: Colors.blue.shade700),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 16),
    ],
  );
}

Widget _buildSectionCard({
  required String title,
  required List<Widget> children,
  Color? backgroundColor,
}) {
  return Container(
    margin: EdgeInsets.only(bottom: 24),
    decoration: BoxDecoration(
      color: backgroundColor ?? Colors.white,
      borderRadius: BorderRadius.circular(_cardBorderRadius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _primaryColor.withOpacity(0.1),
                _primaryColor.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(_cardBorderRadius),
              topRight: Radius.circular(_cardBorderRadius),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: _primaryColor.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(_getSectionIcon(title), color: _primaryColor),
              ),
              SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    ),
  );
}

Widget _buildInputField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  String? Function(String?)? validator,
  TextInputType keyboardType = TextInputType.text,
  bool readOnly = false,
  Widget? suffixIcon,
  int maxLines = 1,
  String? hintText,
}) {
  return Container(
    margin: EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _primaryColor, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            prefixIcon: Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: _primaryColor, size: 20),
            ),
            suffixIcon: suffixIcon,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines > 1 ? 16 : 0,
            ),
          ),
          keyboardType: keyboardType,
          validator: validator,
          readOnly: readOnly,
          maxLines: maxLines,
        ),
      ],
    ),
  );
}

Widget _buildDropdownField<T>({
  required String label,
  required IconData icon,
  required T? value,
  required List<T> items,
  required void Function(T?) onChanged,
  required String Function(T) itemLabel,
  String? Function(T?)? validator,
}) {
  return Container(
    margin: EdgeInsets.only(bottom: 16),
    child: DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _primaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        prefixIcon: Icon(icon, color: _primaryColor),
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
      ),
      items: items.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(itemLabel(item)),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    ),
  );
}

IconData _getSectionIcon(String title) {
  switch (title) {
    case 'Filing Type':
      return Icons.how_to_reg;
    case 'Personal Details':
      return Icons.person;
    case 'Complaint Details':
      return Icons.report_problem;
    case 'Accused Information':
      return Icons.person_outline;
    case 'Evidence & Attachments':
      return Icons.attach_file;
    case 'Terms & Verification':
      return Icons.verified_user;
    default:
      return Icons.article;
  }
}
