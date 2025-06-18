import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

class ExpandableMessageContent extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final Color textColor;
  final List<ActionButton>? actionButtons;
  final List<String>? links;

  const ExpandableMessageContent({
    super.key,
    required this.message,
    required this.backgroundColor,
    required this.textColor,
    this.actionButtons,
    this.links,
  });

  @override
  State<ExpandableMessageContent> createState() =>
      _ExpandableMessageContentState();
}

class ActionButton {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const ActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });
}

class _ExpandableMessageContentState extends State<ExpandableMessageContent> {
  bool _isExpanded = false;
  bool _showExpandButton = false;
  final GlobalKey _textKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkTextSize();
    });
  }

  void _checkTextSize() {
    final RenderBox? textBox =
        _textKey.currentContext?.findRenderObject() as RenderBox?;
    if (textBox != null) {
      final textHeight = textBox.size.height;
      setState(() {
        _showExpandButton = textHeight > 100;
      });
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Widget _buildActionButton(ActionButton action) {
    return Container(
      margin: const EdgeInsets.only(right: 8, top: 8),
      child: ElevatedButton.icon(
        onPressed: action.onPressed,
        icon: Icon(action.icon, size: 20),
        label: Text(action.label),
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.backgroundColor.withOpacity(0.8),
          foregroundColor: widget.textColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: widget.textColor.withOpacity(0.2)),
          ),
        ),
      )
          .animate(target: 1)
          .shimmer(duration: 1000.ms, delay: 500.ms)
          .shake(hz: 2, curve: Curves.easeInOut),
    );
  }

  Widget _buildLink(String link) {
    return InkWell(
      onTap: () => _launchURL(link),
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(Icons.link,
                size: 16, color: widget.textColor.withOpacity(0.7)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                link,
                style: TextStyle(
                  color: widget.textColor.withOpacity(0.7),
                  decoration: TextDecoration.underline,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.2, end: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          key: _textKey,
          child: Text(
            widget.message,
            style: TextStyle(
              color: widget.textColor,
              fontSize: 16,
              height: 1.4,
            ),
            maxLines: _isExpanded ? null : 5,
            overflow: _isExpanded ? null : TextOverflow.fade,
          ),
        ),
        if (_showExpandButton)
          TextButton(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isExpanded ? 'Show less' : 'Read more',
                  style: TextStyle(
                    color: widget.textColor.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 16,
                  color: widget.textColor.withOpacity(0.7),
                ),
              ],
            ),
          )
              .animate(target: _isExpanded ? 1 : 0)
              .scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05))
              .then()
              .scale(begin: const Offset(1.05, 1.05), end: const Offset(1, 1)),
        if (widget.actionButtons != null)
          Wrap(
            children: widget.actionButtons!.map(_buildActionButton).toList(),
          ),
        if (widget.links != null) ...widget.links!.map(_buildLink),
      ],
    );
  }
}
