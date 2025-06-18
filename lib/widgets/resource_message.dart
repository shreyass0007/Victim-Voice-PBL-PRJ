import 'package:flutter/material.dart';
import 'phone_number_button.dart';

class ResourceMessage extends StatelessWidget {
  final String message;

  const ResourceMessage({
    super.key,
    required this.message,
  });

  List<Widget> _buildPhoneButtons() {
    final List<Widget> widgets = [];
    final lines = message.split('\n');

    for (var line in lines) {
      if (line.contains(':')) {
        final parts = line.split(':');
        if (parts.length == 2) {
          final label = parts[0].replaceAll('-', '').trim();
          final number = parts[1].trim();
          if (number.contains(RegExp(r'\d'))) {
            widgets.add(PhoneNumberButton(
              label: label,
              phoneNumber: number,
            ));
          } else {
            widgets.add(Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(line.trim()),
            ));
          }
        }
      } else if (line.isNotEmpty) {
        widgets.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            line.trim(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ));
      }
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildPhoneButtons(),
      ),
    );
  }
}
