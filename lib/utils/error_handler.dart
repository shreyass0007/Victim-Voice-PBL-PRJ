import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ErrorHandler {
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(8),
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(8),
        duration: Duration(seconds: 2),
      ),
    );
  }

  static void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static String getErrorMessage(dynamic error) {
    if (error is Exception) {
      return error.toString().replaceAll('Exception: ', '');
    }
    return error?.toString() ?? 'An unknown error occurred';
  }
}

// Loading overlay widget for async operations
class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? loadingText;

  const LoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.loadingText,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black54,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  if (loadingText != null)
                    Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text(
                        loadingText!,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
