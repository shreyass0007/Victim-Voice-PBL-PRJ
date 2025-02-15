import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support Services'),
        backgroundColor: const Color.fromARGB(255, 179, 212, 255),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          SupportServiceCard(
            title: 'Counseling Services',
            contact: '+91 1234567890',
            description: '24/7 professional counseling support',
          ),
          SupportServiceCard(
            title: 'Legal Aid Center',
            contact: '+91 9876543210',
            description: 'Free legal consultation and support',
          ),
          SupportServiceCard(
            title: 'Women\'s Helpline',
            contact: '1091',
            description: 'Immediate assistance for women in distress',
          ),
          SupportServiceCard(
            title: 'NGO Support',
            contact: '+91 8765432109',
            description: 'Local NGO providing victim support services',
          ),
        ],
      ),
    );
  }
}

class SupportServiceCard extends StatelessWidget {
  final String title;
  final String contact;
  final String description;

  const SupportServiceCard({
    super.key,
    required this.title,
    required this.contact,
    required this.description,
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
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Contact: $contact',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 