import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'error_handler.dart';
import 'constants.dart';

class FileHandler {
  static Future<Map<String, dynamic>?> pickFile(BuildContext context,
      List<Map<String, dynamic>> currentAttachments) async {
    if (currentAttachments.length >= kMaxAttachments) {
      ErrorHandler.showError(
        context,
        'Maximum attachments limit reached',
      );
      return null;
    }

    try {
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

      if (choice == null) return null;

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
          return await _processPickedFile(context, pickedFile);
        }
      } catch (e) {
        ErrorHandler.showError(
          context,
          'Error picking files: ${ErrorHandler.getErrorMessage(e)}',
        );
      }
    } catch (e) {
      ErrorHandler.showError(
        context,
        'Error picking files: ${ErrorHandler.getErrorMessage(e)}',
      );
    }
    return null;
  }

  static Future<Map<String, dynamic>?> _processPickedFile(
      BuildContext context, XFile file) async {
    try {
      final extension = file.name.split('.').last.toLowerCase();
      final validImageTypes = ['jpg', 'jpeg', 'png'];
      final validVideoTypes = ['mp4'];

      if (!validImageTypes.contains(extension) &&
          !validVideoTypes.contains(extension)) {
        ErrorHandler.showError(
          context,
          'Invalid file type. Only JPG, PNG, and MP4 files are allowed.',
        );
        return null;
      }

      final sizeInMB = await file.length() / (1024 * 1024);
      if (sizeInMB > kMaxFileSizeMB) {
        ErrorHandler.showError(
          context,
          '${file.name} exceeds $kMaxFileSizeMB MB limit',
        );
        return null;
      }

      final bytes = await file.readAsBytes();

      // For images, validate dimensions in a separate isolate
      if (validImageTypes.contains(extension)) {
        try {
          final decodedImage = await compute(decodeImageFromList, bytes);
          if (decodedImage.width > 4096 || decodedImage.height > 4096) {
            ErrorHandler.showError(
              context,
              'Image dimensions too large. Maximum allowed is 4096x4096 pixels.',
            );
            return null;
          }
        } catch (e) {
          ErrorHandler.showError(
            context,
            'Error processing image: Invalid image format',
          );
          return null;
        }
      }

      final fileData = {
        'file': file,
        'name': file.name,
        'size': sizeInMB.toStringAsFixed(2),
        'type': extension,
        'bytes': bytes,
      };

      ErrorHandler.showSuccess(
        context,
        '${validImageTypes.contains(extension) ? 'Image' : 'Video'} added successfully',
      );

      return fileData;
    } catch (e) {
      ErrorHandler.showError(
        context,
        'Error processing file: ${ErrorHandler.getErrorMessage(e)}',
      );
      return null;
    }
  }
}
