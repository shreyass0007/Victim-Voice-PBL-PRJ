import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PhoneNumberButton extends StatelessWidget {
  final String label;
  final String phoneNumber;

  const PhoneNumberButton({
    super.key,
    required this.label,
    required this.phoneNumber,
  });

  Future<void> _makePhoneCall() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      debugPrint('Could not launch $phoneUri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Icon(
                Icons.local_phone_rounded,
                color: Colors.green.shade600,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      phoneNumber,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: _makePhoneCall,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade50,
                  foregroundColor: Colors.green.shade700,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.green.shade200),
                  ),
                ),
                icon: const Icon(Icons.call),
                label: const Text('Call Now'),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideX(begin: 0.1, end: 0, duration: 400.ms);
  }
}
