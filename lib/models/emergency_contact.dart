class EmergencyContact {
  final String id;
  final String name;
  final String phoneNumber;
  final String relationship;
  final bool isPrimaryContact;
  final DateTime createdAt;
  final DateTime? updatedAt;

  EmergencyContact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.relationship,
    this.isPrimaryContact = false,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'relationship': relationship,
      'isPrimaryContact': isPrimaryContact ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory EmergencyContact.fromMap(Map<String, dynamic> map) {
    return EmergencyContact(
      id: map['id'],
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      relationship: map['relationship'],
      isPrimaryContact: map['isPrimaryContact'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  EmergencyContact copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? relationship,
    bool? isPrimaryContact,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EmergencyContact(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      relationship: relationship ?? this.relationship,
      isPrimaryContact: isPrimaryContact ?? this.isPrimaryContact,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
