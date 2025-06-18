import 'package:flutter/material.dart';

class SafetyScreen extends StatelessWidget {
  const SafetyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.blue[50],
      appBar: AppBar(
        title: Text(
          'Safety Guidelines',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SafetyTipCard(
            title: 'Emergency Contacts',
            tips: [
              'Save emergency numbers (100, 1091, 181) on speed dial',
              'Share live location with trusted contacts during travel',
              'Keep family and friends informed of your whereabouts',
              'Install emergency SOS apps on your phone',
              'Save local police station numbers',
              'Have a trusted emergency contact on speed dial',
            ],
            icon: Icons.emergency,
            color: Colors.blue,
          ),
          SafetyTipCard(
            title: 'Personal Safety',
            tips: [
              'Stay aware of your surroundings at all times',
              'Trust your instincts - if something feels wrong, leave',
              'Keep personal documents secure and make digital copies',
              'Learn basic self-defense techniques',
              'Avoid sharing personal routines with strangers',
              'Keep pepper spray or personal alarm handy',
              'Take well-lit and populated routes',
              'Vary your routine occasionally for unpredictability',
            ],
            icon: Icons.shield,
            color: Colors.blue,
          ),
          SafetyTipCard(
            title: 'Digital Safety',
            tips: [
              'Use strong, unique passwords for all accounts',
              'Enable two-factor authentication everywhere possible',
              'Be careful with personal information online',
              'Regularly update privacy settings on social media',
              'Don\'t share your location on public posts',
              'Be cautious of suspicious links and downloads',
              'Regularly backup important documents',
              'Use a VPN when on public Wi-Fi',
            ],
            icon: Icons.security,
            color: Colors.blue,
          ),
          SafetyTipCard(
            title: 'Home Safety',
            tips: [
              'Install strong locks on all doors and windows',
              'Keep emergency numbers posted in visible places',
              'Have a safety plan and share with family members',
              'Install security cameras or doorbell cameras',
              'Keep outdoor areas well-lit',
              'Don\'t share house keys with strangers',
              'Know your neighbors and build a support network',
            ],
            icon: Icons.home,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}

class SafetyTipCard extends StatelessWidget {
  final String title;
  final List<String> tips;
  final IconData icon;
  final Color color;

  const SafetyTipCard({
    super.key,
    required this.title,
    required this.tips,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: tips
                  .map((tip) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.check_circle, size: 16, color: color),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                tip,
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.grey[300]
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
