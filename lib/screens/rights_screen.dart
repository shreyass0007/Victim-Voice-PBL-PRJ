import 'package:flutter/material.dart';

class RightsScreen extends StatelessWidget {
  const RightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Know Your Rights',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      Colors.blue.shade900,
                      Colors.blue.shade800,
                    ]
                  : [
                      const Color(0xFF2196F3),
                      const Color(0xFF64B5F6),
                    ],
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    Theme.of(context).primaryColor.withOpacity(0.2),
                    Theme.of(context).scaffoldBackgroundColor,
                  ]
                : [
                    Colors.white,
                    const Color(0xFFF5F5F5),
                  ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: const [
            RightCard(
              title: 'Right to File FIR',
              description:
                  'You have the right to file an FIR at any police station, regardless of jurisdiction.',
              icon: Icons.gavel,
            ),
            RightCard(
              title: 'Right to Legal Aid',
              description:
                  'You have the right to free legal assistance and representation.',
              icon: Icons.balance,
            ),
            RightCard(
              title: 'Right to Medical Treatment',
              description:
                  'Hospitals must provide immediate medical assistance to victims.',
              icon: Icons.local_hospital,
            ),
            RightCard(
              title: 'Right to Privacy',
              description:
                  'Your identity and personal information will be protected throughout the process.',
              icon: Icons.security,
            ),
          ],
        ),
      ),
    );
  }
}

class RightCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;

  const RightCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  State<RightCard> createState() => _RightCardState();
}

class _RightCardState extends State<RightCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Card(
            elevation: isDark ? 2 : 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          Theme.of(context).cardColor,
                          Theme.of(context).cardColor.withOpacity(0.8),
                        ]
                      : [
                          Colors.white,
                          const Color(0xFFF8F8F8),
                        ],
                ),
                border: isDark ? Border.all(color: Colors.grey.shade800) : null,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.blue.withOpacity(0.15)
                            : Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        widget.icon,
                        size: 28,
                        color: isDark ? Colors.blue.shade300 : Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF2C3E50),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.description,
                            style: TextStyle(
                              fontSize: 16,
                              color: isDark
                                  ? Colors.grey.shade400
                                  : const Color(0xFF7F8C8D),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
