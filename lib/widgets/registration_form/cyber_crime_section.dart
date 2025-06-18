import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/constants.dart';
import 'form_widgets.dart';

class CyberCrimeSection extends StatefulWidget {
  final TextEditingController urlController;
  final TextEditingController deviceInfoController;
  final TextEditingController digitalEvidenceController;
  final TextEditingController financialLossController;
  final TextEditingController ipAddressController;
  final TextEditingController suspiciousActivityController;
  final String? selectedCyberCrimeType;
  final List<String> selectedPlatforms;
  final List<String> selectedImpacts;
  final bool hasScreenshots;
  final bool dataBackupAvailable;
  final bool accountsSecured;
  final bool evidencePreserved;
  final DateTime? incidentStartDate;
  final DateTime? incidentEndDate;
  final Function(String?) onCyberCrimeTypeChanged;
  final Function(bool) onScreenshotsChanged;
  final Function(bool) onDataBackupChanged;
  final Function(bool) onAccountsSecuredChanged;
  final Function(bool) onEvidencePreservedChanged;
  final Function(DateTime?) onStartDateChanged;
  final Function(DateTime?) onEndDateChanged;
  final Function(String, bool) onPlatformToggled;
  final Function(String, bool) onImpactToggled;

  const CyberCrimeSection({
    super.key,
    required this.urlController,
    required this.deviceInfoController,
    required this.digitalEvidenceController,
    required this.financialLossController,
    required this.ipAddressController,
    required this.suspiciousActivityController,
    required this.selectedCyberCrimeType,
    required this.selectedPlatforms,
    required this.selectedImpacts,
    required this.hasScreenshots,
    required this.dataBackupAvailable,
    required this.accountsSecured,
    required this.evidencePreserved,
    required this.incidentStartDate,
    required this.incidentEndDate,
    required this.onCyberCrimeTypeChanged,
    required this.onScreenshotsChanged,
    required this.onDataBackupChanged,
    required this.onAccountsSecuredChanged,
    required this.onEvidencePreservedChanged,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.onPlatformToggled,
    required this.onImpactToggled,
  });

  @override
  State<CyberCrimeSection> createState() => _CyberCrimeSectionState();
}

