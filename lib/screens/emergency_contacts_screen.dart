import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/emergency_contact.dart';
import '../services/database_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/validation_utils.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  State<EmergencyContactsScreen> createState() =>
      _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  final DatabaseService _databaseService = DatabaseService();
  List<EmergencyContact> _contacts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    setState(() => _isLoading = true);
    try {
      final contacts = await _databaseService.getAllContacts();
      if (mounted) {
        setState(() => _contacts = contacts);
      }
    } catch (e) {
      debugPrint('Error loading contacts: $e');
      if (mounted) {
        _showErrorSnackBar('Failed to load contacts: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  Future<void> _addOrEditContact([EmergencyContact? contact]) async {
    try {
      final result = await showDialog<EmergencyContact>(
        context: context,
        barrierDismissible: true,
        builder: (context) => ContactDialog(contact: contact),
      );

      if (result != null && mounted) {
        setState(() => _isLoading = true);
        try {
          if (contact == null) {
            await _databaseService.insertContact(result);
          } else {
            await _databaseService.updateContact(result);
          }
          await _loadContacts();
        } catch (e) {
          debugPrint('Error saving contact: $e');
          _showErrorSnackBar('Failed to save contact: ${e.toString()}');
        }
      }
    } catch (e) {
      debugPrint('Error showing contact dialog: $e');
      _showErrorSnackBar('Failed to open contact dialog: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _deleteContact(EmergencyContact contact) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Contact'),
        content: Text('Are you sure you want to delete ${contact.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);
      try {
        await _databaseService.deleteContact(contact.id);
        await _loadContacts();
      } catch (e) {
        _showErrorSnackBar('Failed to delete contact');
      }
    }
  }

  Future<void> _callContact(EmergencyContact contact) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: contact.phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      _showErrorSnackBar('Could not launch phone call');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Contacts'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.blue.shade300],
            ),
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue[700]),
                      const SizedBox(width: 8),
                      const Text('About Emergency Contacts'),
                    ],
                  ),
                  content: const Text(
                    'Add trusted contacts who will be notified in case of emergencies. You can set one contact as primary, who will be contacted first.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('GOT IT'),
                    ),
                  ],
                ),
              );
            },
            tooltip: 'About Emergency Contacts',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadContacts();
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue[50]!,
                Colors.white,
              ],
            ),
          ),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(16.0),
                      sliver: _contacts.isEmpty
                          ? SliverFillRemaining(
                              hasScrollBody: false,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TweenAnimationBuilder<double>(
                                      tween: Tween(begin: 0.0, end: 1.0),
                                      duration: const Duration(milliseconds: 800),
                                      curve: Curves.easeOutBack,
                                      builder: (context, value, child) {
                                        return Transform.scale(
                                          scale: value,
                                          child: Container(
                                            padding: const EdgeInsets.all(24),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(16),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.blue.withOpacity(0.1),
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.contacts_outlined,
                                                  size: 64,
                                                  color: Colors.blue[300],
                                                ),
                                                const SizedBox(height: 16),
                                                Text(
                                                  'No Emergency Contacts',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.blue[700],
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  'Add your trusted contacts for emergencies',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.blue[400],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 32),
                                    ElevatedButton.icon(
                                      onPressed: () => _addOrEditContact(),
                                      icon: const Icon(Icons.add),
                                      label: const Text('Add Contact'),
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 32, vertical: 16),
                                        backgroundColor: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final contact = _contacts[index];
                                  return TweenAnimationBuilder<double>(
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOutBack,
                                    builder: (context, value, child) {
                                      return Transform.translate(
                                        offset: Offset(0, 20 * (1 - value.clamp(0.0, 1.0))),
                                        child: Opacity(
                                          opacity: value.clamp(0.0, 1.0),
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 16),
                                            child: Card(
                                              elevation: 4,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                              child: InkWell(
                                                onTap: () => _addOrEditContact(contact),
                                                borderRadius: BorderRadius.circular(16),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(16),
                                                    gradient: LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomRight,
                                                      colors: [
                                                        contact.isPrimaryContact
                                                            ? Colors.red[50]!
                                                            : Colors.blue[50]!,
                                                        Colors.white,
                                                      ],
                                                    ),
                                                  ),
                                                  child: ListTile(
                                                    contentPadding:
                                                        const EdgeInsets.all(16),
                                                    leading: Container(
                                                      padding: const EdgeInsets.all(8),
                                                      decoration: BoxDecoration(
                                                        color: contact.isPrimaryContact
                                                            ? Colors.red[100]
                                                            : Colors.blue[100],
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Icon(
                                                        Icons.person,
                                                        size: 28,
                                                        color: contact.isPrimaryContact
                                                            ? Colors.red
                                                            : Colors.blue,
                                                      ),
                                                    ),
                                                    title: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            contact.name,
                                                            style: const TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        ),
                                                        if (contact.isPrimaryContact)
                                                          Container(
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                                    horizontal: 8,
                                                                    vertical: 4),
                                                            decoration: BoxDecoration(
                                                              color: Colors.red[100],
                                                              borderRadius:
                                                                  BorderRadius.circular(12),
                                                            ),
                                                            child: Text(
                                                              'Primary',
                                                              style: TextStyle(
                                                                color: Colors.red[700],
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                    subtitle: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        const SizedBox(height: 8),
                                                        Text(
                                                          contact.relationship,
                                                          style: TextStyle(
                                                            color: Colors.grey[600],
                                                          ),
                                                        ),
                                                        const SizedBox(height: 4),
                                                        Text(
                                                          contact.phoneNumber,
                                                          style: TextStyle(
                                                            color: Colors.grey[800],
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    trailing: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        IconButton(
                                                          icon: const Icon(Icons.phone),
                                                          color: Colors.green,
                                                          onPressed: () => _callContact(contact),
                                                        ),
                                                        IconButton(
                                                          icon: const Icon(Icons.delete),
                                                          color: Colors.red,
                                                          onPressed: () => _deleteContact(contact),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                childCount: _contacts.length,
                              ),
                            ),
                    ),
                  ],
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditContact(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ContactDialog extends StatefulWidget {
  final EmergencyContact? contact;

  const ContactDialog({super.key, this.contact});

  @override
  State<ContactDialog> createState() => _ContactDialogState();
}

class _ContactDialogState extends State<ContactDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _relationshipController;
  late bool _isPrimaryContact;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact?.name);
    _phoneController = TextEditingController(text: widget.contact?.phoneNumber);
    _relationshipController =
        TextEditingController(text: widget.contact?.relationship);
    _isPrimaryContact = widget.contact?.isPrimaryContact ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _relationshipController.dispose();
    super.dispose();
  }

  String? _validatePhone(String? value) {
    return ValidationUtils.validatePhone(value);
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final contact = EmergencyContact(
        id: widget.contact?.id ?? const Uuid().v4(),
        name: _nameController.text,
        phoneNumber: _phoneController.text,
        relationship: _relationshipController.text,
        isPrimaryContact: _isPrimaryContact,
        createdAt: widget.contact?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );
      Navigator.pop(context, contact);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue, Colors.blue.shade300],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.contact == null ? Icons.person_add : Icons.edit,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.contact == null
                        ? 'Add Emergency Contact'
                        : 'Edit Emergency Contact',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Contact Name',
                              icon: Icon(Icons.person, color: Colors.blue[700]),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                            validator: (value) => value?.isEmpty ?? true
                                ? 'Please enter a name'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              icon: Icon(Icons.phone, color: Colors.blue[700]),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                            validator: _validatePhone,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _relationshipController,
                            decoration: InputDecoration(
                              labelText: 'Relationship',
                              icon: Icon(Icons.people, color: Colors.blue[700]),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                            validator: (value) => value?.isEmpty ?? true
                                ? 'Please enter relationship'
                                : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red[200]!),
                      ),
                      child: SwitchListTile(
                        title: Text(
                          'Primary Emergency Contact',
                          style: TextStyle(
                            color: Colors.red[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'This contact will be called first in emergencies',
                          style: TextStyle(color: Colors.red[700]),
                        ),
                        value: _isPrimaryContact,
                        onChanged: (bool value) {
                          setState(() => _isPrimaryContact = value);
                        },
                        activeColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('CANCEL'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('SAVE'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
