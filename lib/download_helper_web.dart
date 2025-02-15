// download_helper_web.dart
import 'dart:html' as html;

/// Downloads [bytes] as a PDF file with the given [filename].
void downloadFile(List<int> bytes, String filename) {
  final blob = html.Blob([bytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.AnchorElement(href: url)
    ..download = filename
    ..click();
  html.Url.revokeObjectUrl(url);
}