class _CyberCrimeSectionState extends State<CyberCrimeSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCyberCrimeTypeDropdown(),
        const SizedBox(height: 16),
        _buildPlatformsSection(),
        const SizedBox(height: 16),
        _buildDigitalEvidenceSection(),
        const SizedBox(height: 16),
        _buildImpactAssessmentSection(),
        const SizedBox(height: 16),
        _buildEvidencePreservationSection(),
        const SizedBox(height: 16),
        _buildCyberSecurityAuthoritySection(),
      ],
    );
  }

  Widget _buildCyberCrimeTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: widget.selectedCyberCrimeType,
      decoration: InputDecoration(
        labelText: 'Type of Cyber Crime',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: kCyberCrimeTypes.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(type),
        );
      }).toList(),
      onChanged: widget.onCyberCrimeTypeChanged,
      validator: (value) {
        if (value == null) {
          return 'Please select the type of cyber crime';
        }
        return null;
      },
    );
  }

  Widget _buildPlatformsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Platforms Involved',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Wrap(
          spacing: 8,
          children: kPlatforms.map((platform) {
            return FilterChip(
              label: Text(platform),
              selected: widget.selectedPlatforms.contains(platform),
              onSelected: (selected) =>
                  widget.onPlatformToggled(platform, selected),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDigitalEvidenceSection() {
    return FormSectionCard(
      title: 'Digital Evidence',
      children: [
        FormInputField(
          controller: widget.urlController,
          label: 'URLs/Links Related to Incident',
          icon: Icons.link,
          maxLines: 3,
          hintText: 'Enter relevant URLs, one per line',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter at least one URL';
            }
            final urls =
                value.split('\n').where((url) => url.trim().isNotEmpty);
            for (final url in urls) {
              final uri = Uri.tryParse(url.trim());
              if (uri == null || !uri.hasScheme) {
                return 'Please enter valid URLs (e.g., https://example.com)';
              }
            }
            return null;
          },
        ),
        FormInputField(
          controller: widget.deviceInfoController,
          label: 'Device Information',
          icon: Icons.devices,
          hintText: 'Device type, OS version, browser used, etc.',
        ),
        FormInputField(
          controller: widget.digitalEvidenceController,
          label: 'Digital Evidence Description',
          icon: Icons.description,
          maxLines: 3,
          hintText: 'Describe any digital evidence you have',
        ),
        _buildDateSelectionRow(),
      ],
    );
  }

  Widget _buildDateSelectionRow() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextButton.icon(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: widget.incidentStartDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    // If end date exists and is before new start date, clear it
                    if (widget.incidentEndDate != null &&
                        widget.incidentEndDate!.isBefore(picked)) {
                      widget.onEndDateChanged(null);
                    }
                    widget.onStartDateChanged(picked);
                  }
                },
                icon: const Icon(
                  Icons.calendar_today,
                  color: Colors.blue,
                ),
                label: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.incidentStartDate == null
                        ? 'Start Date'
                        : 'Start: ${widget.incidentStartDate!.toLocal().toString().split(' ')[0]}',
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextButton.icon(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: widget.incidentEndDate ?? DateTime.now(),
                    firstDate: widget.incidentStartDate ?? DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  widget.onEndDateChanged(picked);
                },
                icon: const Icon(
                  Icons.calendar_today,
                  color: Colors.blue,
                ),
                label: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.incidentEndDate == null
                        ? 'End Date'
                        : 'End: ${widget.incidentEndDate!.toLocal().toString().split(' ')[0]}',
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImpactAssessmentSection() {
    return FormSectionCard(
      title: 'Impact Assessment',
      children: [
        const Text(
          'Select all applicable impacts:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: kImpactTypes.map((impact) {
            return FilterChip(
              label: Text(impact),
              selected: widget.selectedImpacts.contains(impact),
              onSelected: (selected) =>
                  widget.onImpactToggled(impact, selected),
              backgroundColor: Colors.grey.shade100,
              selectedColor: Colors.red.shade100,
              labelStyle: TextStyle(
                color: widget.selectedImpacts.contains(impact)
                    ? Colors.red.shade700
                    : Colors.black87,
              ),
            );
          }).toList(),
        ),
        if (widget.selectedImpacts.contains('Financial Loss')) ...[
          const SizedBox(height: 16),
          FormInputField(
            controller: widget.financialLossController,
            label: 'Estimated Financial Loss (in INR)',
            icon: Icons.currency_rupee,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the estimated financial loss';
              }
              final number = double.tryParse(value);
              if (number == null) {
                return 'Please enter a valid number';
              }
              if (number < 0) {
                return 'Financial loss cannot be negative';
              }
              return null;
            },
          ),
        ],
      ],
    );
  }

  Widget _buildEvidencePreservationSection() {
    return FormSectionCard(
      title: 'Evidence Preservation Checklist',
      children: [
        const Text(
          'Important: Please take these steps to preserve evidence',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: kErrorColor,
          ),
        ),
        const SizedBox(height: 8),
        CheckboxListTile(
          activeColor: Colors.blue,
          title:
              const Text('I have taken screenshots/recordings of the incident'),
          subtitle: const Text(
              'Include timestamps and full webpage/screen if possible'),
          value: widget.hasScreenshots,
          onChanged: (value) => widget.onScreenshotsChanged(value ?? false),
        ),
        CheckboxListTile(
          activeColor: Colors.blue,
          title: const Text('I have backed up all relevant data'),
          subtitle:
              const Text('Emails, messages, files related to the incident'),
          value: widget.dataBackupAvailable,
          onChanged: (value) => widget.onDataBackupChanged(value ?? false),
        ),
        CheckboxListTile(
          activeColor: Colors.blue,
          title: const Text('I have secured my accounts'),
          subtitle: const Text('Changed passwords, enabled 2FA where possible'),
          value: widget.accountsSecured,
          onChanged: (value) => widget.onAccountsSecuredChanged(value ?? false),
        ),
        CheckboxListTile(
          activeColor: Colors.blue,
          title: const Text('I have preserved original evidence'),
          subtitle: const Text(
              'Not deleted any messages/emails/files related to incident'),
          value: widget.evidencePreserved,
          onChanged: (value) =>
              widget.onEvidencePreservedChanged(value ?? false),
        ),
      ],
    );
  }

  Widget _buildCyberSecurityAuthoritySection() {
    return FormSectionCard(
      title: 'Cybersecurity Authority Reporting',
      children: [
        const Text(
          'Report to Cybersecurity Authorities',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.security),
          title: const Text('National Cyber Crime Reporting Portal'),
          subtitle: const Text('cybercrime.gov.in'),
          trailing: const Icon(Icons.open_in_new),
          onTap: () => launchUrl(Uri.parse('https://cybercrime.gov.in')),
        ),
        ListTile(
          leading: const Icon(Icons.phone),
          title: const Text('Cyber Crime Helpline'),
          subtitle: const Text('1930'),
          trailing: const Icon(Icons.call),
          onTap: () => launchUrl(Uri.parse('tel:1930')),
        ),
        const SizedBox(height: 8),
        Text(
          'Note: For immediate assistance or if you\'re currently under cyber attack, call 1930 immediately.',
          style: TextStyle(
            color: Colors.red.shade700,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
