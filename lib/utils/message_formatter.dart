class MessageFormatter {
  static String formatComplaintMessage({
    required bool isAnonymous,
    required String complaintType,
    required String description,
    String? date,
    String? location,
    required List<String> accusedNames,
    String? name,
    String? age,
    String? gender,
    String? email,
    String? crimeType,
    String? urgency,
    String? witnessName,
    String? witnessContact,
    required List<Map<String, dynamic>> attachments,
    String? severityLevel,
    required List<String> relations,
    required bool isRepeatOffense,
    String? policeReport,
    String? cyberCrimeType,
    required List<String> platforms,
    required List<String> impacts,
    String? financialLoss,
    required bool hasScreenshots,
    required bool evidencePreserved,
    required bool accountsSecured,
    String? deviceInfo,
    String? ipAddress,
    String? suspiciousActivity,
  }) {
    final StringBuffer buffer = StringBuffer();

    // Header
    buffer.writeln('COMPLAINT REPORT');
    buffer.writeln('================');
    buffer.writeln('Date: ${DateTime.now().toString()}');
    buffer.writeln('Filing Type: ${isAnonymous ? "Anonymous" : "Named"}');
    buffer.writeln();

    // Personal Information (if not anonymous)
    if (!isAnonymous) {
      buffer.writeln('PERSONAL INFORMATION');
      buffer.writeln('-------------------');
      buffer.writeln('Name: ${name ?? "Not provided"}');
      buffer.writeln('Age: ${age ?? "Not provided"}');
      buffer.writeln('Gender: ${gender ?? "Not provided"}');
      buffer.writeln('Email: ${email ?? "Not provided"}');
      buffer.writeln();
    }

    // Complaint Details
    buffer.writeln('COMPLAINT DETAILS');
    buffer.writeln('----------------');
    buffer.writeln('Type: $complaintType');
    buffer.writeln('Crime Type: ${crimeType ?? "Not specified"}');
    buffer.writeln('Urgency Level: ${urgency ?? "Not specified"}');
    buffer.writeln('Severity Level: ${severityLevel ?? "Not specified"}');
    buffer.writeln('Date of Incident: ${date ?? "Not specified"}');
    buffer.writeln('Location: ${location ?? "Not specified"}');
    buffer.writeln();

    // Description
    buffer.writeln('INCIDENT DESCRIPTION');
    buffer.writeln('-------------------');
    buffer.writeln(description);
    buffer.writeln();

    // Accused Information
    buffer.writeln('ACCUSED INFORMATION');
    buffer.writeln('------------------');
    if (accusedNames.isNotEmpty) {
      for (int i = 0; i < accusedNames.length; i++) {
        buffer.writeln('Accused ${i + 1}: ${accusedNames[i]}');
      }
    } else {
      buffer.writeln('No accused persons listed');
    }
    buffer.writeln();

    // Witness Information
    if (witnessName?.isNotEmpty == true || witnessContact?.isNotEmpty == true) {
      buffer.writeln('WITNESS INFORMATION');
      buffer.writeln('------------------');
      buffer.writeln('Name: ${witnessName ?? "Not provided"}');
      buffer.writeln('Contact: ${witnessContact ?? "Not provided"}');
      buffer.writeln();
    }

    // Relations and Repeat Offense
    buffer.writeln('ADDITIONAL INFORMATION');
    buffer.writeln('---------------------');
    if (relations.isNotEmpty) {
      buffer.writeln('Relations: ${relations.join(", ")}');
    }
    buffer.writeln('Repeat Offense: ${isRepeatOffense ? "Yes" : "No"}');
    if (policeReport?.isNotEmpty == true) {
      buffer.writeln('Police Report: $policeReport');
    }
    buffer.writeln();

    // Cyber Crime Specific Details
    if (complaintType == 'Cyber Crime') {
      buffer.writeln('CYBER CRIME DETAILS');
      buffer.writeln('------------------');
      buffer.writeln('Type: ${cyberCrimeType ?? "Not specified"}');
      if (platforms.isNotEmpty) {
        buffer.writeln('Platforms: ${platforms.join(", ")}');
      }
      if (impacts.isNotEmpty) {
        buffer.writeln('Impacts: ${impacts.join(", ")}');
      }
      buffer.writeln('Financial Loss: ${financialLoss ?? "Not specified"}');
      buffer.writeln('Screenshots Available: ${hasScreenshots ? "Yes" : "No"}');
      buffer.writeln('Evidence Preserved: ${evidencePreserved ? "Yes" : "No"}');
      buffer.writeln('Accounts Secured: ${accountsSecured ? "Yes" : "No"}');
      buffer.writeln('Device Info: ${deviceInfo ?? "Not provided"}');
      buffer.writeln('IP Address: ${ipAddress ?? "Not provided"}');
      if (suspiciousActivity?.isNotEmpty == true) {
        buffer.writeln('Suspicious Activity: $suspiciousActivity');
      }
      buffer.writeln();
    }

    // Attachments
    if (attachments.isNotEmpty) {
      buffer.writeln('ATTACHMENTS');
      buffer.writeln('----------');
      for (var attachment in attachments) {
        buffer.writeln('- ${attachment['name'] ?? "Unnamed attachment"}');
      }
      buffer.writeln();
    }

    return buffer.toString();
  }
}
