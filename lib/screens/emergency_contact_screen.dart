import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyContactScreen extends StatelessWidget {
  const EmergencyContactScreen({super.key});

  Future<void> _makeCall(String number) async {
    final Uri url = Uri.parse('tel:$number');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Contacts'),
        backgroundColor: const Color.fromARGB(255, 179, 212, 255),
      ),
      body: SingleChildScrollView(
        child: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            _buildEmergencyCard(
              'Police Emergency',
              '100',
              Icons.local_police,
              onTap: () => _makeCall('100'),
            ),
            _buildEmergencyCard(
              'Women Helpline',
              '1091',
              Icons.woman,
              onTap: () => _makeCall('1091'),
            ),
            _buildEmergencyCard(
              'Ambulance',
              '102',
              Icons.medical_services,
              onTap: () => _makeCall('102'),
            ),
            _buildEmergencyCard(
              'Domestic Violence Helpline',
              '181',
              Icons.home,
              onTap: () => _makeCall('181'),
            ),
            _buildEmergencyCard(
              'Child Helpline',
              '1098',
              Icons.child_care,
              onTap: () => _makeCall('1098'),
            ),
            _buildEmergencyCard(
              'Senior Citizen Helpline',
              '14567',
              Icons.elderly,
              onTap: () => _makeCall('14567'),
            ),
            _buildEmergencyCard(
              'National Emergency',
              '112',
              Icons.emergency,
              onTap: () => _makeCall('112'),
            ),
            _buildEmergencyCard(
              'Fire Emergency',
              '101',
              Icons.local_fire_department,
              onTap: () => _makeCall('101'),
            ),
            _buildEmergencyCard(
              'Railway Protection',
              '1322',
              Icons.train,
              onTap: () => _makeCall('1322'),
            ),
            _buildEmergencyCard(
              'Cyber Crime',
              '1930',
              Icons.computer,
              onTap: () => _makeCall('1930'),
            ),
            _buildEmergencyCard(
              'Anti-Poison',
              '1066',
              Icons.medical_services,
              onTap: () => _makeCall('1066'),
            ),
            _buildEmergencyCard(
              'Disaster Management',
              '108',
              Icons.warning,
              onTap: () => _makeCall('108'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyCard(String title, String number, IconData icon,
      {required VoidCallback onTap}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, color: Colors.red, size: 32),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(number),
        trailing: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('CALL', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
