// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/constants.dart';

// Add missing constants if not defined in constants.dart
const kCardBorderRadius = 12.0;

class FormInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool readOnly;
  final Widget? suffixIcon;
  final int maxLines;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;

  const FormInputField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.suffixIcon,
    this.maxLines = 1,
    this.hintText,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                label,
                style: TextStyle(
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          TextFormField(
            controller: controller,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark ? Colors.blue.shade300 : kPrimaryColor,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark ? Colors.red.shade300 : kErrorColor,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark ? Colors.red.shade300 : kErrorColor,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
              prefixIcon: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.blue.shade900.withOpacity(0.2)
                      : kPrimaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: isDark ? Colors.blue.shade300 : kPrimaryColor,
                  size: 20,
                ),
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
            inputFormatters: inputFormatters,
          ),
        ],
      ),
    );
  }
}

class FormSectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Color? backgroundColor;

  const FormSectionCard({
    super.key,
    required this.title,
    required this.children,
    this.backgroundColor,
  });

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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: isDark
            ? Theme.of(context).cardColor
            : backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(kCardBorderRadius),
        border: isDark
            ? Border.all(
                color: Colors.grey.shade800,
                width: 1,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.2)
                : Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        Colors.blue.shade900.withOpacity(0.2),
                        Colors.blue.shade900.withOpacity(0.1),
                      ]
                    : [
                        kPrimaryColor.withOpacity(0.1),
                        kPrimaryColor.withOpacity(0.05),
                      ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(kCardBorderRadius),
                topRight: Radius.circular(kCardBorderRadius),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isDark ? Theme.of(context).cardColor : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: isDark
                        ? Border.all(
                            color: Colors.grey.shade800,
                            width: 1,
                          )
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withOpacity(0.2)
                            : kPrimaryColor.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    _getSectionIcon(title),
                    color: isDark ? Colors.blue.shade300 : kPrimaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : kPrimaryColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? loadingText;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.loadingText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: isDark
                ? Colors.black.withOpacity(0.7)
                : Colors.white.withOpacity(0.7),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isDark ? Colors.blue.shade300 : kPrimaryColor,
                    ),
                  ),
                  if (loadingText != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      loadingText!,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}
