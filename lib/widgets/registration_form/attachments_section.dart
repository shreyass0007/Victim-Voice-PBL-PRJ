import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/constants.dart';
import '../../utils/web_utils.dart';

class AttachmentsSection extends StatelessWidget {
  final List<Map<String, dynamic>> attachments;
  final Function(Map<String, dynamic>) onFileSelected;
  final Function(int) onRemoveAttachment;

  const AttachmentsSection({
    super.key,
    required this.attachments,
    required this.onFileSelected,
    required this.onRemoveAttachment,
  });

  Future<void> _pickFile(BuildContext context) async {
    if (attachments.length >= kMaxAttachments) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum attachments limit reached')),
      );
      return;
    }

    final choice = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose File Type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_camera, color: kPrimaryColor),
                title: const Text('Take Photo'),
                subtitle: Text('Using Camera (Max ${kMaxFileSizeMB}MB)'),
                onTap: () => Navigator.pop(context, 'camera'),
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: kPrimaryColor),
                title: const Text('Choose Photo'),
                subtitle: Text('From Gallery (Max ${kMaxFileSizeMB}MB)'),
                onTap: () => Navigator.pop(context, 'gallery'),
              ),
              ListTile(
                leading: Icon(Icons.videocam, color: kPrimaryColor),
                title: const Text('Record Video'),
                subtitle: Text('Using Camera (Max ${kMaxFileSizeMB}MB)'),
                onTap: () => Navigator.pop(context, 'video_camera'),
              ),
              ListTile(
                leading: Icon(Icons.video_library, color: kPrimaryColor),
                title: const Text('Choose Video'),
                subtitle: Text('From Gallery (Max ${kMaxFileSizeMB}MB)'),
                onTap: () => Navigator.pop(context, 'video_gallery'),
              ),
            ],
          ),
        );
      },
    );

    if (choice == null) return;

    try {
      final ImagePicker picker = ImagePicker();
      XFile? pickedFile;

      switch (choice) {
        case 'camera':
          pickedFile = await picker.pickImage(
            source: ImageSource.camera,
            imageQuality: 70,
            maxWidth: 1920,
            maxHeight: 1080,
          );
          break;
        case 'gallery':
          pickedFile = await picker.pickImage(
            source: ImageSource.gallery,
            imageQuality: 70,
            maxWidth: 1920,
            maxHeight: 1080,
          );
          break;
        case 'video_camera':
          pickedFile = await picker.pickVideo(
            source: ImageSource.camera,
            maxDuration: const Duration(minutes: 5),
          );
          break;
        case 'video_gallery':
          pickedFile = await picker.pickVideo(
            source: ImageSource.gallery,
            maxDuration: const Duration(minutes: 5),
          );
          break;
      }

      if (pickedFile != null) {
        await _processFile(context, pickedFile);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  Future<void> _processFile(BuildContext context, XFile file) async {
    try {
      final bytes = await file.readAsBytes();
      final sizeInMB = bytes.length / (1024 * 1024);
      
      if (sizeInMB > kMaxFileSizeMB) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File exceeds ${kMaxFileSizeMB}MB limit')),
        );
        return;
      }

      final extension = file.name.split('.').last.toLowerCase();
      final isVideo = extension == 'mp4';
      final isImage = ['jpg', 'jpeg', 'png'].contains(extension);

      if (!isVideo && !isImage) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unsupported file type. Only images and videos are allowed.')),
        );
        return;
      }

      final fileData = {
        'name': file.name,
        'size': sizeInMB.toStringAsFixed(2),
        'type': extension,
        'bytes': bytes,
      };

      onFileSelected(fileData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${isVideo ? 'Video' : 'Image'} added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing file: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Evidence',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(
          'Allowed files: Images (JPG, PNG), Videos (MP4) - Max ${kMaxFileSizeMB}MB each',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _pickFile(context),
                icon: Icon(Icons.add_a_photo, color: kPrimaryColor),
                label: Text(
                  'Add Evidence (${attachments.length}/$kMaxAttachments)',
                  style: TextStyle(fontSize: 16, color: kPrimaryColor),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (attachments.isNotEmpty)
          _buildAttachmentsList()
        else
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                'No evidence added',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAttachmentsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: attachments.length,
      itemBuilder: (context, index) {
        final attachment = attachments[index];
        final isVideo = attachment['type']?.toString().toLowerCase() == 'mp4';
        
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: Icon(
              isVideo ? Icons.video_file : Icons.image,
              color: kPrimaryColor,
            ),
            title: Text(
              attachment['name'] ?? 'Unknown file',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text('${attachment['size']} MB'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (kIsWeb && attachment['bytes'] != null)
                  IconButton(
                    icon: const Icon(Icons.visibility, color: Colors.blue),
                    onPressed: () => _previewFile(attachment),
                  ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => onRemoveAttachment(index),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _previewFile(Map<String, dynamic> attachment) {
    if (kIsWeb && attachment['bytes'] != null) {
      WebUtils.previewFileBytes(attachment['bytes']);
    }
  }
}
