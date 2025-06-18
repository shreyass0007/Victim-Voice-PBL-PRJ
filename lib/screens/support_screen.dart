import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Support Services',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white : Colors.black87,
            fontSize: 24,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF121212) : Colors.grey[100],
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          children: [
            WelcomeCard(isDarkMode: isDarkMode),
            const SizedBox(height: 24),
            SupportServiceCard(
              title: 'Counseling Services',
              contact: '+91 1234567890',
              description:
                  '24/7 professional counseling support available for your mental well-being',
              icon: Icons.psychology,
              color: const Color(0xFF2196F3),
              gradientColors: const [Color(0xFF1976D2), Color(0xFF2196F3)],
              isDarkMode: isDarkMode,
            ),
            SupportServiceCard(
              title: 'Legal Aid Center',
              contact: '+91 9876543210',
              description:
                  'Expert legal consultation and support for your rights and protection',
              icon: Icons.gavel,
              color: const Color(0xFF1976D2),
              gradientColors: const [Color(0xFF1565C0), Color(0xFF1976D2)],
              isDarkMode: isDarkMode,
            ),
            SupportServiceCard(
              title: 'Women\'s Helpline',
              contact: '1091',
              description:
                  'Immediate assistance and support for women in distress, available 24/7',
              icon: Icons.emergency,
              color: const Color(0xFF42A5F5),
              gradientColors: const [Color(0xFF1976D2), Color(0xFF42A5F5)],
              isDarkMode: isDarkMode,
            ),
            SupportServiceCard(
              title: 'NGO Support',
              contact: '+91 8765432109',
              description:
                  'Dedicated NGO services providing comprehensive victim support and guidance',
              icon: Icons.people,
              color: const Color(0xFF1E88E5),
              gradientColors: const [Color(0xFF1565C0), Color(0xFF1E88E5)],
              isDarkMode: isDarkMode,
            ),
          ],
        ),
      ),
    );
  }
}

class WelcomeCard extends StatelessWidget {
  final bool isDarkMode;

  const WelcomeCard({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [const Color(0xFF1E1E1E), const Color(0xFF2C2C2C)]
              : [Colors.white, Colors.grey[50]!],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.4 : 0.1),
            blurRadius: 15,
            spreadRadius: 5,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to Support Services',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black87,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'We are here to help you. Choose from our available support services below.',
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black54,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class SupportServiceCard extends StatefulWidget {
  final String title;
  final String contact;
  final String description;
  final IconData icon;
  final Color color;
  final List<Color> gradientColors;
  final bool isDarkMode;

  const SupportServiceCard({
    super.key,
    required this.title,
    required this.contact,
    required this.description,
    required this.icon,
    required this.color,
    required this.gradientColors,
    required this.isDarkMode,
  });

  @override
  State<SupportServiceCard> createState() => _SupportServiceCardState();
}

class _SupportServiceCardState extends State<SupportServiceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _makePhoneCall() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: widget.contact);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()
            ..translate(0.0, _isHovered ? -5.0 : 0.0)
            ..rotateZ(_isHovered ? 0.005 : 0.0),
          child: GestureDetector(
            onTapDown: (_) => _controller.forward(),
            onTapUp: (_) => _controller.reverse(),
            onTapCancel: () => _controller.reverse(),
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Card(
                elevation: _isHovered ? 8 : 4,
                color:
                    widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: widget.isDarkMode
                          ? [const Color(0xFF1E1E1E), const Color(0xFF2C2C2C)]
                          : [Colors.white, Colors.grey[50]!],
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: widget.gradientColors,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: widget.color.withOpacity(0.4),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                widget.icon,
                                size: 32,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.title,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: widget.isDarkMode
                                          ? Colors.white
                                          : Colors.black87,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    widget.description,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: widget.isDarkMode
                                          ? Colors.white.withOpacity(0.8)
                                          : Colors.black54,
                                      height: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  InkWell(
                                    onTap: _makePhoneCall,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: widget.gradientColors,
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                widget.color.withOpacity(0.4),
                                            blurRadius: 8,
                                            spreadRadius: 1,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.phone,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            widget.contact,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
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
      ),
    );
  }
}
