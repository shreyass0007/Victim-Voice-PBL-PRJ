import 'package:flutter/material.dart';

class RightsScreen extends StatelessWidget {
  const RightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Know Your Rights'),
        backgroundColor: const Color.fromARGB(255, 179, 212, 255),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          RightCard(
            title: 'Right to File FIR',
            description: 'You have the right to file an FIR at any police station, regardless of jurisdiction.',
          ),
          RightCard(
            title: 'Right to Legal Aid',
            description: 'You have the right to free legal assistance and representation.',
          ),
          RightCard(
            title: 'Right to Medical Treatment',
            description: 'Hospitals must provide immediate medical assistance to victims.',
          ),
          RightCard(
            title: 'Right to Privacy',
            description: 'Your identity and personal information will be protected throughout the process.',
          ),
        ],
      ),
    );
  }
}

class RightCard extends StatelessWidget {
  final String title;
  final String description;

  const RightCard({
    super.key,
    required this.title,
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
          ],
        ),
      ),
    );
  }
} 