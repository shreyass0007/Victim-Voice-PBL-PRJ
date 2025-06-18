import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:intl/intl.dart';

class ComplaintHistory extends StatefulWidget {
  const ComplaintHistory({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ComplaintHistoryState createState() => _ComplaintHistoryState();
}

class _ComplaintHistoryState extends State<ComplaintHistory> {
  List<Map<String, dynamic>> complaints = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadComplaints();
  }

  Future<void> _loadComplaints() async {
    setState(() => isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final complaintsJson = prefs.getStringList('complaints_history') ?? [];
      complaints = complaintsJson
          .map((json) {
            try {
              return Map<String, dynamic>.from(jsonDecode(json));
            } catch (e) {
              print('Error parsing complaint: $e');
              return <String, dynamic>{};
            }
          })
          .where((complaint) => complaint.isNotEmpty)
          .toList();

      complaints.sort((a, b) {
        final aTime = a['timestamp'] as String?;
        final bTime = b['timestamp'] as String?;
        if (aTime == null || bTime == null) return 0;
        return bTime.compareTo(aTime);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading complaints: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  double _getProgressValue(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 0.25;
      case 'in progress':
        return 0.5;
      case 'under review':
        return 0.75;
      case 'resolved':
        return 1.0;
      default:
        return 0.0;
    }
  }

  void _viewComplaintDetails(Map<String, dynamic> complaint) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          constraints: BoxConstraints(
            maxWidth: 600,
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          decoration: BoxDecoration(
            color: isDark ? Theme.of(context).cardColor : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: isDark ? Border.all(color: Colors.grey[800]!) : null,
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.3)
                    : Colors.blue.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Section with Status Banner
              Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.blue[900]!.withOpacity(0.2)
                      : Colors.blue[50],
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              'Complaint #${complaint['id']}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.blue[300]
                                    : Colors.blue[700],
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close,
                                color: isDark
                                    ? Colors.blue[300]
                                    : Colors.blue[700]),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color:
                              _getStatusColor(complaint['status'] ?? 'Pending')
                                  .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _getStatusColor(
                                    complaint['status'] ?? 'Pending')
                                .withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _getStatusColor(
                                    complaint['status'] ?? 'Pending'),
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              complaint['status'] ?? 'Pending',
                              style: TextStyle(
                                color: _getStatusColor(
                                    complaint['status'] ?? 'Pending'),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Content Section
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoSection(
                        'Timeline',
                        [
                          _buildTimelineInfo(
                            'Submitted',
                            DateFormat('dd MMM yyyy, HH:mm')
                                .format(DateTime.parse(complaint['timestamp'])),
                            Icons.calendar_today,
                          ),
                          _buildTimelineInfo(
                            'Type',
                            complaint['complaintType'] ?? 'N/A',
                            Icons.category,
                          ),
                          _buildTimelineInfo(
                            'Location',
                            complaint['location'] ?? 'N/A',
                            Icons.location_on,
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      _buildInfoSection(
                        'Description',
                        [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.blue[900]!.withOpacity(0.2)
                                  : Colors.blue[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: isDark
                                      ? Colors.blue[700]!
                                      : Colors.blue[100]!),
                            ),
                            child: Text(
                              complaint['description'] ??
                                  'No description provided',
                              style: TextStyle(
                                height: 1.5,
                                color: isDark
                                    ? Colors.blue[300]
                                    : Colors.blue[900],
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (!complaint['isAnonymous']) ...[
                        SizedBox(height: 16),
                        _buildInfoSection(
                          'Personal Details',
                          [
                            _buildDetailInfo('Name', complaint['name'] ?? 'N/A',
                                Icons.person),
                            _buildDetailInfo('Email',
                                complaint['email'] ?? 'N/A', Icons.email),
                            _buildDetailInfo(
                                'Age',
                                complaint['age']?.toString() ?? 'N/A',
                                Icons.cake),
                            _buildDetailInfo('Gender',
                                complaint['gender'] ?? 'N/A', Icons.people),
                          ],
                        ),
                      ],
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _generatePDF(complaint),
                              icon: Icon(Icons.picture_as_pdf),
                              label: Text('Download PDF'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDark
                                    ? Colors.blue[700]
                                    : Colors.blue[700],
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Status update coming soon!')),
                                );
                              },
                              icon: Icon(Icons.update),
                              label: Text('Update Status'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: isDark
                                    ? Colors.blue[300]
                                    : Colors.blue[700],
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: BorderSide(
                                    color: isDark
                                        ? Colors.blue[300]!
                                        : Colors.blue[700]!),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.blue[300] : Colors.blue[700],
          ),
        ),
        SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildTimelineInfo(String label, String value, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  isDark ? Colors.blue[900]!.withOpacity(0.2) : Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: isDark ? Colors.blue[300] : Colors.blue[700],
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.blue[300] : Colors.blue[700],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : Colors.blue[900],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailInfo(String label, String value, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.blue[900]!.withOpacity(0.2) : Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: isDark ? Colors.blue[700]! : Colors.blue[100]!),
      ),
      child: Row(
        children: [
          Icon(icon,
              size: 20, color: isDark ? Colors.blue[300] : Colors.blue[700]),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.blue[300] : Colors.blue[700],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : Colors.blue[900],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _generatePDF(Map<String, dynamic> complaint) async {
    try {
      final pdf = pw.Document();

      // Safely get lists with null checking
      final List<String> accusedNames =
          (complaint['accusedNames'] as List<dynamic>?)
                  ?.map((e) => e?.toString() ?? '')
                  .where((e) => e.isNotEmpty)
                  .toList() ??
              [];

      final List<String> relations = (complaint['relations'] as List<dynamic>?)
              ?.map((e) => e?.toString() ?? '')
              .where((e) => e.isNotEmpty)
              .toList() ??
          [];

      final List<String> platforms = (complaint['platforms'] as List<dynamic>?)
              ?.map((e) => e?.toString() ?? '')
              .where((e) => e.isNotEmpty)
              .toList() ??
          [];

      // Add content to PDF
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              // Header with logo and title
              pw.Header(
                level: 0,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Victim Voice',
                            style: pw.TextStyle(
                                fontSize: 28, fontWeight: pw.FontWeight.bold)),
                        pw.Text('Complaint Details Report',
                            style: pw.TextStyle(
                                fontSize: 16, color: PdfColors.grey700)),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'Generated on:',
                          style: pw.TextStyle(color: PdfColors.grey700),
                        ),
                        pw.Text(
                          DateFormat('dd MMM yyyy, HH:mm')
                              .format(DateTime.now()),
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Complaint ID and Status Section
              pw.Container(
                padding: pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Complaint ID: #${complaint['id']}',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Status: ${complaint['status'] ?? 'Pending'}',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Filing Type Section
              _buildPDFSectionHeader('Filing Type'),
              pw.Container(
                padding: pw.EdgeInsets.all(10),
                decoration: _getPDFBoxDecoration(),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      complaint['isAnonymous']
                          ? 'Anonymous Complaint'
                          : 'Named Complaint',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      'Submitted on: ${DateFormat('dd MMM yyyy, HH:mm').format(DateTime.parse(complaint['timestamp']))}',
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 15),

              // Personal Details Section (if not anonymous)
              if (!complaint['isAnonymous']) ...[
                _buildPDFSectionHeader('Personal Details'),
                pw.Container(
                  padding: pw.EdgeInsets.all(10),
                  decoration: _getPDFBoxDecoration(),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _buildPDFDetailRow('Name', complaint['name'] ?? 'N/A'),
                      _buildPDFDetailRow(
                          'Age', complaint['age']?.toString() ?? 'N/A'),
                      _buildPDFDetailRow(
                          'Gender', complaint['gender'] ?? 'N/A'),
                      _buildPDFDetailRow('Email', complaint['email'] ?? 'N/A'),
                    ],
                  ),
                ),
                pw.SizedBox(height: 15),
              ],

              // Complaint Details Section
              _buildPDFSectionHeader('Complaint Details'),
              pw.Container(
                padding: pw.EdgeInsets.all(10),
                decoration: _getPDFBoxDecoration(),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildPDFDetailRow(
                        'Type', complaint['complaintType'] ?? 'N/A'),
                    _buildPDFDetailRow(
                        'Crime Type', complaint['crimeType'] ?? 'N/A'),
                    _buildPDFDetailRow(
                        'Urgency Level', complaint['urgencyLevel'] ?? 'N/A'),
                    _buildPDFDetailRow(
                        'Severity Level', complaint['severityLevel'] ?? 'N/A'),
                    _buildPDFDetailRow(
                        'Location', complaint['location'] ?? 'N/A'),
                    pw.SizedBox(height: 10),
                    pw.Text('Description:',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Container(
                      padding: pw.EdgeInsets.all(8),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.grey100,
                        borderRadius: pw.BorderRadius.circular(4),
                      ),
                      child: pw.Text(complaint['description'] ?? 'N/A'),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 15),

              // Accused Information Section
              _buildPDFSectionHeader('Accused Information'),
              pw.Container(
                padding: pw.EdgeInsets.all(10),
                decoration: _getPDFBoxDecoration(),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildPDFDetailRow(
                      'Accused Names',
                      accusedNames.isEmpty ? 'N/A' : accusedNames.join(', '),
                    ),
                    if (relations.isNotEmpty)
                      _buildPDFDetailRow(
                          'Relation to Accused', relations.join(', ')),
                    _buildPDFDetailRow('Repeat Offense',
                        complaint['isRepeatOffense'] == true ? 'Yes' : 'No'),
                  ],
                ),
              ),
              pw.SizedBox(height: 15),

              // Cyber Crime Details (if applicable)
              if (complaint['complaintType'] == 'Cyber Crime') ...[
                _buildPDFSectionHeader('Cyber Crime Details'),
                pw.Container(
                  padding: pw.EdgeInsets.all(10),
                  decoration: _getPDFBoxDecoration(),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _buildPDFDetailRow('Cyber Crime Type',
                          complaint['cyberCrimeType'] ?? 'N/A'),
                      _buildPDFDetailRow('Platforms Involved',
                          platforms.isEmpty ? 'N/A' : platforms.join(', ')),
                      _buildPDFDetailRow(
                          'Financial Loss',
                          complaint['financialLoss']?.isNotEmpty == true
                              ? '₹${complaint['financialLoss']}'
                              : 'N/A'),
                      _buildPDFDetailRow('Digital Evidence Available',
                          complaint['hasScreenshots'] == true ? 'Yes' : 'No'),
                      _buildPDFDetailRow(
                          'Evidence Preserved',
                          complaint['evidencePreserved'] == true
                              ? 'Yes'
                              : 'No'),
                      _buildPDFDetailRow('Accounts Secured',
                          complaint['accountsSecured'] == true ? 'Yes' : 'No'),
                      if (complaint['ipAddress']?.isNotEmpty == true)
                        _buildPDFDetailRow(
                            'Suspicious IP', complaint['ipAddress']),
                      if (complaint['suspiciousActivity']?.isNotEmpty == true)
                        _buildPDFDetailRow('Suspicious Activity',
                            complaint['suspiciousActivity']),
                    ],
                  ),
                ),
                pw.SizedBox(height: 15),
              ],

              // Footer
              pw.Divider(color: PdfColors.grey400),
              pw.SizedBox(height: 10),
              pw.Text(
                'This is an official copy of the complaint submission. Please keep this document for your records.',
                style: pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey600,
                  fontStyle: pw.FontStyle.italic,
                ),
                textAlign: pw.TextAlign.center,
              ),
            ];
          },
        ),
      );

      // Save PDF with error handling
      final output = await getTemporaryDirectory();
      final fileName =
          'complaint_${complaint['id'] ?? 'unknown'}_${DateFormat('ddMMyyyy').format(DateTime.now())}.pdf';
      final file = File('${output.path}/$fileName');

      await file.writeAsBytes(await pdf.save());
      final result = await OpenFile.open(file.path);

      if (result.type != ResultType.done) {
        throw Exception('Could not open the PDF: ${result.message}');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF generated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating PDF: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  static pw.Widget _buildPDFSectionHeader(String title) {
    return pw.Container(
      padding: pw.EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue100,
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 16,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.blue800,
        ),
      ),
    );
  }

  static pw.BoxDecoration _getPDFBoxDecoration() {
    return pw.BoxDecoration(
      border: pw.Border.all(color: PdfColors.grey300),
      borderRadius: pw.BorderRadius.circular(8),
    );
  }

  static pw.Widget _buildPDFDetailRow(String label, String value) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 120,
            child: pw.Text(
              '$label:',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Expanded(
            child: pw.Text(value),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Complaint History',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        elevation: 0,
        backgroundColor: isDark
            ? Theme.of(context).appBarTheme.backgroundColor
            : const Color.fromARGB(255, 179, 212, 255),
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black87),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh,
                color: isDark ? Colors.white : Colors.black87),
            onPressed: _loadComplaints,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    Theme.of(context).primaryColor.withOpacity(0.2),
                    Theme.of(context).scaffoldBackgroundColor,
                  ]
                : [
                    Colors.blue[50]!,
                    Colors.white,
                  ],
          ),
        ),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isDark ? Colors.blue[300]! : Colors.blue[700]!,
                  ),
                ),
              )
            : complaints.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Theme.of(context).cardColor
                                : Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: isDark
                                    ? Colors.black.withOpacity(0.3)
                                    : Colors.blue.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.history,
                            size: 64,
                            color: isDark ? Colors.blue[300] : Colors.blue[700],
                          ),
                        ),
                        SizedBox(height: 24),
                        Text(
                          'No complaints submitted yet',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white : Colors.blue[900],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Your complaint history will appear here',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.grey[400] : Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: complaints.length,
                    padding: EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      final complaint = complaints[index];
                      final status = complaint['status'] ?? 'Pending';
                      final statusColor = _getStatusColor(status);
                      final progress = _getProgressValue(status);

                      return Container(
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Theme.of(context).cardColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: isDark
                              ? Border.all(color: Colors.grey[800]!)
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? Colors.black.withOpacity(0.3)
                                  : Colors.blue.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => _viewComplaintDetails(complaint),
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? Colors.blue[900]!
                                                  .withOpacity(0.2)
                                              : Colors.blue[50],
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          'Complaint #${complaint['id']}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: isDark
                                                ? Colors.blue[300]
                                                : Colors.blue[700],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: statusColor.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                color: statusColor,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              status,
                                              style: TextStyle(
                                                color: statusColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: 16,
                                        color: isDark
                                            ? Colors.blue[300]
                                            : Colors.blue[700],
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        DateFormat('dd MMM yyyy, HH:mm').format(
                                          DateTime.parse(
                                              complaint['timestamp']),
                                        ),
                                        style: TextStyle(
                                          color: isDark
                                              ? Colors.blue[300]
                                              : Colors.blue[700],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: LinearProgressIndicator(
                                      value: progress,
                                      backgroundColor: isDark
                                          ? Colors.blue[900]!.withOpacity(0.2)
                                          : Colors.blue[50],
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        _getProgressColor(progress),
                                      ),
                                      minHeight: 8,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildActionButton(
                                        context,
                                        icon: Icons.visibility,
                                        label: 'View Details',
                                        onPressed: () =>
                                            _viewComplaintDetails(complaint),
                                      ),
                                      _buildActionButton(
                                        context,
                                        icon: Icons.picture_as_pdf,
                                        label: 'Download PDF',
                                        onPressed: () =>
                                            _generatePDF(complaint),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 20,
        color: isDark ? Colors.blue[300] : Colors.blue[700],
      ),
      label: Text(
        label,
        style: TextStyle(
          color: isDark ? Colors.blue[300] : Colors.blue[700],
          fontWeight: FontWeight.w500,
        ),
      ),
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.blue[300]!;
      case 'in progress':
        return Colors.blue[500]!;
      case 'under review':
        return Colors.blue[700]!;
      case 'resolved':
        return Colors.blue[900]!;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.blue[300]!;
    }
  }

  Color _getProgressColor(double progress) {
    if (progress <= 0.25) {
      return Colors.blue[300]!;
    }
    if (progress <= 0.5) {
      return Colors.blue[500]!;
    }
    if (progress <= 0.75) {
      return Colors.blue[700]!;
    }
    return Colors.blue[900]!;
  }
}
