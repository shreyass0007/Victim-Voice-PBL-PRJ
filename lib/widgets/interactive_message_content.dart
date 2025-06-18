import 'package:flutter/material.dart';

class InteractiveMessageContent extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final Color textColor;
  final bool showShareButton;
  final VoidCallback? onTapMessage;

  const InteractiveMessageContent({
    super.key,
    required this.message,
    required this.backgroundColor,
    required this.textColor,
    this.showShareButton = true,
    this.onTapMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onTapMessage,
            child: Text(
              message,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
