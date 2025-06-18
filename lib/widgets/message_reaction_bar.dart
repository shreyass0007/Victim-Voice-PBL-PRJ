import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MessageReactionBar extends StatefulWidget {
  final Function(bool) onHelpful;
  final bool isUserMessage;

  const MessageReactionBar({
    super.key,
    required this.onHelpful,
    required this.isUserMessage,
  });

  @override
  State<MessageReactionBar> createState() => _MessageReactionBarState();
}

class _MessageReactionBarState extends State<MessageReactionBar> {
  bool? _wasHelpful;

  @override
  Widget build(BuildContext context) {
    if (widget.isUserMessage) return const SizedBox.shrink();

    return AnimatedOpacity(
      opacity: _wasHelpful == null ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Was this helpful?',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 8),
          _buildReactionButton(
            icon: Icons.thumb_up_outlined,
            tooltip: 'Yes, helpful',
            onPressed: () {
              setState(() => _wasHelpful = true);
              widget.onHelpful(true);
            },
          ),
          const SizedBox(width: 4),
          _buildReactionButton(
            icon: Icons.thumb_down_outlined,
            tooltip: 'No, not helpful',
            onPressed: () {
              setState(() => _wasHelpful = false);
              widget.onHelpful(false);
            },
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 500.ms, duration: 300.ms)
        .slideX(begin: 0.2, end: 0);
  }

  Widget _buildReactionButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Tooltip(
          message: tooltip,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(
              icon,
              size: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }
}
