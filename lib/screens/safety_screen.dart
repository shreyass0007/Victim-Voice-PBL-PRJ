import 'package:flutter/material.dart';

class SafetyScreen extends StatelessWidget {
  const SafetyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safety Guidelines'),
        backgroundColor: const Color.fromARGB(255, 179, 212, 255),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          SafetyTipCard(
            title: 'Emergency Contacts',
            tips: [
              'Save emergency numbers on speed dial',
              'Share location with trusted contacts',
              'Keep family and friends informed of your whereabouts',
            ],
          ),
          SafetyTipCard(
            title: 'Personal Safety',
            tips: [
              'Stay aware of your surroundings',
              'Trust your instincts',
              'Keep personal documents secure',
              'Learn basic self-defense techniques',
            ],
          ),
          SafetyTipCard(
            title: 'Digital Safety',
            tips: [
              'Use strong passwords',
              'Enable two-factor authentication',
              'Be careful with personal information online',
              'Regularly update privacy settings',
            ],
          ),
        ],
      ),
    );
  }
}

class SafetyTipCard extends StatelessWidget {
  final String title;
  final List<String> tips;

  const SafetyTipCard({
    super.key,
    required this.title,
    required this.tips,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...tips.map((tip) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle, 
                        color: Colors.green, 
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          tip,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
} 