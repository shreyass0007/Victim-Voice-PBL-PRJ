import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class InteractiveInfoCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color primaryColor;
  final List<String>? bulletPoints;
  final VoidCallback? onTap;
  final bool isImportant;

  const InteractiveInfoCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.primaryColor,
    this.bulletPoints,
    this.onTap,
    this.isImportant = false,
  });

  @override
  State<InteractiveInfoCard> createState() => _InteractiveInfoCardState();
}

class _InteractiveInfoCardState extends State<InteractiveInfoCard> {
  bool _isExpanded = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          setState(() => _isExpanded = !_isExpanded);
          widget.onTap?.call();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: widget.primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.primaryColor.withOpacity(_isHovered ? 0.3 : 0.1),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.primaryColor.withOpacity(_isHovered ? 0.1 : 0.05),
                blurRadius: _isHovered ? 8 : 4,
                offset: Offset(0, _isHovered ? 4 : 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: widget.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        widget.icon,
                        color: widget.primaryColor,
                        size: 24,
                      ),
                    )
                        .animate(target: _isHovered ? 1 : 0)
                        .scale(
                            begin: const Offset(1, 1),
                            end: const Offset(1.1, 1.1))
                        .shake(hz: 2, curve: Curves.easeInOut),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.title,
                                style: TextStyle(
                                  color: widget.primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (widget.isImportant)
                                Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Important',
                                    style: TextStyle(
                                      color: Colors.red.shade700,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                )
                                    .animate(
                                        onPlay: (controller) =>
                                            controller.repeat())
                                    .fadeIn(duration: 500.ms)
                                    .then()
                                    .fadeOut(duration: 500.ms),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.description,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: widget.primaryColor,
                    )
                        .animate(target: _isExpanded ? 1 : 0)
                        .rotate(begin: 0, end: 0.5),
                  ],
                ),
              ),
              if (_isExpanded && widget.bulletPoints != null)
                Container(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.bulletPoints!.map((point) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: widget.primaryColor,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                point,
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ).animate().fadeIn(duration: 200.ms).slideY(begin: 0.2, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}
