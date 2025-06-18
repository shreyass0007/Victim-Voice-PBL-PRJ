import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatMessageWidget extends StatelessWidget {
  final String message;
  final bool isUser;
  final bool isError;
  final DateTime timestamp;

  const ChatMessageWidget({
    super.key,
    required this.message,
    required this.isUser,
    required this.timestamp,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) _buildAvatar(),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: _getBubbleColor(context),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    message,
                    style: TextStyle(
                      color: _getTextColor(),
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    _formatTimestamp(),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (isUser) _buildAvatar(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      backgroundColor: isUser ? Colors.blue[100] : Colors.grey[200],
      child: Icon(
        isUser ? Icons.person : Icons.support_agent,
        color: isUser ? Colors.blue : Colors.grey[700],
      ),
    );
  }

  Color _getBubbleColor(BuildContext context) {
    if (isError) return Colors.red[100]!;
    return isUser ? Colors.blue[100]! : Colors.grey[200]!;
  }

  Color _getTextColor() {
    if (isError) return Colors.red[900]!;
    return Colors.black87;
  }

  String _formatTimestamp() {
    return DateFormat('HH:mm').format(timestamp);
  }
}
