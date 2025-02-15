import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:your_project/widgets/drawer.dart'; // Update this to the correct path of an existing file

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showEmergencyOptions(BuildContext context) async {
    String? selectedOption = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Emergency Services',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select the service you need:',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                _buildEmergencyTile(
                  context: context,
                  icon: Icons.local_police,
                  title: 'Police',
                  subtitle: 'For immediate police assistance',
                  number: '+919022159520',
                  color: Colors.blue,
                ),
                const SizedBox(height: 8),
                _buildEmergencyTile(
                  context: context,
                  icon: Icons.local_hospital,
                  title: 'Ambulance',
                  subtitle: 'For medical emergencies',
                  number: '+919022159520',
                  color: Colors.red,
                ),
                const SizedBox(height: 8),
                _buildEmergencyTile(
                  context: context,
                  icon: Icons.woman,
                  title: 'Women Helpline',
                  subtitle: '24/7 women safety helpline',
                  number: '+919022159520',
                  color: Colors.purple,
                ),
                const SizedBox(height: 8),
                _buildEmergencyTile(
                  context: context,
                  icon: Icons.child_care,
                  title: 'Child Helpline',
                  subtitle: 'For child protection services',
                  number: '+91902215952',
                  color: Colors.green,
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
          style: const TextStyle(
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
          title: const Text(
            'Confirm Emergency Call',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'Are you sure you want to call emergency number $phoneNumber?',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Only proceed if you have a genuine emergency.',
                  style: TextStyle(
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
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
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
              icon: const Icon(Icons.phone, color: Colors.white),
              label:
                  const Text('Call Now', style: TextStyle(color: Colors.white)),
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
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      print("Could not launch call to $phoneNumber");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Victim Voice',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 179, 212, 255),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
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
                _buildQuickActions(),
                const SizedBox(height: 25),
                _buildEmergencySection(),
                const SizedBox(height: 25),
                _buildResourcesSection(),
              ],
            ),
          ),
        ),
      ),
      drawer: MyDrawer(),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 4,
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
            colors: [
              Colors.blue.shade100,
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.security,
              size: 48,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            const Text(
              'Welcome to Victim Voice',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Your safety is our priority. Report incidents or contact emergency services immediately.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Builder(
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
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
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            border: Border.all(color: color.withOpacity(0.3)),
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
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencySection() {
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
            const Text(
              'In case of emergency, use the Emergency Services button above or dial your local emergency number. Help is available 24/7.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourcesSection() {
    return Builder(
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              'Helpful Resources',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          _buildResourceCard(
            icon: Icons.gavel,
            title: 'Know Your Rights',
            description: 'Learn about your legal rights and protections',
            onTap: () {
              Navigator.pushNamed(context, '/rights');
            },
          ),
          const SizedBox(height: 12),
          _buildResourceCard(
            icon: Icons.support_agent,
            title: 'Support Services',
            description: 'Find counseling and support services near you',
            onTap: () {
              Navigator.pushNamed(context, '/support');
            },
          ),
          const SizedBox(height: 12),
          _buildResourceCard(
            icon: Icons.help_outline,
            title: 'Safety Guidelines',
            description: 'Essential safety tips and preventive measures',
            onTap: () {
              Navigator.pushNamed(context, '/safety');
            },
          ),
          const SizedBox(height: 12),
          _buildResourceCard(
            icon: Icons.chat,
            title: 'Chat Support',
            description: 'Talk to our AI assistant for immediate guidance',
            onTap: () {
              Navigator.pushNamed(context, '/chatbot');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResourceCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.blue, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
