import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../../utils/constants.dart';

class TermsSection extends StatelessWidget {
  final bool agreedToTerms;
  final bool isCaptchaVerified;
  final Function(bool?) onTermsChanged;
  final VoidCallback onShowTerms;
  final VoidCallback onShowPrivacyPolicy;

  const TermsSection({
    super.key,
    required this.agreedToTerms,
    required this.isCaptchaVerified,
    required this.onTermsChanged,
    required this.onShowTerms,
    required this.onShowPrivacyPolicy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.scale(
                scale: 0.9,
                child: Checkbox(
                  value: agreedToTerms,
                  onChanged: onTermsChanged,
                  activeColor: kPrimaryColor,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                      children: [
                        const TextSpan(text: 'I agree to the '),
                        TextSpan(
                          text: 'Terms of Service',
                          style: TextStyle(
                            color: kPrimaryColor,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w500,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = onShowTerms,
                        ),
                        const TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                            color: kPrimaryColor,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w500,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = onShowPrivacyPolicy,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (isCaptchaVerified) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.green[700], size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'CAPTCHA verified',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
