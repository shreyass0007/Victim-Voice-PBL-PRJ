import 'package:flutter/foundation.dart';

class WebUtils {
  static void previewFileBytes(List<int> bytes) {
    if (kIsWeb) {
      // This code will only be included in web builds
      try {
        // ignore: undefined_prefixed_name
        dynamic html = kIsWeb ? Uri.base : null;
        if (html != null) {
          // ignore: undefined_prefixed_name
          final blob = html.Blob([bytes]);
          // ignore: undefined_prefixed_name
          final url = html.Url.createObjectUrlFromBlob(blob);
          // ignore: undefined_prefixed_name
          html.window.open(url, '_blank');
          // Revoke the URL after a delay
          Future.delayed(Duration(seconds: 1), () {
            // ignore: undefined_prefixed_name
            html.Url.revokeObjectUrl(url);
          });
        }
      } catch (e) {
        // Handle any errors that might occur
        debugPrint('Error previewing file: $e');
      }
    }
  }
}
