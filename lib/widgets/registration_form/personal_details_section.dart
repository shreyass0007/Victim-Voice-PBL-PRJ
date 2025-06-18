import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'form_widgets.dart';

class PersonalDetailsSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController ageController;
  final TextEditingController emailController;
  final String? selectedGender;
  final Function(String?) onGenderChanged;
  final bool isAnonymous;

  const PersonalDetailsSection({
    super.key,
    required this.nameController,
    required this.ageController,
    required this.emailController,
    required this.selectedGender,
    required this.onGenderChanged,
    required this.isAnonymous,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormInputField(
          controller: nameController,
          label: 'Name',
          icon: Icons.person,
          keyboardType: TextInputType.name,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
          ],
          validator: (value) {
            if (!isAnonymous) {
              if (value!.isEmpty) return 'Please enter your name';
              if (value.trim().isEmpty) return 'Name cannot be only spaces';
            }
            return null;
          },
        ),
        FormInputField(
          controller: ageController,
          label: 'Age',
          icon: Icons.calendar_today,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(3),
          ],
          validator: (value) {
            if (!isAnonymous) {
              if (value!.isEmpty) return 'Please enter your age';
              final age = int.tryParse(value);
              if (age == null) return 'Please enter a valid age';
              if (age < 0 || age > 120) {
                return 'Please enter a valid age between 0-120';
              }
            }
            return null;
          },
        ),
        _buildGenderSelector(),
        FormInputField(
          controller: emailController,
          label: 'Email',
          icon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (!isAnonymous) {
              if (value!.isEmpty) return 'Please enter an email';
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value)) {
                return 'Please enter a valid email';
              }
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Gender:', style: TextStyle(fontWeight: FontWeight.bold)),
        Column(
          children: ['Male', 'Female', 'Other'].map((gender) {
            return RadioListTile<String>(
              title: Text(gender),
              value: gender,
              groupValue: selectedGender,
              onChanged: onGenderChanged,
              fillColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.selected)) {
                    return Colors.blue; // Color when selected
                  }
                  return Colors.grey; // Default unselected color
                },
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
