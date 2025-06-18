import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:logging/logging.dart';

class EmergencyContactScreen extends StatelessWidget {
  EmergencyContactScreen({super.key}) : _log = Logger('EmergencyContactScreen');

  final Logger _log;

  Future<void> _makeCall(BuildContext context, String number) async {
    final Uri url = Uri.parse('tel:$number');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Your device cannot make phone calls'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      _log.severe('Error making phone call: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not make the call: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Emergency Contacts',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.white],
            stops: [0.0, 0.2],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          children: [
            _buildEmergencySection(
              context,
              'Immediate Help',
              [
                EmergencyContact(
                  'National Emergency',
                  '112',
                  Icons.emergency,
                  'For any emergency situation',
                  isPriority: true,
                ),
                EmergencyContact(
                  'Police',
                  '100',
                  Icons.local_police,
                  'Police emergency response',
                  isPriority: true,
                ),
                EmergencyContact(
                  'Ambulance',
                  '102',
                  Icons.medical_services,
                  'Medical emergency services',
                  isPriority: true,
                ),
              ],
            ),
            _buildEmergencySection(
              context,
              'Women & Child Safety',
              [
                EmergencyContact(
                  'Women Helpline',
                  '1091',
                  Icons.woman,
                  'For women in distress',
                ),
                EmergencyContact(
                  'Domestic Violence',
                  '181',
                  Icons.home,
                  'Domestic abuse support',
                ),
                EmergencyContact(
                  'Child Helpline',
                  '1098',
                  Icons.child_care,
                  'Child protection services',
                ),
              ],
            ),
            _buildEmergencySection(
              context,
              'Other Emergency Services',
              [
                EmergencyContact(
                  'Fire Emergency',
                  '101',
                  Icons.local_fire_department,
                  'Fire and rescue services',
                ),
                EmergencyContact(
                  'Senior Citizen',
                  '14567',
                  Icons.elderly,
                  'Elderly assistance',
                ),
                EmergencyContact(
                  'Railway Protection',
                  '1322',
                  Icons.train,
                  'Railway emergency',
                ),
                EmergencyContact(
                  'Cyber Crime',
                  '1930',
                  Icons.security,
                  'Report cyber crimes',
                ),
                EmergencyContact(
                  'Disaster Management',
                  '108',
                  Icons.warning,
                  'Disaster response',
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _makeCall(context, '112'),
        backgroundColor: Colors.blue,
        label: Row(
          children: [
            Icon(Icons.emergency, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'SOS - 112',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencySection(
    BuildContext context,
    String title,
    List<EmergencyContact> contacts,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        ...contacts.map((contact) => _buildEmergencyCard(context, contact)),
      ],
    );
  }

  Widget _buildEmergencyCard(BuildContext context, EmergencyContact contact) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: contact.isPriority ? Colors.blue.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: contact.isPriority
            ? Border.all(color: Colors.blue.shade200, width: 1)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05.clamp(0.0, 1.0)),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _makeCall(context, contact.number),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: contact.isPriority
                        ? Colors.blue.withOpacity(0.1.clamp(0.0, 1.0))
                        : Colors.grey.withOpacity(0.1.clamp(0.0, 1.0)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    contact.icon,
                    color: contact.isPriority ? Colors.blue : Colors.grey[700],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: contact.isPriority
                              ? Colors.blue.shade700
                              : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        contact.number,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        contact.description,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.phone,
                  color: contact.isPriority ? Colors.blue : Colors.grey[700],
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmergencyContact {
  final String title;
  final String number;
  final IconData icon;
  final String description;
  final bool isPriority;

  EmergencyContact(
    this.title,
    this.number,
    this.icon,
    this.description, {
    this.isPriority = false,
  });
}
