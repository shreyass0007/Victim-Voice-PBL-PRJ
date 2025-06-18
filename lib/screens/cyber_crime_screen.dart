import 'package:flutter/material.dart';

class CyberCrimeScreen extends StatelessWidget {
  const CyberCrimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cyber Crime Help'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(
              'Report Cyber Crime',
              'If you\'ve been a victim of cybercrime, you can:',
              [
                'File an online complaint at cybercrime.gov.in',
                'Call the National Cyber Crime Reporting Portal at 1930',
                'Visit your nearest cyber crime police station',
              ],
              Icons.report_problem,
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              'Common Cyber Crimes',
              'Be aware of these common cyber crimes:',
              [
                'Online harassment and cyberstalking',
                'Identity theft and financial fraud',
                'Social media account hacking',
                'Phishing and email scams',
                'Online sexual harassment',
              ],
              Icons.warning,
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              'Safety Tips',
              'Protect yourself online with these tips:',
              [
                'Use strong, unique passwords',
                'Enable two-factor authentication',
                'Be careful with personal information',
                'Don\'t click suspicious links',
                'Keep software and apps updated',
              ],
              Icons.security,
            ),
            const SizedBox(height: 16),
            _buildEmergencyButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      String title, String subtitle, List<String> points, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 24, color: const Color(0xFF2196F3)),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            ...points.map((point) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle,
                          size: 16, color: Color(0xFF2196F3)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(point),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pushNamed(context, '/emergencyContact');
        },
        icon: const Icon(Icons.emergency),
        label: const Text('Emergency Contacts'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
