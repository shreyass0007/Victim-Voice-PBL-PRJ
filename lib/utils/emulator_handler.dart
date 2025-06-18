import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class EmulatorHandler {
  static Future<bool> isEmulator() async {
    if (!kIsWeb) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.isPhysicalDevice == false;
    }
    return false;
  }

  static Future<void> handleEmulatorSubmission(
      BuildContext context, String message) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Testing on Emulator'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('You are running on an emulator. Choose an option:'),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy message to clipboard'),
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: message));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Message copied to clipboard')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('View message'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Message Content'),
                    content: SingleChildScrollView(
                      child: Text(message),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
