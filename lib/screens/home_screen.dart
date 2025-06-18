import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/drawer.dart';
import '../widgets/emergency_button.dart';
import 'chatbot_screen.dart';
import 'emergency_contacts_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isChatOpen = false;

  // Theme colors

  void _showEmergencyOptions(BuildContext context) async {
    String? selectedOption = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Emergency Services',
            style: GoogleFonts.lato(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select the service you need:',
                  style: GoogleFonts.lato(fontSize: 16),
                ),
                const SizedBox(height: 16),
                _buildEmergencyTile(
                  context: context,
                  icon: Icons.local_police,
                  title: 'Police',
                  subtitle: 'For immediate police assistance',
                  number: '100',
                  color: Colors.blue,
                ),
                const SizedBox(height: 8),
                _buildEmergencyTile(
                  context: context,
                  icon: Icons.local_hospital,
                  title: 'Ambulance',
                  subtitle: 'For medical emergencies',
                  number: '108',
                  color: Colors.red,
                ),
                const SizedBox(height: 8),
                _buildEmergencyTile(
                  context: context,
                  icon: Icons.woman,
                  title: 'Women Helpline',
                  subtitle: '24/7 women safety helpline',
                  number: '1091',
                  color: Colors.blue,
                ),
                const SizedBox(height: 8),
                _buildEmergencyTile(
                  context: context,
                  icon: Icons.child_care,
                  title: 'Child Helpline',
                  subtitle: 'For child protection services',
                  number: '1098',
                  color: Colors.green,
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EmergencyContactsScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.contacts),
                  label: const Text('Manage Emergency Contacts'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    side: const BorderSide(color: Colors.blue),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selectedOption != null) {
      _confirmCall(context, selectedOption);
    }
  }

  Widget _buildEmergencyTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required String number,
    required Color color,
  }) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        leading: Icon(icon, color: color, size: 28),
        title: Text(
          title,
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(subtitle),
        tileColor: color.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onTap: () => Navigator.of(context).pop(number),
      ),
    );
  }

  void _confirmCall(BuildContext context, String phoneNumber) async {
    bool? confirmCall = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirm Emergency Call',
            style: GoogleFonts.lato(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'Are you sure you want to call emergency number $phoneNumber?',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(fontSize: 16),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Only proceed if you have a genuine emergency.',
                  style: GoogleFonts.lato(
                    fontSize: 13,
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: GoogleFonts.lato(color: Colors.grey),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              icon: Icon(Icons.phone, color: Colors.white),
              label: Text(
                'Call Now',
                style: GoogleFonts.lato(color: Colors.white),
              ),
            ),
          ],
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        );
      },
    );

    if (confirmCall == true) {
      _makeCall(phoneNumber);
    }
  }

  void _makeCall(String phoneNumber) async {
    final Uri callUri = Uri.parse('tel:$phoneNumber');
    try {
      if (await canLaunchUrl(callUri)) {
        await launchUrl(callUri);
      } else {
        throw 'Could not launch call to $phoneNumber';
      }
    } catch (e) {
      debugPrint("Error making call: $e");
      // Show error dialog to user
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Could not make call: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleChat() {
    setState(() => _isChatOpen = !_isChatOpen);
    if (_isChatOpen) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }

    if (_isChatOpen) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: BoxDecoration(
              color: isDark
                  ? Theme.of(context).dialogBackgroundColor
                  : Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              border: isDark
                  ? Border.all(
                      color: Colors.grey.shade800,
                      width: 1,
                    )
                  : null,
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.3)
                      : Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  height: 4,
                  width: 40,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: const ChatbotScreen(),
                  ),
                ),
              ],
            ),
          );
        },
      ).then((_) {
        setState(() => _isChatOpen = false);
        _animationController.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Victim Voice',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDark
            ? Theme.of(context).appBarTheme.backgroundColor
            : const Color.fromARGB(255, 179, 212, 255),
        elevation: isDark ? 0 : 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black87),
        actions: [
          IconButton(
            icon: Icon(Icons.emergency,
                color: isDark ? Colors.red.shade300 : Colors.red),
            onPressed: () => _showEmergencyOptions(context),
          ),
          IconButton(
            icon: Icon(Icons.contacts_outlined,
                color: isDark ? Colors.white : Colors.black87),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EmergencyContactsScreen(),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
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
                        const Color.fromARGB(255, 179, 212, 255),
                        Colors.white,
                      ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildWelcomeCard(),
                    const SizedBox(height: 25),
                    _buildQuickActions(context),
                    const SizedBox(height: 25),
                    _buildEmergencySection(),
                    const SizedBox(height: 25),
                    _buildFeaturesList(context),
                  ],
                ),
              ),
            ),
          ),
          // Emergency Button
          Positioned(
            right: 16,
            bottom: 88,
            child: const EmergencyButton(),
          ),
          // Chat Support Button
          Positioned(
            right: 16,
            bottom: 16,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withOpacity(0.3)
                        : Theme.of(context).primaryColor.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: RotationTransition(
                turns:
                    Tween(begin: 0.0, end: 0.125).animate(_animationController),
                child: FloatingActionButton(
                  onPressed: _toggleChat,
                  backgroundColor:
                      isDark ? Colors.blue.withOpacity(0.8) : Colors.blue,
                  elevation: isDark ? 2 : 0,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _isChatOpen
                        ? Icon(
                            Icons.close,
                            key: const ValueKey('close_icon'),
                            color: isDark
                                ? Colors.white.withOpacity(0.9)
                                : Colors.white,
                          )
                        : Icon(
                            Icons.chat_bubble_outline,
                            key: const ValueKey('chat_icon'),
                            color: isDark
                                ? Colors.white.withOpacity(0.9)
                                : Colors.white,
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      elevation: isDark ? 2 : 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    Colors.blue.shade900,
                    Theme.of(context).cardColor,
                  ]
                : [
                    Colors.blue.shade100,
                    Colors.white,
                  ],
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.security,
              size: 48,
              color: isDark ? Colors.blue.shade300 : Colors.blue,
            ).animate().scale(delay: 200.ms).fade(),
            const SizedBox(height: 16),
            Text(
              'Welcome to Victim Voice',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ).animate().fadeIn(delay: 300.ms).slideY(),
            const SizedBox(height: 12),
            Text(
              'Your safety is our priority. Report incidents or contact emergency services immediately.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black54,
                height: 1.4,
              ),
            ).animate().fadeIn(delay: 400.ms),
          ],
        ),
      ),
    ).animate().scale(delay: 100.ms).fade();
  }

  Widget _buildQuickActions(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ).animate().fadeIn().slideX(),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/complaintForm');
                },
                icon: Icons.report_problem,
                label: 'File a\nComplaint',
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionButton(
                onPressed: () => _showEmergencyOptions(context),
                icon: Icons.emergency,
                label: 'Emergency\nServices',
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isDark ? color.withOpacity(0.15) : color.withOpacity(0.1),
            border: Border.all(
              color: isDark ? color.withOpacity(0.3) : color.withOpacity(0.3),
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? Colors.white : color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().scale(delay: 100.ms).fade();
  }

  Widget _buildEmergencySection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  'Emergency Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'In case of emergency, use the Emergency Services button above or dial your local emergency number. Help is available 24/7.',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white : Colors.black87,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 500.ms).slideY();
  }

  Widget _buildFeaturesList(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final features = [
      {
        'title': 'Report Cyber Crime',
        'description': 'Report online harassment, fraud, or other cyber crimes',
        'icon': Icons.security,
        'color': Colors.blue,
        'route': '/cyberCrime'
      },
      {
        'title': 'File a Complaint',
        'description': 'Register your complaint with relevant authorities',
        'icon': Icons.description,
        'color': Colors.blue,
        'route': '/complaintForm'
      },
      {
        'title': 'Know Your Rights',
        'description': 'Learn about your legal rights and protections',
        'icon': Icons.gavel,
        'color': Colors.blue,
        'route': '/rights'
      },
      {
        'title': 'Support Services',
        'description': 'Access counseling and support services',
        'icon': Icons.support_agent,
        'color': Colors.blue,
        'route': '/support'
      },
      {
        'title': 'Safety Tips',
        'description': 'Learn how to stay safe and protect yourself',
        'icon': Icons.health_and_safety,
        'color': Colors.blue,
        'route': '/safety'
      },
      {
        'title': 'Chat Support',
        'description': 'Talk to our AI assistant for immediate guidance',
        'icon': Icons.chat,
        'color': Colors.blue,
        'route': '/chatbot'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Services & Resources',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ).animate().fadeIn().slideX(),
        ...features.map((feature) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () =>
                      Navigator.pushNamed(context, feature['route'] as String),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Theme.of(context).cardTheme.color
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: isDark
                          ? Border.all(color: Colors.grey.shade800)
                          : null,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: (feature['color'] as Color)
                                .withOpacity(isDark ? 0.15 : 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            feature['icon'] as IconData,
                            color: feature['color'] as Color,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                feature['title'] as String,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                feature['description'] as String,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDark
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
