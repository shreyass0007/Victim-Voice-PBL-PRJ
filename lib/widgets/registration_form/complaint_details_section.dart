import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import 'form_widgets.dart';

class ComplaintDetailsSection extends StatelessWidget {
  final String? selectedComplaintType;
  final String? crimeType;
  final String? selectedUrgency;
  final TextEditingController dateController;
  final TextEditingController locationController;
  final TextEditingController descController;
  final Function(String?) onComplaintTypeChanged;
  final Function(String?) onCrimeTypeChanged;
  final Function(String?) onUrgencyChanged;
  final VoidCallback onLocationPressed;
  final VoidCallback onDatePressed;

  const ComplaintDetailsSection({
    super.key,
    required this.selectedComplaintType,
    required this.crimeType,
    required this.selectedUrgency,
    required this.dateController,
    required this.locationController,
    required this.descController,
    required this.onComplaintTypeChanged,
    required this.onCrimeTypeChanged,
    required this.onUrgencyChanged,
    required this.onLocationPressed,
    required this.onDatePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildComplaintTypeDropdown(),
        const SizedBox(height: 16),
        if (selectedComplaintType != 'Cyber Crime') ...[
          _buildCrimeTypeSelector(),
          _buildUrgencySelector(),
          const SizedBox(height: 16),
        ],
        _buildDateAndLocationFields(),
        _buildDescriptionField(),
      ],
    );
  }

  Widget _buildComplaintTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedComplaintType,
      decoration: InputDecoration(
        labelText: 'Type of Complaint',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: [...kComplaintTypes, 'Cyber Crime'].map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(type),
        );
      }).toList(),
      onChanged: onComplaintTypeChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select complaint type';
        }
        return null;
      },
    );
  }

  Widget _buildCrimeTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Crime Type',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Online'),
                value: 'Online',
                groupValue: crimeType,
                onChanged: onCrimeTypeChanged,
                fillColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.selected)) {
                      return Colors.blue; // Color when selected
                    }
                    return Colors.grey; // Default unselected color
                  },
                ),
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Offline'),
                value: 'Offline',
                groupValue: crimeType,
                onChanged: onCrimeTypeChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUrgencySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Urgency Level',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: kUrgencyLevels.map((urgency) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ElevatedButton(
                  onPressed: () => onUrgencyChanged(urgency['level']),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedUrgency == urgency['level']
                        ? urgency['color']
                        : Colors.grey[300],
                    foregroundColor: selectedUrgency == urgency['level']
                        ? Colors.white
                        : Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
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

  Widget _buildDateAndLocationFields() {
    return Column(
      children: [
        FormInputField(
          controller: dateController,
          label: 'Date of Incident',
          icon: Icons.event,
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: onDatePressed,
          ),
          validator: (value) => value!.isEmpty ? 'Please select a date' : null,
        ),
        FormInputField(
          controller: locationController,
          label: 'Location of Incident',
          icon: Icons.location_on,
          suffixIcon: IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: onLocationPressed,
          ),
          validator: (value) => value!.isEmpty ? 'Please enter location' : null,
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return FormInputField(
      controller: descController,
      label: 'Complaint Description',
      icon: Icons.description,
      maxLines: 5,
      validator: (value) =>
          value!.isEmpty ? 'Please enter your description' : null,
    );
  }
}
