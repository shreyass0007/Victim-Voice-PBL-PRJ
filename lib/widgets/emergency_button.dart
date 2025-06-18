import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/database_service.dart';
import '../models/emergency_contact.dart';

class EmergencyButton extends StatefulWidget {
  const EmergencyButton({super.key});

  @override
  State<EmergencyButton> createState() => _EmergencyButtonState();
}

class _EmergencyButtonState extends State<EmergencyButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final DatabaseService _databaseService = DatabaseService();
  bool _isExpanded = false;
  bool _isLoading = false;
  List<EmergencyContact> _primaryContacts = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _loadPrimaryContacts();
  }

  Future<void> _loadPrimaryContacts() async {
    setState(() => _isLoading = true);
    try {
      final contacts = await _databaseService.getPrimaryContacts();
      setState(() => _primaryContacts = contacts);
    } catch (e) {
      debugPrint('Error loading primary contacts: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _callEmergencyNumber(String number) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  void _toggleExpanded() {
    setState(() => _isExpanded = !_isExpanded);
    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _showEmergencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red[700], size: 28),
            const SizedBox(width: 8),
            const Text('Emergency Options'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_primaryContacts.isEmpty)
              const Text(
                'No primary emergency contacts found. Please add emergency contacts in settings.',
                textAlign: TextAlign.center,
              )
            else
              ..._primaryContacts.map(
                (contact) => ListTile(
                  leading: const Icon(Icons.phone, color: Colors.green),
                  title: Text(contact.name),
                  subtitle: Text(contact.phoneNumber),
                  onTap: () {
                    Navigator.pop(context);
                    _callEmergencyNumber(contact.phoneNumber);
                  },
                ),
              ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.local_police, color: Colors.blue),
              title: const Text('Police'),
              subtitle: const Text('100'),
              onTap: () {
                Navigator.pop(context);
                _callEmergencyNumber('100');
              },
            ),
            ListTile(
              leading: const Icon(Icons.emergency, color: Colors.red),
              title: const Text('Ambulance'),
              subtitle: const Text('108'),
              onTap: () {
                Navigator.pop(context);
                _callEmergencyNumber('108');
              },
            ),
            ListTile(
              leading: const Icon(Icons.woman, color: Colors.blue),
              title: const Text('Women\'s Helpline'),
              subtitle: const Text('1091'),
              onTap: () {
                Navigator.pop(context);
                _callEmergencyNumber('1091');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showEmergencyDialog,
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.red[700]!, Colors.red[900]!],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.emergency,
            color: Colors.white,
            size: 32,
          ),
        ),
      ),
    );
  }
}
